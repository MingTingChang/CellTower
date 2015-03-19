//
//  Tower.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//  基础塔类

#import <SpriteKit/SpriteKit.h>
#import "TowerModel.h"
@class Creature;
@class Tower;

@protocol TowerDelegate <NSObject>
@optional
/**
 *  塔已经消灭怪物的代理方法 (死亡怪物未销毁)
 *
 *  @param tower    塔
 *  @param creature 被消灭的怪物
 */
- (void)tower:(Tower *)tower didDefeatCreature:(Creature *)creature;

@end

@interface Tower : SKSpriteNode

#pragma mark - 属性
/** 图片名称 */
@property (nonatomic, copy) NSString *imageName;

/** 攻击距离 */
@property (nonatomic , assign) int range;

/** 攻击速度 */
@property (nonatomic , assign) int attackSpeed;

/** 攻击力 */
@property (nonatomic , assign) int damage;

/** 炮台类型 */
@property (nonatomic , assign , readonly) TowerType type;

/** 当前等级 */
@property (nonatomic , assign) int level;

/** 最大等级 */
@property (nonatomic , assign) int maxLevel;

/** 攻击力随等级提升数值 */
@property (nonatomic , assign) int damageIncerment;

/** 建立消耗金币 */
@property (nonatomic , assign) int bulidCoin;

/** 升级消耗金币 */
@property (nonatomic , assign) int upgradeCoin;

/** 拆除获得金币比值 */
@property (nonatomic , assign) double destoryCoinRatio;

/** 所占栅格 */
@property (nonatomic , assign) int grid;

/** 子弹类型 */
@property (nonatomic , assign , readonly) BulletType bulletType;

/** 攻击目标 */
@property (nonatomic , strong) Creature *target;

/** 是否正在攻击 */
@property (nonatomic , assign ,getter=isWorking) BOOL working;

/** 代理 */
@property (nonatomic , weak) id<TowerDelegate> delegate;

#pragma mark - 方法
/**
 *  实例化塔
 *
 *  @param model 塔模型
 */
+ (instancetype)towerWithModel:(TowerModel*)model;

/**
 *  实例化塔
 *
 *  @param model    塔模型
 *  @param position 位置
 */
+ (instancetype)towerWithModel:(TowerModel*)model position:(CGPoint)position;

/**
 *  打怪物
 *
 *  @param creature 怪物节点
 *  @param bullet   子弹节点
 */
- (void)fireWithCreature:(Creature *)creature bullet:(SKSpriteNode *)bullet;

/** 升级 */
- (void)upgrade;

/** 拆除 */
- (int)destory;

@end
