//
//  TowerModel.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Creature;

typedef enum{
    TowerTypeAir, // 高成本的中程防守武器,对飞信鬼造成极 大伤害.
    TowerTypeCannon, // 高成本防守武器,射出的炮弹具有毒性, 对地面入侵者造成山伤害,但是载弹慢.
    TowerTypeRadar, // 雷达没有攻击力,是用来探测隐形鬼的.
    TowerTypeRocker, // 中成本远射程武器,只能攻击地面入侵者, 不能攻击空中入侵者.
    TowerTypeShock, // 射击频率慢,只能攻击地面的入侵者,对 飞行鬼无效.
    TowerTypeSlowDown, // 中成本防守武器,攻击力较小,但能减慢 入侵者一半速度.
    TowerTypeSniper // 最便宜和最快速的射手,能攻击地面和空 中的入侵者.
} TowerType;

typedef enum{
    BulletTypeSigle, // 单攻
    BulletTypeMore,  // 群攻
    BulletTypeSpurting,  // 溅射
    BulletTypeSlowDown   // 减速
} BulletType;

@interface TowerModel : NSObject
/** 图片名称 */
@property (nonatomic, copy) NSString *imageName;

/** 攻击距离 */
@property (nonatomic , assign) int range;

/** 攻击速度 */
@property (nonatomic , assign) int attackSpeed;

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

/** 子弹类型 */
@property (nonatomic , assign ,readonly) BulletType bulletType;

/** 攻击目标 */
@property (nonatomic , strong) Creature *target;

/** 是否正在攻击 */
@property (nonatomic , assign ,getter=isWorking) BOOL working;

#pragma mark - 方法
+ (instancetype)towerModelWithType:(TowerType)type;

@end
