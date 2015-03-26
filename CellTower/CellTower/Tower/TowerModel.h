//
//  TowerModel.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Creature;

@interface TowerModel : NSObject
/** 图片名称 */
@property (nonatomic, copy) NSString *imageName;

/** 攻击距离 */
@property (nonatomic , assign) int range;

/** 攻击速度 */
@property (nonatomic , assign) double attackSpeed;

/** 攻击力 */
@property (nonatomic , assign) int damage;

/** 炮台类型 */
@property (nonatomic , assign ,readonly) TowerType type;

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

/** 是否正在攻击 */
@property (nonatomic , assign ,getter=isWorking) BOOL working;

#pragma mark - 方法
+ (instancetype)towerModelWithType:(TowerType)type;

@end
