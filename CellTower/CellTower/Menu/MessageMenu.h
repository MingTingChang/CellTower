//
//  MessageMenu.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-25.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class MessageMenu;

@protocol MessageMenuDataSource <NSObject>

- (NSInteger)numberOfButtonInMessageMenu:(MessageMenu *)menu;
- (NSString *)messageMenu:(MessageMenu *)menu buttonNameOfRow:(NSInteger)row;

@end

@protocol MessageMenuDelegate <NSObject>

- (void)messageMenu:(MessageMenu *)menu didTouchButtonOfRow:(NSInteger)row;

@end

@interface MessageMenu : SKSpriteNode

@property (nonatomic , assign) int rowHeight;

@property (nonatomic , assign) int width;

#pragma mark 属性
/** 数据源 */
@property (nonatomic , weak) id<MessageMenuDataSource> dataSource;
/** 代理 */
@property (nonatomic , weak) id<MessageMenuDelegate> delegate;


#pragma mark 方法 
/**
 *  实例化
 */
+ (instancetype)messageMenu;

/**
 *  展示
 */
- (void)show;

@end
