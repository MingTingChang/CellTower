//
//  Tower.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "Tower.h"
#import "Creature.h"

@interface Tower ()

@property (nonatomic , assign , readwrite) TowerType type;
@property (nonatomic , assign , readwrite) BulletType bulletType;

@end

@implementation Tower

#pragma mark - 公共方法
#pragma mark 根据模型实例化塔
+ (instancetype)towerWithModel:(TowerModel *)model
{
    Tower *tower = [Tower spriteNodeWithImageNamed:model.imageName];
    tower.size = CGSizeMake(30, 30);
    tower.zPosition = 1;
    
    tower.imageName = [model.imageName copy];
    tower.range = model.range;
    tower.attackSpeed = model.attackSpeed;
    tower.damage = model.damage;
    tower.type = model.type;
    tower.level = model.level;
    tower.maxLevel = model.maxLevel;
    tower.damageIncerment = model.damageIncerment;
    tower.bulidCoin = model.bulidCoin;
    tower.upgradeCoin = model.upgradeCoin;
    tower.destoryCoinRatio = model.destoryCoinRatio;
    tower.grid = model.grid;
    tower.bulletType = model.bulletType;
    tower.working = model.working;
    
    return tower;
}

#pragma mark 根据模型和位置实例化塔
+ (instancetype)towerWithModel:(TowerModel *)model position:(CGPoint)position
{
    Tower *tower = [self towerWithModel:model];
    tower.position = position;
    
    return tower;
}

#pragma mark 塔是否在工作
- (BOOL)isWorking
{
    return (self.target != nil);
}

#pragma mark 攻击
- (void)fireWithCreature:(Creature *)creature bullet:(SKSpriteNode *)bullet
{
    if (creature == nil) return;
    
    // 1.添加攻击目标
    self.target = creature;
    
    // 2.旋转
    // 计算角度
    CGPoint offset = CGPointMake(creature.position.x - self.position.x, creature.position.y - self.position.y);
    CGFloat angle = atan2f(offset.y, offset.x);

    [self runAction:[SKAction rotateToAngle:angle duration:0.1f] completion:^{
        // 3.发射子弹
        bullet.position = self.position;
        
        bullet.hidden = NO;
        [bullet runAction:[SKAction moveTo:creature.position duration:0.2f] completion:^{
            bullet.hidden = YES;
        }];
        
        // 4.扣血判断怪物是否死亡
        creature.HP -= self.damage;
        CTLog(@"%d", creature.HP);
        
        if (creature.HP <= 0) { // 死亡
            // 清除攻击目标
            self.target = nil;
            
            [bullet removeFromParent];
            if ([self.delegate respondsToSelector:@selector(tower:didDefeatCreature:)]) {
                [self.delegate tower:self didDefeatCreature:creature];
            }
        } else { // 未死亡
            
            // 5.等待攻击间隔
            NSTimeInterval attackWait = 1 / self.attackSpeed;
            SKAction *attackWaitAction = [SKAction waitForDuration:attackWait];
            [self runAction:attackWaitAction completion:^{
                [self fireWithCreature:creature bullet:bullet];
            }];
            
        }
        
        
        
    }];
    
    
}

#pragma mark 升级
- (void)upgrade
{
    if (self.level == self.maxLevel) return;
    
    // 1.增加属性
    self.level += 1;
    self.damage += self.damageIncerment;
    
    // 2.改变外观
}

#pragma mark 销毁
- (int)destory
{
    int sum = self.bulidCoin;
    
    for (int i = 0; i<self.level; i++) {
        sum += self.upgradeCoin;
    }
    
    return sum * self.destoryCoinRatio;
}

@end
