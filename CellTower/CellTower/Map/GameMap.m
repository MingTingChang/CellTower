//
//  GameMap.m
//  CellTower
//
//  Created by 刘挺 on 15-3-20.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "GameMap.h"
#import "Map.h"
#import "Tower.h"
#import "Creature.h"
#import "CTGeometryTool.h"

//默认单元栅格像素
#define MapGridPixelNormalValue 10

@implementation GameMap
#pragma mark - 初始化方法
- (instancetype)initWithImageNamed:(NSString *)name gridPixel:(int)gridPixel
                           mapType:(MapType)type
{
    if (self = [super initWithImageNamed:name]) {
        self.type = type;
        self.gridPixel = gridPixel;
        self.creatures = [NSMutableArray array];
        self.towers = [NSMutableArray array];
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
    TowerModel *towerModel = [TowerModel towerModelWithType:type];
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
        }
    }
    if (canBulid == NO)
    {
#warning 这里没有写不能建造塔的效果
        return;
    }
    
    // 把造塔的地方当做墙，加入到walls集合中
    for (int y = 0; y <= 1; y++) {
        for (int x = 0; x <= 1; x++) {
            CGPoint pos = CGPointMake(gridHeadPoint.x + x, gridHeadPoint.y + y);
            [_map addMapWallWithPoint:pos];
        }
    }
    // 设置像素坐标的塔的真实位置
    CGPoint tmpPoint = [CTGeometryTool pixelPointFromGridPoint:gridHeadPoint gridPixel:_gridPixel];
    CGPoint centerPoint = CGPointMake(tmpPoint.x + _gridPixel * 0.5, tmpPoint.y + _gridPixel * 0.5);
    Tower *tower = [Tower towerWithModel:towerModel position:centerPoint];
    tower.size = CGSizeMake(20, 20);
    
//    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"bg_green.jpg"];
//    node.size = CGSizeMake(20, 20);
//    node.position = CGPointMake(centerPoint.x, centerPoint.y);
//    [self addChild:node];
//    [self.towers addObject:node];
    [self addChild:tower];
    [self.towers addObject:tower];
    
    // 改变了塔图的构造，需要为所有怪重新生成路径
    [self resetCreaturePath];
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
    
    CreatureModel *creatureModel = [CreatureModel creatureModelWithType:type];
    Creature *creature = [Creature creatureWithModel:creatureModel position:point];
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

#pragma mark 重置妖怪路径
- (void)resetCreaturePath
{
    for (Creature *creature in self.creatures) {
        [creature removeAllActions];
        [creature moveWithPath:[self findPixelPathFromPoint:creature.position direction:PathDirectLeftToRight]];
    }
    
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
@end
