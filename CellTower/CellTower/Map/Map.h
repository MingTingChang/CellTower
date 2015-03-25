//
//  Map.h
//  Map
//
//  Created by 刘挺 on 15-3-19.
//  Copyright (c) 2015年 liuting. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 图的节点类 */
@interface MapPoint : NSObject

@property (nonatomic , assign) CGPoint point;

@property (nonatomic , assign) int value;

@property (nonatomic , assign) double dreamValue;

- (instancetype)initWithPoint:(CGPoint)point value:(int)value;
+ (instancetype)pointWithPoint:(CGPoint)point value:(int)value;
+ (instancetype)copyWithMapPoint:(MapPoint *)point;
@end


/** 图类 */
@interface Map : NSObject
/** 墙的集合 */
@property (nonatomic , strong) NSMutableArray *walls; //里面装的是NSValue对象包裹CGPoint
/** 图的尺寸 */
@property (nonatomic , assign) CGSize size;
/** 从左往右行走的右终点坐标 */
@property (nonatomic , assign) CGPoint rightTarget;
/** 从左往右行走的搜索图 */
@property (nonatomic , strong) NSMutableArray *rightPathMap;
/** 从上往下行走的下终点坐标 */
@property (nonatomic , assign) CGPoint bottomTarget;
/** 从上往下行走的搜索图 */
@property (nonatomic , strong) NSMutableArray *bottomPathMap;
/** 原始图有没有被修改 */
@property (nonatomic , assign , getter=isChange) BOOL change;

+ (instancetype)copyWithMap:(Map *)map;

/** 初始化方法 rightDoor为右终点 bottomDoor为下终点 */
- (instancetype)initWithSize:(CGSize)size rightDoor:(CGPoint)right bottomDoor:(CGPoint)bottom;
+ (instancetype)mapWithSize:(CGSize)size rightDoor:(CGPoint)right bottomDoor:(CGPoint)bottom;

/** 添加和删除墙的方法 */
- (void)addMapWallWithPoint:(CGPoint)point;
- (void)removeMapWallWithPoint:(CGPoint)point;

/** 根据起点和行走方向搜索路径 */
- (NSMutableArray *)findPathFromPoint:(CGPoint)from direction:(PathDirect)direct;

@end
