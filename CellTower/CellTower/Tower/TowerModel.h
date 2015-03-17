//
//  TowerModel.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//  基础塔类

#import <Foundation/Foundation.h>
typedef enum{
    TowerTypeAir, // 高成本的中程防守武器,对飞信鬼造成极 大伤害.
    TowerTypeCannon, // 高成本防守武器,射出的炮弹具有毒性, 对地面入侵者造成山伤害,但是载弹慢.
    TowerTypeRadar, // 雷达没有攻击力,是用来探测隐形鬼的.
    TowerTypeRocker, // 中成本远射程武器,只能攻击地面入侵者, 不能攻击空中入侵者.
    TowerTypeShock, // 射击频率慢,只能攻击地面的入侵者,对 飞行鬼无效.
    TowerTypeSlowDown, // 中成本防守武器,攻击力较小,但能减慢 入侵者一半速度.
    TowerTypeSniper // 最便宜和最快速的射手,能攻击地面和空 中的入侵者.
} TowerType;

@interface TowerModel : NSObject
#pragma mark - 属性
/** 攻击距离 */
@property (nonatomic , assign) int range;

/** 攻击速度 */
@property (nonatomic , assign) int speed;

/** 攻击力 */
@property (nonatomic , assign) int damage;

/** 炮台类型 */
@property (nonatomic , assign) TowerType type;

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

#pragma mark - 方法
/** 根据字典实例化塔模型的类方法 */
+ (instancetype)TowerModelWithDict:(NSDictionary *)dict;

/** 根据字典实例化塔模型的对象方法 */
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
