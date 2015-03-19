//
//  Tower.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "Tower.h"
#import "Creature.h"
#import "CTGeometryTool.h"

@interface Tower ()

@property (nonatomic , assign , readwrite) TowerType type;
@property (nonatomic , assign , readwrite) BulletType bulletType;

@end

@implementation Tower

#pragma mark - 私有方法
#pragma mark 初始化
- (instancetype)initWithModel:(TowerModel *)model
{
    if (self = [super initWithImageNamed:model.imageName]) {
        
        self.size = CGSizeMake(30, 30);
        self.zPosition = 1;
        
        self.imageName = [model.imageName copy];
        self.range = model.range;
        self.attackSpeed = model.attackSpeed;
        self.damage = model.damage;
        self.type = model.type;
        self.level = model.level;
        self.maxLevel = model.maxLevel;
        self.damageIncerment = model.damageIncerment;
        self.bulidCoin = model.bulidCoin;
        self.upgradeCoin = model.upgradeCoin;
        self.destoryCoinRatio = model.destoryCoinRatio;
        self.grid = model.grid;
        self.bulletType = model.bulletType;
        self.working = model.working;
        
    }
    return self;
}

#pragma mark - 公共方法
#pragma mark 根据模型实例化塔
+ (instancetype)towerWithModel:(TowerModel *)model
{
    return [[self alloc] initWithModel:model];
}

#pragma mark 根据模型和位置实例化塔
+ (instancetype)towerWithModel:(TowerModel *)model position:(CGPoint)position
{
    Tower *tower = [self towerWithModel:model];
    tower.position = position;
    
    return tower;
}

#pragma mark 攻击
- (void)fireWithCreature:(Creature *)creature bullet:(SKSpriteNode *)bullet
{
    if (creature == nil) return;
    
    // 1.添加攻击目标
    self.target = creature;
    
    // 2.旋转
    [self runAction:[SKAction rotateToAngle:[CTGeometryTool angleBetweenPoint1:creature.position andPoint2:self.position] duration:0.1f] completion:^{
        
        // 3.发射子弹
        bullet.position = self.position;
        bullet.hidden = NO;
        [bullet runAction:[SKAction moveTo:creature.position duration:0.5f] completion:^{
            bullet.hidden = YES;
        }];
        
        // 4.扣血判断怪物是否死亡
        creature.HP -= self.damage;
        // 5.判断怪物是否离开射程
        CGRect towerAttactRect = CGRectMake(self.position.x - self.range*10, self.position.y - self.range*10, self.range*80, self.range*80);
        BOOL IsLeave = ![CTGeometryTool isOveriapBetweenCircle1:creature.frame andCircle2:towerAttactRect];
        
        if (creature.HP <= 0) { // 死亡
            // 清除攻击目标
            self.target = nil;
            
            [bullet removeFromParent];
            if ([self.delegate respondsToSelector:@selector(tower:didDefeatCreature:)]) {
                [self.delegate tower:self didDefeatCreature:creature];
            }
        } else if (IsLeave){ // 离开射程
            // 清除攻击目标
            self.target = nil;
        } else {
            // 5.等待攻击间隔
            NSTimeInterval attackWait = 1 / self.attackSpeed;
            SKAction *attackWaitAction = [SKAction waitForDuration:attackWait];
            [self runAction:attackWaitAction completion:^{
                [self fireWithCreature:creature bullet:bullet];
            }];
        }
    }];
}

#pragma mark 塔是否在工作
- (BOOL)isWorking
{
    return (self.target != nil);
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
