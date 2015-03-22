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

@interface ShockTower()

@property (nonatomic , strong) SKSpriteNode *bullet;

@end

@implementation ShockTower

#pragma mark 子弹
- (SKSpriteNode *)bullet {
    if (!_bullet) {
        _bullet = [SKSpriteNode spriteNodeWithImageNamed:@"shock"];
        _bullet.size = CGSizeMake(2, 2);
    }
    return _bullet;
}

#pragma mark 怪物进入攻击范围
- (void)creatureIntoAttackRange:(Creature *)creature
{
    [self.targets addObject:creature];
    [self attack];
}

#pragma mark 清除隐藏怪物
- (void)removeHiddenCreature
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (Creature *child in self.targets) {
        if (child.creatureHidden == YES) {
            [arrayM addObject:child];
        }
    }
    for (Creature *child in arrayM) {
        [self.targets removeObject:child];
    }
}

#pragma mark 清除死亡目标
- (void)removeDeadCreature {
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

#pragma mark 攻击
- (void)attack
{
    if (self.isWorking) return;
    self.working = YES;
    
    // 1.清除隐藏怪物
    [self removeHiddenCreature];
    [self removeDeadCreature];
    
    if (self.targets.count < 1)
    {
        self.working = NO;
        return;
    }
    
    // 2.射击
    [self shootWithCreature:nil completion:^(Creature *creature) {
        // 3.扣血以及检测死亡
        NSMutableArray *arrayM = [NSMutableArray array];
        for (Creature *creature in self.targets) {
            creature.HP -= self.damage;
            if (creature.HP <= 0) { // 死亡
                [arrayM addObject:creature];
            }
        }
        
        for (Creature *child in arrayM) {
            [self.targets removeObject:child];
            if ([self.delegate respondsToSelector:@selector(tower:didDefeatCreature:)]) {
                [self.delegate tower:self didDefeatCreature:child];
            }
        }
    }];
    
    // 3.等待攻击间隔
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 / self.attackSpeed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.working = NO;
        if (self.targets.count > 0) {
            [self attack];
        }
    });
}

#pragma mrak 攻击目标
- (void)shootWithCreature:(Creature *)creature completion:(shootCompletionBlock)completion
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
        
        if (completion) {
            completion(nil);
        }
    }];
}

@end
