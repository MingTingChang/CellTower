//
//  NSMutableArray+Point.m
//  Map
//
//  Created by 刘挺 on 15-3-19.
//  Copyright (c) 2015年 liuting. All rights reserved.
//

#import "NSMutableArray+Point.h"

@implementation NSMutableArray (Point)

- (id)objectAtPoint:(CGPoint)point
{
    NSUInteger height = self.count;
    if (point.y >= height || point.y < 0) {
        return nil;
    }
    id obj = [self objectAtIndex:point.y];
    if ([obj isKindOfClass:[NSMutableArray class]]) {
        
        NSMutableArray *arr = (NSMutableArray *)obj;
        NSUInteger width = arr.count;
        if (point.x >= width || point.x < 0) {
            return nil;
        }
        return [arr objectAtIndex:point.x];
    }
    return nil;
}

- (NSMutableSet *)getNeighborPointWithCenterPoint:(CGPoint)point
{
    NSMutableSet *neigh = [NSMutableSet set];
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            if (abs(x + y) == 1) {
                CGFloat neighX = point.x + x;
                CGFloat neighY = point.y + y;
                CGPoint neighPoint = CGPointMake(neighX, neighY);
                id mapPoint = [self objectAtPoint:neighPoint];
                if (mapPoint != nil) {
                    [neigh addObject:mapPoint];
                }
            }
        }
    }
    return neigh;
}
@end
