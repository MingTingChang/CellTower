//
//  GameMap.m
//  CellTower
//
//  Created by 刘挺 on 15-3-20.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "GameMap.h"
#import "Map.h"
#import "Creature.h"
#import "CTGeometryTool.h"
#import "Tower.h"
#import "RadarTower.h"
#import "ShockTower.h"
#import "SlowDownTower.h"
#import "AirTower.h"

//默认单元栅格像素
#define MapGridPixelNormalValue 12

@interface GameMap() <TowerDelegate>

@property (nonatomic , strong) Map *map;

@property (nonatomic , assign) int gridPixel;

@property (nonatomic , assign) MapType type;

@property (nonatomic , strong) NSMutableArray *creatures;

@property (nonatomic , strong) NSMutableArray *towers;

@property (nonatomic , strong) NSMutableArray *towerModels;

@property (nonatomic , strong) NSMutableArray *creatureModels;

@property (nonatomic , strong) NSMutableSet *creatureGridPoints;

@property (nonatomic , strong) NSOperationQueue *queue;

@end

@implementation GameMap
#pragma mark - 初始化方法
- (instancetype)initWithImageNamed:(NSString *)name gridPixel:(int)gridPixel
                           mapType:(MapType)type
{
    if (self = [super initWithImageNamed:name]) {
        self.gold = 5000;
        self.size = CGSizeMake(300, 300);
        self.type = type;
        self.gridPixel = gridPixel;
        self.curWaveNum = 1;
        self.creatures = [NSMutableArray array];
        self.towers = [NSMutableArray array];
        self.creatureGridPoints = [NSMutableSet set];
        self.userInteractionEnabled = YES;
        self.queue = [[NSOperationQueue alloc] init];

        // 加载塔模型
        self.towerModels = [NSMutableArray array];
        for (int i = 0; i < TowerTypeNumber; i++) {
            TowerModel *model = [TowerModel towerModelWithType:i];
            [self.towerModels addObject:model];
        }
        // 加载妖怪模型
        self.creatureModels = [NSMutableArray array];
        for (int i = 0; i < CreatureTypeNumber; i++) {
            CreatureModel *model = [CreatureModel creatureModelWithType:i];
            [self.creatureModels addObject:model];
        }
        
        [self test];
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(test2) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (instancetype)initWithImageNamed:(NSString *)name mapType:(MapType)type
{
    return [self initWithImageNamed:name gridPixel:MapGridPixelNormalValue mapType:type];
}

+ (instancetype)spriteNodeWithImageNamed:(NSString *)name gridPixel:(int)gridPixel
                                 mapType:(MapType)type
{
    return [[self alloc] initWithImageNamed:name gridPixel:gridPixel mapType:type];
}

+ (instancetype)spriteNodeWithImageNamed:(NSString *)name mapType:(MapType)type
{
    return [self spriteNodeWithImageNamed:name gridPixel:MapGridPixelNormalValue mapType:type];
}

#pragma mark - 对象方法
#pragma mark 建造塔
- (void)addTowerWithType:(TowerType)type point:(CGPoint)point
{

    if (_map == nil) {
        [self setupGridMap];
    }
    
    // 获取塔4个栅格点的左上角栅格坐标
    CGPoint gridHeadPoint = [self gridHeadPointAroundPixelPoint:point];
    
    
    // 判断该坐标能不能造塔
    BOOL canBulid = YES;
    for (int y = 0; (y <= 1) && canBulid; y++) {
        for (int x = 0; (x <= 1) && canBulid; x++) {
            CGPoint pos = CGPointMake(gridHeadPoint.x + x, gridHeadPoint.y + y);
            for (MapPoint *mapPoint in _map.walls) {
                if (CGPointEqualToPoint(mapPoint.point, pos)) {
                    canBulid = NO;
                    break;
                }
            }
            for (Creature *creature in self.creatures) {
                CGPoint gridPoint = [CTGeometryTool gridPointFromPixelPoint:creature.position gridPixel:_gridPixel];
                if (CGPointEqualToPoint(pos, gridPoint)) {
                    canBulid = NO;
                    break;
                }
            }
        }
    }
    TowerModel *towerModel = self.towerModels[type];
    if ((canBulid == NO)||(self.gold < towerModel.bulidCoin)) {
        [self failToBulidTower];
        return;
    }
    
    Map *map = [Map copyWithMap:_map];
    
    // 把造塔的地方当做墙，加入到walls集合中
    for (int y = 0; y <= 1; y++) {
        for (int x = 0; x <= 1; x++) {
            CGPoint pos = CGPointMake(gridHeadPoint.x + x, gridHeadPoint.y + y);
            [_map addMapWallWithPoint:pos];
        }
    }
    
    // 判断建塔会不会阻塞路径
    CGPoint startLeft = CGPointMake(0, self.size.height * 0.5);
    NSMutableArray *path = [self findPixelPathFromPoint:startLeft direction:PathDirectLeftToRight];
    if (path.count == 0) {
        _map = map;
        [self failToBulidTower];
        return;
    }
    if (self.type == MapTypeTwoInTwoOut) {
        CGPoint startTop = CGPointMake(self.size.width * 0.5, self.size.height);
        NSMutableArray *path2 = [self findPixelPathFromPoint:startTop direction:PathDirectTopToBottom];
        if (path2.count == 0) {
            _map = map;
            [self failToBulidTower];
            return;
        }
    }
    
        
    self.gold -= towerModel.bulidCoin;
    // 设置像素坐标的塔的真实位置
    CGPoint tmpPoint = [CTGeometryTool pixelPointFromGridPoint:gridHeadPoint gridPixel:_gridPixel];
    CGPoint centerPoint = CGPointMake(tmpPoint.x + _gridPixel * 0.5, tmpPoint.y + _gridPixel * 0.5);
    
    Tower *tower = [self getRealTowerWithType:type position:centerPoint];
    tower.size = CGSizeMake(2 * MapGridPixelNormalValue, 2 * MapGridPixelNormalValue);
    tower.range = tower.range * 0.5;
    tower.delegate = self;
    [self setupTowerPhysicsBody:tower];
    [self addChild:tower];
    [self.towers addObject:tower];
    
    // 改变了塔图的构造，需要为所有怪重新生成路径
    [self resetCreaturePath];
}

- (void)failToBulidTower
{
    
}

- (Tower *)getRealTowerWithType:(TowerType)type position:(CGPoint)point
{
    TowerModel *towerModel = self.towerModels[type];
    Tower *tower = nil;
    switch (type) {
        case TowerTypeRadar:
            tower = [RadarTower towerWithModel:towerModel position:point];
            break;
        case TowerTypeSlowDown:
            tower = [SlowDownTower towerWithModel:towerModel position:point];
            break;
        case TowerTypeShock:
            tower = [ShockTower towerWithModel:towerModel position:point];
            break;
        case TowerTypeAir:
            tower = [AirTower towerWithModel:towerModel position:point];
            break;
        default:
            tower = [Tower towerWithModel:towerModel position:point];
            break;
    }
    
    return tower;
}

#pragma mark 制造妖怪
- (void)addCreatureWithType:(CreatureType)type point:(CGPoint)point
{
    // 先判断该点有没有被塔占用
    CGPoint gridPoint = [CTGeometryTool gridPointFromPixelPoint:point gridPixel:_gridPixel];
    for (MapPoint *mapPoint in _map.walls) {
        if (CGPointEqualToPoint(mapPoint.point, gridPoint)) {
            return;
        }
    }
    
    CreatureModel *creatureModel = self.creatureModels[type];
    Creature *creature = [Creature creatureWithModel:creatureModel position:point];
    creature.creatureHidden = NO;
    creature.HP = 4;
    creature.coin = 1;
    [self setupCreaturePhysicsBody:creature];
   
    [creature moveWithPath:[self findPixelPathFromPoint:point direction:PathDirectLeftToRight]];
    [self addChild:creature];
    [self.creatures addObject:creature];
 
   
}

#pragma mark 寻找路径，传入的是像素坐标
- (NSMutableArray *)findPixelPathFromPoint:(CGPoint)point direction:(PathDirect)direct
{
    
    CGPoint gridPoint = [CTGeometryTool gridPointFromPixelPoint:point gridPixel:_gridPixel];
    NSMutableArray *gridPath = [_map findPathFromPoint:gridPoint direction:direct];

    NSMutableArray *path = [NSMutableArray array];
    for (NSValue *value in gridPath) {
        CGPoint pos = [value CGPointValue];
        CGPoint pixelPoint = [CTGeometryTool pixelPointFromGridPoint:pos gridPixel:_gridPixel];
        [path addObject:[NSValue valueWithCGPoint:pixelPoint]];
    }
    
    return path;
}

#pragma mark 设置怪物的物理刚体属性
- (void)setupCreaturePhysicsBody:(Creature *)creature
{
    // 1.2 设置怪物的物理刚体属性
    // 1) 使用怪物的尺寸创建一个圆形刚体
    creature.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:creature.size.width / 2.0];
    
    /**
       2)若打开dynamic,则节点可能由于碰撞而被引擎改变位置
         但是若碰撞的两者都关闭,则无法发生碰撞.
     */
    creature.physicsBody.dynamic = YES;
    // 3) 设置节点的类别掩码 , 设置之后可以被碰到
    creature.physicsBody.categoryBitMask = creatureCategory;
    // 4) 设置碰撞检测类别掩码 , 设置之后可以主动碰到那些类别的节点
    if (creature.creatureHidden == YES) {
        creature.physicsBody.contactTestBitMask = radarTowerCategory;
    } else {
        creature.physicsBody.contactTestBitMask = towerCategory;
    }
    // 5) 设置回弹掩码
    creature.physicsBody.collisionBitMask = 0;
    // 6) 设置精确检测，用在仿真运行速度较高的物体上，防止出现“遂穿”的情况
    creature.physicsBody.usesPreciseCollisionDetection = YES;
}

#pragma mark 设置塔的物理刚体属性
- (void)setupTowerPhysicsBody:(Tower *)tower
{
    // 1.2 设置塔的物理刚体属性
    // 1) 使用塔的范围创建一个圆形刚体
    tower.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:tower.range];
    /**
     2)若打开dynamic,则节点可能由于碰撞而被引擎改变位置
     但是若碰撞的两者都关闭,则无法发生碰撞.
     */
    tower.physicsBody.dynamic = NO;
    // 3) 设置节点的类别掩码 , 设置之后可以被碰到
    if (tower.type == TowerTypeRadar) {
        tower.physicsBody.categoryBitMask = radarTowerCategory;
    } else {
        tower.physicsBody.categoryBitMask = towerCategory;
    }
    // 4) 设置之后可以主动碰到那些类别的节点
//        tower.physicsBody.contactTestBitMask = creatureCategory;
    // 5) 设置回弹掩码
    tower.physicsBody.collisionBitMask = 0;
    // 6) 设置精确检测，用在仿真运行速度较高的物体上，防止出现“遂穿”的情况
    tower.physicsBody.usesPreciseCollisionDetection = YES;
}

