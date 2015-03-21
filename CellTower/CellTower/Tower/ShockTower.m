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

- (SKSpriteNode *)bullet {
    if (!_bullet) {
        _bullet = [SKSpriteNode spriteNodeWithImageNamed:@"shock"];
        _bullet.size = CGSizeMake(2, 2);
    }
    return _bullet;
}

- (void)creatureIntoAttackRange:(Creature *)creature
{
    [self.targets addObject:creature];
    [self attack];
}

#pragma mark 攻击
- (void)attack
{
    if (self.isWorking == YES) return;
    self.working = YES;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (Creature *child in self.targets) {
        if (child.creatureHidden == YES) {
            [arrayM addObject:child];
        }
    }
    for (Creature *child in arrayM) {
        [self.targets removeObject:child];
    }
    
    if (self.targets.count < 1) return;
    [self attack:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 / self.attackSpeed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.targets.count > 0) {
            self.working = NO;
            [self attack];
        }
    });
}

#pragma mrak 攻击目标
- (void)attack:(Creature *)creature
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
}

@end
