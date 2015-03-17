//
//  Creature.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class CreatureModel;
@class MovePath;

@interface Creature : SKSpriteNode
#pragma mark - 属性
/** 怪物模型 */
@property (nonatomic , strong) CreatureModel *creatureModel;

/** 怪物是否隐形 */
@property (nonatomic , assign, getter=isHidden) BOOL hidden;

/** 怪物是否被减速 */
@property (nonatomic , assign, getter=isSlowDown) BOOL slowDown;

#pragma mark - 方法

/** 根据路径进行移动 */
- (void)moveWith:(MovePath *)movePath;

@end
