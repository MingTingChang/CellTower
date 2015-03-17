//
//  Map.h
//  CellTower
//
//  Created by 刘挺 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    MapTypeTwoDoor,         //2个门
    MapTypeFourDoor         //4个门
} MapType;

@interface Map : NSObject

@property (nonatomic , strong) NSMutableArray *grid;

/**
    像素尺寸
 */
@property (nonatomic , assign) CGSize pixelSize;

/**
    栅格尺寸
 */
@property (nonatomic , assign) CGSize gridSize;

/**
    单位栅格所占像素点范围 gridPixel * gridPixel
 */
@property (nonatomic , assign) int gridPixel;

/**
    地图类型
 */
@property (nonatomic , assign) MapType mapType;

+ (instancetype)shareMap;

+ (void)initMapWithPixelSize:(CGSize)pixelSize gridPixel:(int)pixel type:(MapType)mapType;

- (void)makeMapGridDisableWithPoint:(CGPoint)point;

@end