#pragma mark 重置妖怪路径
- (void)resetCreaturePath
{
    NSMutableArray *ops = [NSMutableArray array];
    for (int i = 0; i < _creatures.count; i++) {
        Creature *creature = _creatures[i];
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            NSMutableArray *path = [self findPixelPathFromPoint:creature.position direction:PathDirectLeftToRight];
            dispatch_async(dispatch_get_main_queue(), ^{
                [creature removeAllActions];
                [creature moveWithPath:path];
            });
        }];
        [ops addObject:op];
    }
    [self.queue addOperations:ops waitUntilFinished:NO];
}

#pragma mark 获取塔的4个栅格的左上角栅格坐标
- (CGPoint)gridHeadPointAroundPixelPoint:(CGPoint)point
{
    int border = _gridPixel * 0.5;
    if (point.x < border) {
        point.x = border;
    } else if (point.x > self.size.width - 1 - border) {
        point.x = self.size.width - 1 - border;
    }
    if (point.y < border) {
        point.y = border;
    } else if (point.y > self.size.height - 1 - border) {
        point.y = self.size.height - 1 - border;
    }
    
    int offsetX = (point.x - border)/_gridPixel;
    int offsetY = (point.y - border)/_gridPixel;
    return CGPointMake(offsetX, offsetY);
}

