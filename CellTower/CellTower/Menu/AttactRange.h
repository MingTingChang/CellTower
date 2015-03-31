//
//  AttactRange.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-25.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class Tower;

@interface AttactRange : SKShapeNode

/**
 *  实例化一个范围显示器
 *
 *  @param tower 塔
 */
+ (instancetype)attactRangeWithTower:(Tower *)tower;

@end
