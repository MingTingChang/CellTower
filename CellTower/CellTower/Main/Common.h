//
//  Common.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-22.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#pragma mark - 宏定义
#pragma mark 设置碰撞掩码
// 怪物类别
#define creatureCategory (1 << 0)
// 塔类别
#define towerCategory (1 << 1)
// 雷达类别
#define radarTowerCategory (1 << 2)

#define CreatureTypeNumber 8
#define TowerTypeNumber 7
//默认单元栅格像素
#define MapGridPixelNormalValue 10

// 开启/关闭声音储存Key
#define kAudio @"audio"

#pragma mark - 枚举定义
typedef enum{
    CreatureOutletLeft = 0, // 左边出来
    CreatureOutletUp = 1    // 上面出
} CreatureOutlet;

typedef enum
{
    PathDirectLeftToRight = 0,      //行走方向为从左往右
    PathDirectTopToBottom = 1       //行走方向为从上往下
}PathDirect;

typedef enum {
    CreatureTypeBomb = 0,  // 当敢死鬼死时,周围的塔防武器会受到爆 炸攻击.
    CreatureTypeBoss,  // 这是最强的鬼,强大到让你吃惊.如果你成 功消灭了它们,你会获得很多的奖励.
    CreatureTypeCoward,    // 这类鬼通常是一个紧接一个,成群的入侵 进攻的.对它们最有效的防守武器是火 箭手,加农炮和震荡波.
    CreatureTypeFast,  // 速度最快的一类鬼,但是血很短.快枪手 和冲击炮能很好的防守它们的进攻.
    CreatureTypeFly,   // 这类鬼能直接飞到出口.只有快枪和冲击 炮能威胁到它们.
    CreatureTypeIce,   // 当冰鬼经过武器时,武器会被冻结一段时 间,冻结时无法攻击.
    CreatureTypeNormal,    // 这类是最弱的鬼,无任何特殊能力,进攻速 度非常慢.
    CreatureTypeStrong // 这类鬼个子很大,移动速度很慢,但是也很 难消灭.
} CreatureType;

typedef enum{
    TowerTypeAir = 0, // 高成本的中程防守武器,对飞信鬼造成极 大伤害.
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

typedef enum
{
    MapTypeNone = 0,            //默认
    MapTypeOneInOneOut = 1,     //一个入口、一个出口
    MapTypeTwoInTwoOut = 2      //两个入口、两个出口
} MapType;