#pragma mark 初始化Map对象
- (void)setupGridMap
{
    CGSize gridSize = CGSizeMake(self.size.width/_gridPixel, self.size.height/_gridPixel);
    
    CGPoint rightDoor = CGPointMake(gridSize.width - 1, gridSize.height * 0.5 - 1);
    CGPoint bottomDoor = CGPointZero;
    if (_type == MapTypeTwoInTwoOut) {
        bottomDoor = CGPointMake(gridSize.width * 0.5 - 1, gridSize.height -1);
    }
    
    _map = [Map mapWithSize:gridSize rightDoor:rightDoor bottomDoor:bottomDoor];
}

#pragma mark - 销毁方法
- (void)removeAllTowers
{
    for (Tower *tower in self.towers) {
        [tower removeFromParent];
    }
    _map.walls = [NSMutableSet set];
    self.towers = [NSMutableArray array];
}

- (void)removeAllCreatures
{
    for (Creature *creature in self.creatures) {
        [creature removeFromParent];
    }
    self.creatures = [NSMutableArray array];
}

#pragma mark - Tower代理方法
- (void)tower:(Tower *)tower didDefeatCreature:(Creature *)creature
{
    if (creature == nil) return;
    self.gold += creature.coin;
    
    [creature removeFromParent];
    [_creatures removeObject:creature];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInNode:self];
    [self addTowerWithType:arc4random_uniform(7) point:point];
}

