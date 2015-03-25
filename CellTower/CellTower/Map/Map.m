//
//  Map.m
//  Map
//
//  Created by 刘挺 on 15-3-19.
//  Copyright (c) 2015年 liuting. All rights reserved.
//

#import "Map.h"
#import "NSMutableArray+Point.h"

@implementation MapPoint
#pragma mark - MapPoint初始化方法
- (instancetype)initWithPoint:(CGPoint)point value:(int)value
{
    if (self = [super init]) {
        self.point = point;
        self.value = value;
        self.dreamValue = MAXFLOAT;
    }
    return self;
}

+ (instancetype)pointWithPoint:(CGPoint)point value:(int)value
{
    return [[self alloc] initWithPoint:point value:value];
}

+ (instancetype)copyWithMapPoint:(MapPoint *)point
{
    MapPoint *copyPoint = [MapPoint pointWithPoint:point.point value:point.value];
    copyPoint.dreamValue = point.dreamValue;
    return copyPoint;
}

@end

@implementation Map
#pragma mark - Map初始化
- (instancetype)initWithSize:(CGSize)size rightDoor:(CGPoint)right bottomDoor:(CGPoint)bottom
{
    if (self = [super init]) {
        self.size = size;
        self.rightTarget = right;
        self.bottomTarget = bottom;
        self.walls = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)mapWithSize:(CGSize)size rightDoor:(CGPoint)right bottomDoor:(CGPoint)bottom
{
    return [[self alloc] initWithSize:size rightDoor:right bottomDoor:bottom];
}

+ (instancetype)copyWithMap:(Map *)map
{
    Map *copyMap = [Map mapWithSize:map.size rightDoor:map.rightTarget bottomDoor:map.bottomTarget];
    
    NSMutableArray *rightPathMap = [NSMutableArray array];
    for (NSMutableArray *array in map.rightPathMap) {
        NSMutableArray *copyArray = [NSMutableArray array];
        for (MapPoint *mapPoint in array) {
            MapPoint *copyPoint = [MapPoint copyWithMapPoint:mapPoint];
            [copyArray addObject:copyPoint];
        }
        [rightPathMap addObject:copyArray];
    }
    NSMutableArray *bottomPathMap = [NSMutableArray array];
    for (NSMutableArray *array in map.bottomPathMap) {
        NSMutableArray *copyArray = [NSMutableArray array];
        for (MapPoint *mapPoint in array) {
            MapPoint *copyPoint = [MapPoint copyWithMapPoint:mapPoint];
            [copyArray addObject:copyPoint];
        }
        [bottomPathMap addObject:copyArray];
    }
    copyMap.rightPathMap = rightPathMap;
    copyMap.bottomPathMap = bottomPathMap;
    
    for (NSValue *point in map.walls) {
        [copyMap.walls addObject:point];
    }
    
    return copyMap;
}

#pragma mark - Map的对象打印方法
- (NSString *)description
{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"\nRightPathMap:\n"];
    for (NSMutableArray *arr in _rightPathMap) {
        for (MapPoint *point in arr) {
            [str appendFormat:@"[%d]\t",point.value];
        }
        [str appendFormat:@"\n"];
    }
    [str appendFormat:@"BottomPathMap:\n"];
    for (NSMutableArray *arr in _bottomPathMap) {
        for (MapPoint *point in arr) {
            [str appendFormat:@"[%d]\t",point.value];
        }
        [str appendFormat:@"\n"];
    }
    
    return str;
}

#pragma mark - Map的setter和getter方法
- (void)setSize:(CGSize)size
{
    _size = size;
    _change = YES;
}

#pragma mark - Map的对象方法
#pragma mark 添加一个墙
- (void)addMapWallWithPoint:(CGPoint)point
{
    for (NSValue *wall in _walls) {
        if (CGPointEqualToPoint([wall CGPointValue], point)) {
            return;
        }
    }
    NSValue *value = [NSValue valueWithCGPoint:point];
    [_walls addObject:value];
    _change = YES;
}

#pragma mark 删除一个墙
- (void)removeMapWallWithPoint:(CGPoint)point
{
    for (NSValue *wall in _walls) {
        if (CGPointEqualToPoint([wall CGPointValue], point)) {
            [_walls removeObject:wall];
            break;
        }
    }
    _change = YES;
}

