//
//  Creature.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//  基础怪物类

#import <SpriteKit/SpriteKit.h>
#import "CreatureModel.h"
@class Tower;
@class Creature;

typedef enum{
    CreatureOutletUp, // 上面出
    CreatureOutletLeft // 左边出来
} CreatureOutlet;

@protocol CreatureDelegate <NSObject>
@optional
- (void)creatureMoveStateDidChange:(Creature *)creature;

@end

@interface Creature : SKSpriteNode
#pragma mark - 属性
/** 图片名字 */
@property (nonatomic, copy) NSString *imageName;
/** 生命值HP */
@property (nonatomic , assign) int HP;

/** 移动速度 */
@property (nonatomic , assign) int moveSpeed;

/** 怪物价值 */
@property (nonatomic , assign) int coin;

/** 怪物类型 */
@property (nonatomic , assign ,readonly) CreatureType type;

/** 怪物是否隐形 */
@property (nonatomic , assign, getter=isCreatureHidden) BOOL creatureHidden;

/** 怪物是否被减速 */
@property (nonatomic , assign, getter=isSlowDown) BOOL slowDown;

/** 减速环 */
@property (nonatomic , strong) SKSpriteNode *SlowDownCircle;

/** 怪物从那个出口出来 */
@property (nonatomic , assign) CreatureOutlet outlet;

/** 立即血量 */
@property (nonatomic , assign) int realHP;

/** 代理 */
@property (nonatomic , weak) id<CreatureDelegate> delegate;

#pragma mark - 方法

/**
 *  实例化怪物
 *
 *  @param model 怪物模型
 */
+ (instancetype)creatureWithModel:(CreatureModel *)model;

/**
 *  实例化怪物
 *
 *  @param model    怪物模型
 *  @param position 位置
 */
+ (instancetype)creatureWithModel:(CreatureModel *)model position:(CGPoint)position;


/**
 *  移动
 *
 *  @param movePath 移动路径
 */
- (void)moveWithPath:(NSArray *)movePath;

/**
 *  被减速
 *
 *  @param tower 减速的塔
 */
- (void)beSlowDown:(Tower *)tower;

@end
