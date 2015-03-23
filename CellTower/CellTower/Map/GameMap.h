//
//  GameMap.h
//  CellTower
//
//  Created by 刘挺 on 15-3-20.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TowerModel.h"
#import "CreatureModel.h"

typedef enum
{
    MapTypeNone = 0,
    MapTypeOneInOneOut = 1,
    MapTypeTwoInTwoOut = 2
} MapType;

@class Map;

@interface GameMap : SKSpriteNode

@property (nonatomic , strong) Map *map;

@property (nonatomic , assign) int gridPixel;

@property (nonatomic , assign) MapType type;

@property (nonatomic , strong) NSMutableArray *creatures;

@property (nonatomic , strong) NSMutableArray *towers;

@property (nonatomic , strong) NSMutableArray *towerModels;

@property (nonatomic , strong) NSMutableArray *creatureModels;

/**
 *  添加塔到图上
 *
 *  @param type  塔的类型
 *  @param point 塔的起点
 */
- (void)addTowerWithType:(TowerType)type point:(CGPoint)point;
/**
 *  添加妖怪
 *
 *  @param type  妖怪类型
 *  @param point 妖怪起点
 */
- (void)addCreatureWithType:(CreatureType)type point:(CGPoint)point;
/**
 *  设置栅格图
 */
- (void)setupGridMap;

/**
 *  初始化方法
 *  默认gridPixel单位栅格为10*10像素
 */
- (instancetype)initWithImageNamed:(NSString *)name mapType:(MapType)type;
- (instancetype)initWithImageNamed:(NSString *)name gridPixel:(int)gridPixel
                           mapType:(MapType)type;
+ (instancetype)spriteNodeWithImageNamed:(NSString *)name mapType:(MapType)type;
+ (instancetype)spriteNodeWithImageNamed:(NSString *)name gridPixel:(int)gridPixel
                                 mapType:(MapType)type;

- (void)removeAllTowers;
- (void)removeAllCreatures;


@end
