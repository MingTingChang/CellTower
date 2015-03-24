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
#import "SKNode+Expention.h"
#import "GameMap.h"

@interface Tower ()

@property (nonatomic , assign , readwrite) TowerType type;


@end

@implementation Tower

#pragma mark 子弹集合
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

#pragma mark 添加子弹
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
    } else if (self.type == TowerTypeSlowDown) {
        bullet = [SKSpriteNode spriteNodeWithImageNamed:@"slowDownBullet"];
        bullet.size = CGSizeMake(2, 2);
    } else {
        bullet = [SKSpriteNode spriteNodeWithImageNamed:@"bullet"];
        bullet.size = CGSizeMake(2, 2);
    }
    
    return bullet;
}

#pragma mark 目标数组清除隐藏怪物和死亡怪物
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
    if (self.isWorking == YES) return;
    self.working = YES;
    
    // 1.目标数组清除隐藏怪物和死亡怪物
    [self removeHiddenCreature];
    
    // 2.攻击怪物
    if (self.targets.count < 1) {
        self.working = NO;
        return;
    }
    self.target = [self.targets firstObject];
    [self shootWithCreature:self.target completion:^(Creature *creature) {
        // 扣血
        creature.HP -= self.damage;
        // 检测死亡
        if (creature.HP <= 0) {
            [self.targets removeObject:creature];
            
            if ([self.delegate respondsToSelector:@selector(tower:didDefeatCreature:)]) {
                [self.delegate tower:self didDefeatCreature:creature];
            }
        }
    }];
    
    
    // 2.等待攻击间隔
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
    if (creature == nil) return;
    
    creature.realHP -= self.damage;
    
    // 瞄准
    SKAction *rotateAction = [SKAction rotateToAngle:[CTGeometryTool angleBetweenPoint1:creature.position andPoint2:self.position] duration:0.1f];
    [self runAction:rotateAction completion:^{
        // 射击
        // 1.获得子弹
        [self.bullets addObject:[self addBullet]];
        SKSpriteNode *bullet = [self.bullets lastObject];
        if (bullet.parent == nil) {
            if ([self.parent isKindOfClass:[GameMap class]]) {
                GameMap *gameMap = (GameMap *)self.parent;
                [gameMap addChild:bullet];
            }
        }
    
        // 2.发射子弹
        bullet.position = self.position;
        [bullet trackToNode:creature duration:0.4f completion:^{
            [bullet removeFromParent];
            [self.bullets removeObject:bullet];
            if (completion) {
                completion(creature);
            }
            
        }];
        
    }];
}

#pragma mark - 公共方法
- (NSMutableArray *)targets {
    if (!_targets) {
        _targets = [NSMutableArray array];
    }
    return _targets;
}

#pragma mark 根据模型实例化塔
+ (instancetype)towerWithModel:(TowerModel *)model {
    return [[self alloc] initWithModel:model];
}

#pragma mark 根据模型和位置实例化塔
+ (instancetype)towerWithModel:(TowerModel *)model position:(CGPoint)position {
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
