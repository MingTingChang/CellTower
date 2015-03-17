//
//  Tower.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//  基础塔类

#import <Foundation/Foundation.h>
@class TowerModel;
@class Creature;

typedef enum{
    BulletTypeSigle, // 单攻
    BulletTypeMore,  // 群攻
    BulletTypeSpurting,  // 溅射
    BulletTypeSlowDown   // 减速
} BulletType;

@interface Tower : NSObject

#pragma mark - 属性
/** 塔模型 */
@property (nonatomic , strong) TowerModel *model;

/** 子弹类型 */
@property (nonatomic , assign) BulletType bulletType;

/** 攻击目标 */
@property (nonatomic , strong) Creature *target;

/** 是否正在攻击 */
@property (nonatomic , assign ,getter=isWorking) BOOL working;

#pragma mark - 方法
/** 打怪物 */
- (void)fireWithCreature:(Creature *)creature;

/** 升级 */
- (void)upgrade;

/** 拆除 */
- (void)destory;

@end
