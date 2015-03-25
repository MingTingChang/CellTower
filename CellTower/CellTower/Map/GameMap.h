//
//  GameMap.h
//  CellTower
//
//  Created by 刘挺 on 15-3-20.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Map;

@interface GameMap : SKSpriteNode

@property (nonatomic , assign) long gold;

@property (nonatomic , assign) int curWaveNum;

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
 *  @param outlet 妖怪诞生方向
 */
- (void)addCreatureWithType:(CreatureType)type;
- (void)addCreatureWithType:(CreatureType)type outlet:(CreatureOutlet)outlet;

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
+ (instancetype)mapWithType:(MapType)type;

- (void)removeAllTowers;
- (void)removeAllCreatures;


@end
