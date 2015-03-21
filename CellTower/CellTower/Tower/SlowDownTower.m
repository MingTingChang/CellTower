//
//  SlowDownTower.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-19.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "SlowDownTower.h"
#import "CTGeometryTool.h"
#import "Creature.h"

@implementation SlowDownTower

#pragma mark 重写攻击方法
- (void)attack:(Creature *)creature
{
    // 1.减速
    [creature beSlowDown:self];
    
    // 2.攻击
    [super attack:creature];
}

@end