#pragma mark 根据起点from和目标方向direct寻找出口路径
- (NSMutableArray *)findPathFromPoint:(CGPoint)from direction:(PathDirect)direct
{
    if (_change == YES) {
        self.rightPathMap = [self setupPathMapWithPoint:self.rightTarget];
        self.bottomPathMap = [self setupPathMapWithPoint:self.bottomTarget];
        _change = NO;
    }
    
    NSMutableArray *pathMap = nil;
    if (direct == PathDirectLeftToRight) {
        pathMap = self.rightPathMap;
    } else if (direct == PathDirectTopToBottom) {
        pathMap = self.bottomPathMap;
        
    }
    
    if (pathMap == nil) return nil;
    
    MapPoint *nowPoint = [pathMap objectAtPoint:from];
    
    if ((nowPoint == nil) || (nowPoint.value == -1)) {
//        CTLog(@"point not in map");
        return nil;
    }
    
    // 根据搜索图搜索路径
    NSMutableArray *path = [NSMutableArray array];

    while (nowPoint.value != 1) {
        
        NSMutableSet *neigh = [pathMap getNeighborPointWithCenterPoint:nowPoint.point];
        NSMutableSet *both = [NSMutableSet set];
        for (MapPoint *neighPoint in neigh) {
            if (neighPoint.value == nowPoint.value - 1) {
                [both addObject:neighPoint];
            }
        }
        if (both.count == 0) return nil;
        MapPoint *one = [both anyObject];
        for (MapPoint *other in both) {
            if (one.dreamValue > other.dreamValue) {
                one = other;
            }
        }
        [path addObject:one];
        nowPoint = one;
    }
    
    // 裁剪路径
    NSMutableArray *pointPath = [NSMutableArray array];
    
    while (path.count >= 3) {
        MapPoint *one = path[0];
        MapPoint *two = path[1];
        MapPoint *three = path[2];
        
        CGPoint oneToTwo = CGPointMake(abs(one.point.x - two.point.x),
                                       abs(one.point.y - two.point.y));
        CGPoint TwoToThree = CGPointMake(abs(two.point.x - three.point.x),
                                         abs(two.point.y - three.point.y));
        
        if (!CGPointEqualToPoint(oneToTwo, TwoToThree)) {
            [path removeObject:two];
        }
        [pointPath addObject:[NSValue valueWithCGPoint:one.point]];
        [path removeObject:one];
    }
    
    for (MapPoint *pathPoint in path) {
        [pointPath addObject:[NSValue valueWithCGPoint:pathPoint.point]];
    }
    
    return pointPath;
}

#pragma mark 配置和生成搜索图
- (NSMutableArray *)setupPathMapWithPoint:(CGPoint)point
{
    if (CGPointEqualToPoint(point, CGPointZero)) return nil;
    
    // 初始化搜索图
    NSMutableArray *pathMap = [NSMutableArray array];
    for (long y = 0; y < _size.height; y++) {
        NSMutableArray *row = [NSMutableArray array];
        for (long x = 0; x < _size.width; x++) {
            CGPoint pos = CGPointMake(x, y);
            BOOL isWall = NO;
            for (NSValue *wall in _walls) {
                if (CGPointEqualToPoint([wall CGPointValue], pos)) {
                    isWall = YES;
                    break;
                }
            }
            int value = isWall ? -1 : 0;
            MapPoint *pathMapPoint = [MapPoint pointWithPoint:pos value:value];
            pathMapPoint.dreamValue = pow(pos.x - point.x, 2) + pow(pos.y - point.y, 2);
            [row addObject:pathMapPoint];
        }
        [pathMap addObject:row];
    }
    
    
    // 广度搜索算法修改搜索图
    // 当前步伐
    int step = 1;
    MapPoint *now = [pathMap objectAtPoint:point];
    
    // 当前步伐寻找点的集合
    NSMutableSet *find = [NSMutableSet set];
    [find addObject:now];
    
    while (find.count != 0) {
        
        for (MapPoint *mapPoint in find) {
            mapPoint.value = step;
        }

        // 下一步寻找点的集合
        NSMutableSet *nextFind = [NSMutableSet set];    //注意：这里不能使用数组，不然会重复添加
        for (MapPoint *mapPoint in find) {
            NSMutableSet *neigh = [pathMap getNeighborPointWithCenterPoint:mapPoint.point];
            for (MapPoint *neighPoint in neigh) {
                if (neighPoint.value == 0) {
                    [nextFind addObject:neighPoint];
                }
            }

        }
        //删除当前步伐的所有点
        [find removeAllObjects];
        //设置当前步伐点集合为下一步寻找点集合
        find = nextFind;
        step++;
    }
    return pathMap;
}

@end

