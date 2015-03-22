//
//  NSMutableArray+Point.h
//  Map
//
//  Created by 刘挺 on 15-3-19.
//  Copyright (c) 2015年 liuting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableArray (Point)

- (id)objectAtPoint:(CGPoint)point;
- (NSMutableSet *)getNeighborPointWithCenterPoint:(CGPoint)point;

@end
