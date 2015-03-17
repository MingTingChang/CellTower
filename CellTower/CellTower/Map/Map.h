//
//  Map.h
//  CellTower
//
//  Created by 刘挺 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum
{
    MapTypeOneEnterDoor,         //1个出怪点
    MapTypeTwoEnterDoor         //2个出怪点
} MapType;

@interface Map : SKSpriteNode

@property (nonatomic , strong) NSMutableArray *grid;

/** 栅格尺寸 */
@property (nonatomic , assign , readonly) CGSize gridSize;

/** 单位栅格所占像素点范围 gridPixel * gridPixel */
@property (nonatomic , assign) int gridPixel;

/** 地图类型 */
@property (nonatomic , assign) MapType mapType;


- (instancetype)initWithTexture:(SKTexture *)texture gridPixel:(int)pixel type:(MapType)type;
+ (instancetype)spriteWithTexture:(SKTexture *)texture gridPixel:(int)pixel type:(MapType)type;


- (NSArray *)findOutPathFrom:(CGPoint)from to:(CGPoint)to;

@end
