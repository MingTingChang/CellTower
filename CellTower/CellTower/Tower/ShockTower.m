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
#import "GameMap.h"

typedef void(^shootsCompletionBlock)(NSMutableArray *creatures);

@interface ShockTower()

@property (nonatomic , strong) SKSpriteNode *bullet;

@end

@implementation ShockTower

#pragma mark 子弹
- (SKSpriteNode *)bullet {
    if (!_bullet) {
        _bullet = [SKSpriteNode spriteNodeWithImageNamed:@"shock"];
        _bullet.zPosition = 6;
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
        if (child.creatureHidden == YES ||
            child.realHP <= 0) {
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
    
    if (self.targets.count < 1)
    {
        self.working = NO;
        return;
    }
    
    // 2.射击
    [self shootsWithCreature:nil completion:^(NSMutableArray *creatures) {
        // 3.扣血以及检测死亡
        for (Creature *creature in creatures) {
            if (creature.HP <= 0) continue;
            creature.HP -= self.damage;
            if (creature.HP <= 0 && creature.hasActions) { // 死亡
                [self.targets removeObject:creature];
                if ([self.delegate respondsToSelector:@selector(tower:didDefeatCreature:)]) {
                    [self.delegate tower:self didDefeatCreature:creature];
                }
            }
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

#pragma mrak 攻击目标
- (void)shootsWithCreature:(Creature *)creature completion:(shootsCompletionBlock)completion
{
    self.working = YES;
    
    if (self.bullet.parent == nil) {
        if ([self.parent isKindOfClass:[GameMap class]]) {
            GameMap *gameMap = (GameMap *)self.parent;
            [gameMap addChild:self.bullet];
        }
    }
    
    NSMutableArray *targets = [NSMutableArray array];
    for (Creature *creature in self.targets) {
        creature.realHP -= self.damage;
        [targets addObject:creature];
    }
    
    self.bullet.position = self.position;
    self.bullet.hidden = NO;
    [self.bullet runAction:[SKAction scaleTo:self.range*2/self.bullet.size.width duration:1.0f] completion:^{
        self.bullet.xScale = 1;
        self.bullet.yScale = 1;
        self.bullet.hidden = YES;
        
        if (completion) {
            completion(targets);
        }
    }];
}

@end
