//
//  AttactRange.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-25.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "AttactRange.h"
#import "Tower.h"

@implementation AttactRange

+ (instancetype)attactRangeWithTower:(Tower *)tower
{
    AttactRange *range = [self shapeNodeWithCircleOfRadius:tower.range];
    range.strokeColor = [SKColor redColor];
    range.fillColor = [SKColor redColor];
    range.alpha = 0.3;
    
    return range;
}

@end
