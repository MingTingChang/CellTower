//
//  Map.m
//  CellTower
//
//  Created by 刘挺 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "Map.h"
#import "MapStep.h"

@interface Map()

@end

@implementation Map

- (instancetype)initWithTexture:(SKTexture *)texture gridPixel:(int)pixel type:(MapType)type
{
    if (self = [super initWithTexture:texture]) {
        self.gridPixel = pixel;
        self.mapType = type;
    }
    return self;
}

+ (instancetype)spriteWithTexture:(SKTexture *)texture gridPixel:(int)pixel type:(MapType)type
{
    return [[self alloc] initWithTexture:texture gridPixel:pixel type:type];
}

- (void)setSize:(CGSize)size
{
    [super setSize:size];
    
    _gridSize = CGSizeMake(size.width / self.gridPixel, size.height / self.gridPixel);
    
    _grid = [NSMutableArray array];
    for (int y = 0; y < _gridSize.height; y++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int x = 0; x < _gridSize.width; x++) {
            [arr addObject:@0];
        }
        [_grid addObject:arr];
    }
    [self setMapWall];
}

- (void)setMapWall
{
    if (self.mapType == MapTypeOneEnterDoor) {
        
    } else if (self.mapType == MapTypeTwoEnterDoor){
    
    }
}

- (void)addTower:(SKNode *)tower toPoint:(CGPoint)point
{
    [super addChild:tower];
    tower.position = point;
    
    CGPoint gridPoint = [self transformPixelToGrid:point];
    NSMutableArray *arr = _grid[(int)gridPoint.y];
    arr[(int)gridPoint.x] = @(-1);
}

- (CGPoint)transformPixelToGrid:(CGPoint)point
{
    int x = point.x / self.gridPixel;
    int y = point.y / self.gridPixel;
    CGPoint trans = CGPointMake(x, y);
    return trans;
}

- (int)stepFromOne:(CGPoint)one toOther:(CGPoint)other
{
    return abs(one.x - other.x) + abs(one.y - other.y);
}

- (NSArray *)findOutPathFrom:(CGPoint)from to:(CGPoint)to
{
    NSMutableArray *path = [NSMutableArray array];
    
    CGPoint gridFrom = [self transformPixelToGrid:from];
    CGPoint gridTo = [self transformPixelToGrid:to];
    
    return path;
}

- (void)test
{
//    NSMutableArray *open = [NSMutableArray array];
//    NSMutableArray *close = [NSMutableArray array];
//    
//    int dreamStep = [self stepFromOne:gridFrom toOther:gridTo];
//    int curStep = 0;
//    [close addObject:[MapStep stepWithPoint:gridFrom curStep:curStep dreamStep:dreamStep]];
//    
//    BOOL flag = YES;
//    while (!CGPointEqualToPoint(gridFrom, gridTo)) {
//        curStep ++;
//        
//        for (int x = -1; x <= 1; x ++) {
//            for (int y = -1; y <= 1; y++) {
//                if (abs(x + y) == 1) {
//                    CGPoint nextPoint = CGPointMake(gridFrom.x + x, gridFrom.y + y);
//                    if (![self.grid containsObject:[NSValue valueWithCGPoint:nextPoint]]) {
//                        dreamStep = [self stepFromOne:nextPoint toOther:gridTo];
//                        [open addObject:[MapStep stepWithPoint:nextPoint curStep:curStep dreamStep:dreamStep]];
//                    }
//                }
//            }
//        }
//        
//        if (open.count == 0)
//        {
//            flag = NO;
//            break;
//        }
//        
//        MapStep *minStep = open[0];
//        for (MapStep *step in open) {
//            if (minStep.stepSum < step.stepSum) {
//                minStep = step;
//            }
//        }
//        
//        [open removeObject:minStep];
//        [close addObject:minStep];
//        
//        gridFrom = minStep.point;
//    }
}




@end
