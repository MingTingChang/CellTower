//
//  ShockTower.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-19.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//  冲击波塔

#import "ShockTower.h"
#import "Creature.h"
#import "CTGeometryTool.h"

@implementation ShockTower

@synthesize working = _working;

- (BOOL)isWorking
{
    return _working;
}

- (void)creatureIntoAttackRange:(Creature *)creature
{
    [self.targets addObject:creature];
    
    if (self.isWorking == NO) {
        [self attack];
    }
}

#pragma mrak 攻击
- (void)attack
{
    self.working = YES;
    
    // 1.发射子弹
    if (self.bullet.scene == nil) {
        [self.scene addChild:self.bullet];
    }
    self.bullet.position = self.position;
    self.bullet.hidden = NO;
    [self.bullet runAction:[SKAction scaleTo:self.range*2/self.bullet.size.width duration:1.0f] completion:^{
        self.bullet.xScale = 1;
        self.bullet.yScale = 1;
        self.bullet.hidden = YES;
    }];
    
    // 2.扣血以及检测死亡
    for (Creature *creature in self.targets) {
        creature.HP -= self.damage;
        CTLog(@"%@    %d    %d", creature.imageName, creature.HP, creature.moveSpeed);
        if (creature.HP <= 0) { // 死亡
            [self.targets removeObject:creature];
            if ([self.delegate respondsToSelector:@selector(tower:didDefeatCreature:)]) {
                [self.delegate tower:self didDefeatCreature:creature];
            }
        }
    }
    
    // 3.等待攻击间隔
    NSTimeInterval attackWait = 1.0 / self.attackSpeed;
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
