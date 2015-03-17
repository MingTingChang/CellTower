//
//  CreatureModel.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//  基础怪物模型类

#import <Foundation/Foundation.h>

typedef enum {
    CreatureTypeBomb,  // 当敢死鬼死时,周围的塔防武器会受到爆 炸攻击.
    CreatureTypeBoss,  // 这是最强的鬼,强大到让你吃惊.如果你成 功消灭了它们,你会获得很多的奖励.
    CreatureTypeCoward,    // 这类鬼通常是一个紧接一个,成群的入侵 进攻的.对它们最有效的防守武器是火 箭手,加农炮和震荡波.
    CreatureTypeFast,  // 速度最快的一类鬼,但是血很短.快枪手 和冲击炮能很好的防守它们的进攻.
    CreatureTypeFly,   // 这类鬼能直接飞到出口.只有快枪和冲击 炮能威胁到它们.
    CreatureTypeIce,   // 当冰鬼经过武器时,武器会被冻结一段时 间,冻结时无法攻击.
    CreatureTypeNormal,    // 这类是最弱的鬼,无任何特殊能力,进攻速 度非常慢.
    CreatureTypeStrong // 这类鬼个子很大,移动速度很慢,但是也很 难消灭.
} CreatureType;

@interface CreatureModel : NSObject

#pragma mark - 属性
/** 生命值HP */
@property (nonatomic , assign) int HP;

/** 移动速度 */
@property (nonatomic , assign) int speed;

/** 怪物价值 */
@property (nonatomic , assign) int coin;

/** 怪物类型 */
@property (nonatomic , assign) CreatureType type;

#pragma mark - 方法

/** 根据字典实例化怪物模型的类方法 */
+ (instancetype)creatureWithDict:(NSDictionary *)dict;

/** 根据字典实例化怪物模型的对象方法 */
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
