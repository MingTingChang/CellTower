//
//  CTGeometryTool.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-19.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "CTGeometryTool.h"

@implementation CTGeometryTool

+ (BOOL)isOveriapBetweenCircle1:(CGRect)circle1 andCircle2:(CGRect)circle2
{
    // 1.取出半径
    CGFloat radius1 = circle1.size.width/2.0;
    CGFloat radius2 = circle2.size.width/2.0;
    
    // 2.取出圆心
    CGPoint c1 = CGPointMake(circle1.origin.x + radius1, circle1.origin.y + radius1);
    CGPoint c2 = CGPointMake(circle2.origin.x + radius2, circle2.origin.y + radius2);
    
    // 计算圆心距
    CGPoint offset = CGPointMake(c1.x - c2.x, c1.y - c2.y);
    CGFloat distance = sqrtf(offset.x*offset.x + offset.y*offset.y);
    
    return ( distance <= (radius1 + radius2) );
}

+ (CGFloat)angleBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2
{
    CGPoint offset = CGPointMake(point1.x - point2.x, point1.y - point2.y);
    return atan2f(offset.y, offset.x);
}

+ (CGPoint)gridPointFromPixelPoint:(CGPoint)point gridPixel:(int)gridPixel
{
    int gridX = point.x / gridPixel;
    int gridY = point.y / gridPixel;
    return CGPointMake(gridX, gridY);
}

+ (CGPoint)pixelPointFromGridPoint:(CGPoint)point gridPixel:(int)gridPixel
{
    int pixelX = point.x * gridPixel + gridPixel * 0.5;
    int pixelY = point.y * gridPixel + gridPixel * 0.5;
    return CGPointMake(pixelX, pixelY);
}

@end
