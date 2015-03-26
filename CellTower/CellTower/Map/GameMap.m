//
//  GameMap.m
//  CellTower
//
//  Created by 刘挺 on 15-3-20.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "GameMap.h"
#import "CTGeometryTool.h"
#import "Map.h"
#import "Creature.h"
#import "Tower.h"
#import "RadarTower.h"
#import "ShockTower.h"
#import "SlowDownTower.h"
#import "AirTower.h"

@interface GameMap() <TowerDelegate,CreatureDelegate>

@property (nonatomic , strong) Map *map;

@property (nonatomic , assign) int gridPixel;

@property (nonatomic , assign) MapType type;

@property (nonatomic , strong) NSMutableArray *creatures;

@property (nonatomic , strong) NSMutableArray *towers;

@property (nonatomic , strong) NSMutableArray *towerModels;

@property (nonatomic , strong) NSMutableArray *creatureModels;

@property (nonatomic , strong) NSOperationQueue *queue;

@end

@implementation GameMap
#pragma mark - 初始化方法
- (instancetype)initWithImageNamed:(NSString *)name gridPixel:(int)gridPixel
                           mapType:(MapType)type
{
    if (self = [super initWithImageNamed:name]) {
        
        self.userInteractionEnabled = YES;
        self.gold = 5000;
        self.playerHP = 50;
        self.size = CGSizeMake(320, 320);
        self.type = type;
        self.gridPixel = gridPixel;
        self.curWaveNum = 1;
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

+ (instancetype)mapWithType:(MapType)type
{
    NSString *name;
    if (type == MapTypeOneInOneOut) {
        name = [NSString stringWithFormat:@"map_oneToOne.jpg"];
    } else if (type == MapTypeTwoInTwoOut) {
        name = [NSString stringWithFormat:@"map_twoToTwo.jpg"];
    } else {
        return nil;
    }
    GameMap *gameMap = [self spriteNodeWithImageNamed:name mapType:type];
    [gameMap setupGridMap];
    // 加墙
    int i = 0;
    CGFloat width = gameMap.map.size.width;
    CGFloat height = gameMap.map.size.height;
    int margin = 12;
    for (i = 0; i < margin; i++) {
        [gameMap.map addMapWallWithPoint:CGPointMake(0, i)];
        [gameMap.map addMapWallWithPoint:CGPointMake(i, 0)];
        
        [gameMap.map addMapWallWithPoint:CGPointMake(width-1, i)];
        [gameMap.map addMapWallWithPoint:CGPointMake(width-1-i, 0)];
        
        [gameMap.map addMapWallWithPoint:CGPointMake(0, height-1-i)];
        [gameMap.map addMapWallWithPoint:CGPointMake(i, height-1)];
        
        [gameMap.map addMapWallWithPoint:CGPointMake(width-1, height-1-i)];
        [gameMap.map addMapWallWithPoint:CGPointMake(width-1-i, height-1)];
    }
    if (type == MapTypeOneInOneOut) {
        for (i = margin; i < width - margin; i++) {
            [gameMap.map addMapWallWithPoint:CGPointMake(i, 0)];
            [gameMap.map addMapWallWithPoint:CGPointMake(i, height - 1)];
        }
    }
    
    [gameMap test];
    return gameMap;
}

- (NSMutableArray *)creatures
{
    if (_creatures == nil) {
        _creatures = [NSMutableArray array];
    }
    return _creatures;
}

- (NSMutableArray *)towers
{
    if (_towers == nil) {
        _towers = [NSMutableArray array];
    }
    return _towers;
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
    BOOL canBulid = [self canBulidTowerWithGridHeadPoint:gridHeadPoint];
    if (canBulid == NO) {
        [self failToBulidTower];
        return;
    }
    
    TowerModel *towerModel = self.towerModels[type];
    
    self.gold -= towerModel.bulidCoin;
    // 设置像素坐标的塔的真实位置
    CGPoint tmpPoint = [CTGeometryTool pixelPointFromGridPoint:gridHeadPoint gridPixel:_gridPixel];
    CGPoint centerPoint = CGPointMake(tmpPoint.x + _gridPixel * 0.5, tmpPoint.y + _gridPixel * 0.5);
    
    Tower *tower = [self getRealTowerWithType:type position:centerPoint];
    tower.size = CGSizeMake(2 * MapGridPixelNormalValue, 2 * MapGridPixelNormalValue);
    tower.range = tower.range * 0.5;
    tower.delegate = self;
    [self addChild:tower];
    [self.towers addObject:tower];
    
    // 改变了塔图的构造，需要为所有怪重新生成路径
    [self resetCreaturePath];
}

- (BOOL)canBulidTowerWithGridHeadPoint:(CGPoint)gridHeadPoint
{
    // 判断该坐标是否被占用
    BOOL isOccupy = NO;
    for (int y = 0; (y <= 1) && (!isOccupy); y++) {
        for (int x = 0; (x <= 1) && (!isOccupy); x++) {
            CGPoint pos = CGPointMake(gridHeadPoint.x + x, gridHeadPoint.y + y);
            for (NSValue *wall in _map.walls) {
                if (CGPointEqualToPoint([wall CGPointValue], pos)) {
                    isOccupy = YES;
                    break;
                }
            }
            for (Creature *creature in self.creatures) {
                CGPoint gridPoint = [CTGeometryTool gridPointFromPixelPoint:creature.position gridPixel:_gridPixel];
                if (CGPointEqualToPoint(pos, gridPoint)) {
                    isOccupy = YES;
                    break;
                }
            }
        }
    }
    if (isOccupy == YES) return NO;
    
     // 判断建塔会不会阻塞路径
    Map *map = [Map copyWithMap:_map copyAll:NO];
    
    // 把造塔的地方当做墙，加入到walls集合中
    for (int y = 0; y <= 1; y++) {
        for (int x = 0; x <= 1; x++) {
            CGPoint pos = CGPointMake(gridHeadPoint.x + x, gridHeadPoint.y + y);
            [map addMapWallWithPoint:pos];
        }
    }
    
    CGPoint startLeft = CGPointMake(0 , map.rightTarget.y);
    NSMutableArray *path = [map findPathFromPoint:startLeft direction:PathDirectLeftToRight];
    if ((path.count == 0) || (path == nil)) {
        return NO;
    }
    if (self.type == MapTypeTwoInTwoOut) {
        CGPoint startTop = CGPointMake(map.bottomTarget.x , map.size.height - 1);
        NSMutableArray *path2 = [map findPathFromPoint:startTop
                                             direction:PathDirectTopToBottom];
        if ((path2.count == 0) || (path2 == nil)) {
            return NO;
        }
    }
    
    _map = map;
    
    return YES;
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
- (void)addCreatureWithType:(CreatureType)type outlet:(CreatureOutlet)outlet
{
    int x = 0,y = 0;
    int rand = 40;
    if (outlet == CreatureOutletLeft) {
        x = 0;
        y = arc4random_uniform(rand) + self.size.height * 0.5 - rand*0.5;
    } else if (outlet == CreatureOutletUp) {
        x = arc4random_uniform(rand) + self.size.width * 0.5 - rand*0.5;
        y = self.size.height - 1;
    } else {
        return;
    }
    
    CGPoint point = CGPointMake(x, y);
    
    // 先判断该点有没有被塔占用
    CGPoint gridPoint = [CTGeometryTool gridPointFromPixelPoint:point gridPixel:_gridPixel];
    for (NSValue *wall in _map.walls) {
        if (CGPointEqualToPoint([wall CGPointValue], gridPoint)) {
            return;
        }
    }
    
    CreatureModel *creatureModel = self.creatureModels[type];
    Creature *creature = [Creature creatureWithModel:creatureModel position:point];
    creature.outlet = outlet;
    creature.delegate = self;
    creature.creatureHidden = NO;
    creature.HP = 20;
    creature.realHP = creature.HP;
    creature.coin = 1;
    [self addChild:creature];
    [self.creatures addObject:creature];
   
    __weak typeof(self) wSelf = self;
    __weak Creature *wCreature = creature;
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSMutableArray *path = [wSelf findPixelPathFromPoint:wCreature.position outlet:wCreature.outlet];
        dispatch_async(dispatch_get_main_queue(), ^{
            [wCreature moveWithPath:path];
        });
    }];
    [self.queue addOperation:op];
}

- (void)addCreatureWithType:(CreatureType)type
{
    [self addCreatureWithType:type outlet:CreatureOutletLeft];
}

#pragma mark 寻找路径，传入的是像素坐标
- (NSMutableArray *)findPixelPathFromPoint:(CGPoint)point outlet:(CreatureOutlet)outlet
{
    
    CGPoint gridPoint = [CTGeometryTool gridPointFromPixelPoint:point gridPixel:_gridPixel];
    
    int pathDir = PathDirectLeftToRight;
    if (outlet == CreatureOutletUp) {
        pathDir = PathDirectTopToBottom;
    }
    NSMutableArray *gridPath = [_map findPathFromPoint:gridPoint direction:pathDir];
    
    if((gridPath.count == 0) || (gridPath == nil))
        return nil;
    
    NSMutableArray *path = [NSMutableArray array];
    for (NSValue *value in gridPath) {
        CGPoint pos = [value CGPointValue];
        CGPoint pixelPoint = [CTGeometryTool pixelPointFromGridPoint:pos gridPixel:_gridPixel];
        [path addObject:[NSValue valueWithCGPoint:pixelPoint]];
    }
    
    if (outlet == CreatureOutletLeft) {
        CGPoint end = CGPointMake(_map.rightTarget.x + 1, _map.rightTarget.y);
        CGPoint pixelEnd = [CTGeometryTool pixelPointFromGridPoint:end gridPixel:_gridPixel];
        [path addObject:[NSValue valueWithCGPoint:pixelEnd]];
    } else if (outlet == CreatureOutletUp) {
        CGPoint end = CGPointMake(_map.bottomTarget.x, _map.bottomTarget.y - 1);
        CGPoint pixelEnd = [CTGeometryTool pixelPointFromGridPoint:end gridPixel:_gridPixel];
        [path addObject:[NSValue valueWithCGPoint:pixelEnd]];
    }
    
    return path;
}


#pragma mark 重置妖怪路径
- (void)resetCreaturePath
{
    NSMutableArray *ops = [NSMutableArray array];
    __weak typeof(self) wSelf = self;
    for (int i = 0; i < _creatures.count; i++) {
        __weak Creature *creature = _creatures[i];
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            NSMutableArray *path = [wSelf findPixelPathFromPoint:creature.position outlet:creature.outlet];
            dispatch_async(dispatch_get_main_queue(), ^{
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
        bottomDoor = CGPointMake(gridSize.width * 0.5 - 1, 0);
    }
    
    _map = [Map mapWithSize:gridSize rightDoor:rightDoor bottomDoor:bottomDoor];
}

#pragma mark - 销毁方法
- (void)removeAllTowers
{
    [self.towers removeAllObjects];
    self.towers = [NSMutableArray array];
    _map.walls = [NSMutableArray array];
}

- (void)removeAllCreatures
{
    [self.creatures removeAllObjects];
    self.creatures = [NSMutableArray array];
}

#pragma mark - Tower代理方法
- (void)tower:(Tower *)tower didDefeatCreature:(Creature *)creature
{
    if (creature == nil) return;
    self.gold += creature.coin;
    
    [_creatures removeObject:creature];
    [creature removeFromParent];
}

#pragma mark - Creature代理
- (void)creatureMoveStateDidChange:(Creature *)creature
{
    [creature moveWithPath:[self findPixelPathFromPoint:creature.position outlet:creature.outlet]];
}

- (void)creatureMovePathEnd:(Creature *)creature
{
    if (self.playerHP <= 0) return;
    
    self.playerHP--;
    if (self.playerHP <= 0) {
        
        [self removeAllTowers];
        [self removeAllCreatures];
        [self removeAllChildren];
        if ([self.delegate respondsToSelector:@selector(gameMapDidGameOver)]) {
            [self.delegate gameMapDidGameOver];
        }
        return;
    }
    for (Tower *tower in self.towers) {
        [tower.targets removeObject:creature];
    }
    
    [_creatures removeObject:creature];
    [creature removeFromParent];
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
//    for (int y = 0; y < 200; y+=MapGridPixelNormalValue) {
//        CGPoint pos = CGPointMake(150, y);
//        [self addTowerWithType:arc4random_uniform(7) point:pos];
//    }
    for (int y = 48; y < 300; y+=MapGridPixelNormalValue) {
        CGPoint pos = CGPointMake(200, y);
        [self addTowerWithType:arc4random_uniform(7) point:pos];
    }
    for (int y = 0; y < 200; y+=MapGridPixelNormalValue) {
        CGPoint pos = CGPointMake(250, y);
        [self addTowerWithType:arc4random_uniform(7) point:pos];
    }
    
}




@end
