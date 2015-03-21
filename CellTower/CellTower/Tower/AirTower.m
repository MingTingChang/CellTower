//
//  AirTower.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-21.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "AirTower.h"
#import "CTGeometryTool.h"
#import "Creature.h"

@implementation AirTower

@synthesize working = _working;

- (BOOL)isWorking
{
    return _working;
}

- (void)creatureIntoAttackRange:(Creature *)creature
{
    [self.targets addObject:creature];
    
    if (self.targets.count > 0) {
        [self attack];
    }
}

- (void)creatureLeaveAttackRange:(Creature *)creature
{
    [self.targets removeObject:creature];
    if (self.targets.count < 1) {
        self.working = NO;
    }
}

- (SKSpriteNode *)addBullet {
    SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"bullet"];
    bullet.size = CGSizeMake(2, 2);
    return bullet;
}

- (void)attack
{
    if (_working) return;
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
    
    [self runAction:[SKAction rotateByAngle:M_PI duration:0.3f] completion:^{
        NSUInteger count = self.targets.count > 3 ? 4 : self.targets.count;
        for (NSUInteger i = 0; i < count; i ++) {
            [self attack:self.targets[i]];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 / self.attackSpeed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.targets.count > 0) {
            self.working = NO;
            [self attack];
        }
        
    });
}

- (void)attack:(Creature *)creature
{
    [self.bullets addObject:[self addBullet]];
    SKSpriteNode *bullet = [self.bullets lastObject];
    NSLog(@"%lu", (unsigned long)self.bullets.count);
    
    // 3.发射子弹
    if (bullet.scene == nil) {
        [self.scene addChild:bullet];
    }
    bullet.position = self.position;
    bullet.hidden = NO;
    
    SKAction *moveAction = [SKAction moveTo:creature.position duration:0.4f];
    [bullet runAction:moveAction completion:^{
        bullet.hidden = YES;
        creature.HP -= self.damage;
    }];
    
    // 5.等待攻击间隔
    NSTimeInterval attackWait = 1 / self.attackSpeed;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(attackWait * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 5.1.检测死亡
        if (creature.HP <= 0) { // 死亡
            // 清除攻击目标
            self.target = nil;
            [self.targets removeObject:creature];
            
            // 通知代理
            if ([self.delegate respondsToSelector:@selector(tower:didDefeatCreature:)]) {
                [self.delegate tower:self didDefeatCreature:creature];
            }
        }
        // 5.3删除子弹
        if ( bullet.scene != nil) {
            [bullet removeFromParent];
            [self.bullets removeObject:bullet];
        }
    });
}

@end
