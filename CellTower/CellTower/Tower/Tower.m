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

+ (instancetype)towerWithModel:(TowerModel *)model
{
    Tower *tower = [Tower spriteNodeWithImageNamed:model.imageName];
    tower.size = CGSizeMake(30, 30);
    
    tower.imageName = [model.imageName copy];
    tower.range = model.range;
    tower.speed = model.speed;
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

+ (instancetype)towerWithModel:(TowerModel *)model position:(CGPoint)position
{
    Tower *tower = [self towerWithModel:model];
    tower.position = position;
    
    return tower;
}

- (BOOL)isWorking
{
    return (self.target != nil);
}

- (void)fireWithCreature:(Creature *)creature bullet:(SKSpriteNode *)bullet
{
    if (creature == nil) return;
    
    // 1.添加攻击目标
    self.target = creature;
    
    // 2.旋转
    // 计算角度
    CGPoint offset = CGPointMake(creature.position.x - self.position.x, creature.position.y - self.position.y);
    CGFloat angle = atan2f(offset.y, offset.x);
    
    [self runAction:[SKAction rotateToAngle:angle duration:0.2f] completion:^{
        // 3.发射子弹
        bullet.position = self.position;
        [bullet runAction:[SKAction moveTo:creature.position duration:0.2f] completion:^{
            [bullet removeFromParent];
        }];
        
        // 4.扣血判断怪物是否死亡
        creature.HP -= self.damage;
        
        if (creature.HP <= 0) {
            // 清除攻击目标
            self.target = nil;
            // 怪物死亡
            [creature removeFromParent];
        }
        
    }];
    
    
}

@end
