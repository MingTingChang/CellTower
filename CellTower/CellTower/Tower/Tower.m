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


@end

@implementation Tower

- (NSMutableArray *)bullets {
    if (!_bullets) {
        _bullets = [NSMutableArray array];
    }
    return _bullets;
}

#pragma mark - 私有方法
#pragma mark 初始化
- (instancetype)initWithModel:(TowerModel *)model {
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

#pragma mrak 添加子弹
- (SKSpriteNode *)addBullet {
    SKSpriteNode *bullet = nil;
    
    if (self.type == TowerTypeShock) {
        bullet = [SKSpriteNode spriteNodeWithImageNamed:@"shock"];
        bullet.size = CGSizeMake(2, 2);
    } else if (self.type == TowerTypeCannon){
        bullet = [SKSpriteNode spriteNodeWithImageNamed:@"bullet"];
        bullet.size = CGSizeMake(6, 6);
    } else if (self.type == TowerTypeRocker){
        bullet = [SKSpriteNode spriteNodeWithImageNamed:@"rocker"];
        bullet.size = CGSizeMake(8, 8);
    } else {
        bullet = [SKSpriteNode spriteNodeWithImageNamed:@"bullet"];
        bullet.size = CGSizeMake(2, 2);
    }
    
    return bullet;
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
    
    self.target = [self.targets firstObject];
    [self attack:self.target];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 / self.attackSpeed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.targets.count > 0) {
            self.working = NO;
            [self attack];
        }
    });
    
}

#pragma mark 攻击某个怪物
- (void)attack:(Creature *)creature
{
    [self.bullets addObject:[self addBullet]];
    SKSpriteNode *bullet = [self.bullets lastObject];
    
    // 2.旋转
    SKAction *rotateAction = [SKAction rotateToAngle:[CTGeometryTool angleBetweenPoint1:creature.position andPoint2:self.position] duration:0.1f];
    [self runAction: rotateAction completion:^{
        // 3.发射子弹
        if (bullet.scene == nil) {
            [self.scene addChild:bullet];
        }
        bullet.position = self.position;
        bullet.hidden = NO;
        creature.HP -= self.damage;
        
        SKAction *moveAction = [SKAction moveTo:creature.position duration:0.4f];
        [bullet runAction:[SKAction sequence:@[rotateAction, moveAction]] completion:^{
            bullet.hidden = YES;
        }];
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

#pragma mark - 公共方法

- (NSMutableArray *)targets {
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
    
    [self attack];
}

#pragma mark 怪物离开攻击范围
- (void)creatureLeaveAttackRange:(Creature *)creature;
{
    [self.targets removeObject:creature];
    
    if (self.targets.count < 1) {
        self.working = NO;
    }
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
