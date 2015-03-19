//
//  CTGeometryTool.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-19.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTGeometryTool : NSObject

/**
 *  判断两个园是否重叠
 *
 *  @param circle1 园1
 *  @param circle2 园2
 */
+ (BOOL)isOveriapBetweenCircle1:(CGRect)circle1 andCircle2:(CGRect)circle2;

/**
 *  计算两个点组成直线的角度
 *
 *  @param point1 点1
 *  @param point2 点2
 *
 *  @return 角度
 */
+ (CGFloat)angleBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2;
@end
