//
//  Tower.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "Tower.h"

@implementation Tower

- (BOOL)isWorking
{
    return (self.target != nil);
}

- (void)fireWithCreature:(Creature *)creature
{
    // 1.添加攻击目标
    self.target = creature;
    
    // 2.旋转
    
    // 3.发射子弹
    
    // 4.判断怪物是否死亡
    
}

@end
