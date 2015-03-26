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
#import "SKNode+Expention.h"
#import "GameMap.h"

@implementation AirTower

#pragma mark 怪物进入攻击范围
- (void)creatureIntoAttackRange:(Creature *)creature
{
    [self.targets addObject:creature];
    
    if (self.targets.count > 0) {
        [self attack];
    }
}

#pragma mark 怪物离开攻击范围
- (void)creatureLeaveAttackRange:(Creature *)creature
{
    [self.targets removeObject:creature];
}

- (SKSpriteNode *)addBullet {
    SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"bullet"];
    bullet.size = CGSizeMake(2, 2);
    return bullet;
}

#pragma mark 清除隐藏目标
- (void)removeHiddenCreature {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (Creature *child in self.targets) {
        if (child.creatureHidden == YES ||
            child.realHP <= 0) {
            [arrayM addObject:child];
        }
    }
    for (Creature *child in arrayM) {
        [self.targets removeObject:child];
    }
}

#pragma mark 周期发动攻击
- (void)attack
{
    if (self.isWorking) return;
    self.working = YES;
    
    // 1.清除隐藏目标
    [self removeHiddenCreature];
    
    if (self.targets.count < 1)
    {
        self.working = NO;
        return;
    }
    
    // 2.旋转
    [self runAction:[SKAction rotateByAngle:M_PI duration:0.3f] completion:^{
        // 攻击多个目标
        NSUInteger count = self.targets.count > 3 ? 4 : self.targets.count;
        for (NSUInteger i = 0; i < count; i ++) {
            [self shootWithCreature:self.targets[i] completion:^(Creature *creature) {
                if (creature.HP <= 0) return;
                // 扣血
                creature.HP -= self.damage;
                // 检测死亡
                if (creature.HP <= 0 && creature.hasActions) {
                    [self.targets removeObject:creature];
                    
                    if ([self.delegate respondsToSelector:@selector(tower:didDefeatCreature:)]) {
                        [self.delegate tower:self didDefeatCreature:creature];
                    }
                }
            }];
        }
    }];
    
    // 3.等待攻击间隔
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 / self.attackSpeed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.working = NO;
        if (self.targets.count > 0) {
            [self attack];
        }
    });
}

#pragma mark 射击
- (void)shootWithCreature:(Creature *)creature completion:(shootCompletionBlock)completion
{
    // 1.创造子弹
    [self.bullets addObject:[self addBullet]];
    SKSpriteNode *bullet = [self.bullets lastObject];
    
    if (bullet.parent == nil) {
        if ([self.parent isKindOfClass:[GameMap class]]) {
            GameMap *gameMap = (GameMap *)self.parent;
            [gameMap addChild:bullet];
        }
    }
    
    creature.realHP -= self.damage;
    
    bullet.position = self.position;
    [bullet trackToNode:creature duration:0.4f completion:^{
       
        [bullet removeFromParent];
        [self.bullets removeObject:bullet];
        
        if (completion) {
            completion(creature);
        }
    }];
}

@end
