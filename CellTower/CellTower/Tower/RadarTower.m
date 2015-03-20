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

@synthesize working = _working;

- (BOOL)isWorking
{
    return _working;
}

#pragma mrak 进入侦测范围
- (void)creatureIntoAttackRange:(Creature *)creature
{
    if (creature.isCreatureHidden) {
        [self.targets addObject:creature];
    }
    
    if (self.isWorking == NO) {
        [self attack];
    }
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
        [self.targets removeObject:leaveCreature];
    }
}

#pragma mark 侦测
- (void)attack
{
    self.working = YES;
    
    
    NSTimeInterval attackWait = 1.0 / self.attackSpeed;
    
    // 1.旋转
    [self removeAllActions];
    [self runAction:[SKAction rotateByAngle:M_PI * 5 duration:attackWait*2]];
    
    for (Creature *creature in self.targets) {
        creature.creatureHidden = NO;
    }
    
    // 2.等待攻击间隔
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(attackWait * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.targets.count > 0) {
            [self attack];
        } else {
            self.working = NO;
            [self.bullet removeFromParent];
        }
    });
    
}

@end
