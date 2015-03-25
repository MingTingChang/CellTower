//
//  CreatureModel.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreatureModel : NSObject
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

#pragma mark - 方法
+ (instancetype)creatureModelWithType:(CreatureType)type;

@end