- (void)test
{
    for (int y = 0; y < 250; y+=MapGridPixelNormalValue) {
        CGPoint pos = CGPointMake(50, y);
        [self addTowerWithType:arc4random_uniform(7) point:pos];
    }
    for (int y = 48; y < 300; y+=MapGridPixelNormalValue) {
        CGPoint pos = CGPointMake(100, y);
        [self addTowerWithType:arc4random_uniform(7) point:pos];
    }
    for (int y = 0; y < 200; y+=MapGridPixelNormalValue) {
        CGPoint pos = CGPointMake(150, y);
        [self addTowerWithType:arc4random_uniform(7) point:pos];
    }
    for (int y = 48; y < 300; y+=MapGridPixelNormalValue) {
        CGPoint pos = CGPointMake(200, y);
        [self addTowerWithType:arc4random_uniform(7) point:pos];
    }
    for (int y = 0; y < 200; y+=MapGridPixelNormalValue) {
        CGPoint pos = CGPointMake(250, y);
        [self addTowerWithType:arc4random_uniform(7) point:pos];
    }
    
}

- (void)test2
{
    static int i = 3;
    i--;
    if (i == 0) {
        self.curWaveNum ++;
        for (int i = 0; i < 50; i++) {
            int y = arc4random_uniform(30) + self.position.y + self.size.height * 0.5 - 30;
            CGPoint pos = CGPointMake(0, y);
            [self addCreatureWithType:arc4random_uniform(8) point:pos];
        }
        i = 3;
    }
}


@end
