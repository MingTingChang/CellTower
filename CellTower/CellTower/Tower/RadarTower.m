//
//  RadarTower.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-20.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "RadarTower.h"
#import "Creature.h"

@implementation RadarTower

#pragma mrak 进入侦测范围
- (void)creatureIntoAttackRange:(Creature *)creature
{
    
    [self.targets addObject:creature];
    
    [self detect];
    
}

#pragma mark 离开侦测范围
- (void)creatureLeaveAttackRange:(Creature *)creature
{
    Creature *leaveCreature = nil;
    for (Creature *child in self.targets) {
        if (creature == child) {
            leaveCreature = child;
        }
    }
    if (leaveCreature != nil) {
        leaveCreature.creatureHidden = YES;
        leaveCreature.physicsBody.contactTestBitMask = radarTowerCategory;
        [self.targets removeObject:leaveCreature];
    }
}

#pragma mark 清除死亡目标
- (void)removeDeadCreature
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (Creature *child in self.targets) {
        if (child.HP <= 0) {
            [arrayM addObject:child];
        }
    }
    for (Creature *child in arrayM) {
        [self.targets removeObject:child];
    }
}

#pragma mark 侦测
- (void)detect
{
    // 1.清除死亡目标
    [self removeDeadCreature];
    
    if (self.working) return;
    self.working = YES;
    
    
    NSTimeInterval attackWait = 1.0 / self.attackSpeed;
    // 1.旋转
    [self removeAllActions];
    [self runAction:[SKAction rotateByAngle:M_PI * 5 duration:attackWait*2]];
    
    for (Creature *creature in self.targets) {
        creature.creatureHidden = NO;
        creature.physicsBody.contactTestBitMask = towerCategory | radarTowerCategory;
    }
    
    // 2.等待攻击间隔
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(attackWait * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.working = NO;
        if (self.targets.count > 0) {
            [self detect];
        } 
    });
    
}

@end
