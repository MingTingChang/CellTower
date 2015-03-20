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
        
        self.size = CGSizeMake(20, 20);
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
        self.working = model.working;
        
    }
    return self;
}

#pragma mark 攻击
- (void)attack
{
    // 1.添加攻击目标
    self.target = [self.targets firstObject];
    
    // 2.旋转
    [self runAction:[SKAction rotateToAngle:[CTGeometryTool angleBetweenPoint1:self.target.position andPoint2:self.position] duration:0.1f] completion:^{
        // 3.发射子弹
        if (self.bullet.scene == nil) {
            [self.scene addChild:self.bullet];
        }
        self.bullet.position = self.position;
        self.bullet.hidden = NO;
        [self.bullet runAction:[SKAction moveTo:self.target.position duration:0.4f] completion:^{
            self.bullet.hidden = YES;
            self.target.HP -= self.damage;
        }];
    }];
    
    if (self.target.HP <= 0) { // 死亡
        // 清除攻击目标
        self.target = nil;
        [self.targets removeObject:self.target];
        [self.bullet removeFromParent];
        
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(tower:didDefeatCreature:)]) {
            [self.delegate tower:self didDefeatCreature:self.target];
        }
    }
    
    // 5.等待攻击间隔
    NSTimeInterval attackWait = 1 / self.attackSpeed;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(attackWait * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.targets.count > 0) {
            [self attack];
            
            if (self.target != self.targets[0]) {
                self.target = nil;
            }
        } else{
            self.target = nil;
        }
    });
    
}

#pragma mark - 公共方法

- (NSMutableArray *)targets{
    if (!_targets) {
        _targets = [NSMutableArray array];
    }
    return _targets;
}

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

#pragma mark 怪物进入攻击范围
- (void)creatureIntoAttackRange:(Creature *)creature
{
    [self.targets addObject:creature];
    
    if (self.isWorking == NO)
    {
        [self attack];
    }
}

#pragma mark 怪物离开攻击范围
- (void)creatureLeaveAttackRange:(Creature *)creature;
{
    [self.targets removeObject:creature];
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

#pragma mrak 子弹节点get方法
- (SKSpriteNode *)bullet
{
    if (!_bullet) {
        if (self.type == TowerTypeShock) {
            _bullet = [SKSpriteNode spriteNodeWithImageNamed:@"shock"];
        } else {
            _bullet = [SKSpriteNode spriteNodeWithImageNamed:@"bullet"];
        }
        _bullet.size = CGSizeMake(5, 5);
    }
    return _bullet;
}

@end
