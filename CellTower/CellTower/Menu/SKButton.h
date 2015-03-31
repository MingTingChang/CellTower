//
//  SKButton.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-25.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void(^TouchButtonCallBack)();

@interface SKButton : SKSpriteNode

// 标题
@property (nonatomic, copy) NSString *text;

// icon
@property (nonatomic, copy) NSString *iconName;

// 常规背景图片
@property (nonatomic, copy) NSString *bgImageName;

// 高亮背景图片
@property (nonatomic, copy) NSString *bgHighlightImageName;

// 标题节点
@property (nonatomic , strong) SKLabelNode *textNode;

@property (nonatomic , assign) int tag;

// 是否选中
@property (nonatomic , assign, getter=isSelected) BOOL selected;

// 是否失效
@property (nonatomic , assign, getter=isEnabled) BOOL enabled;

@property (nonatomic, copy) TouchButtonCallBack callback;

/**
 *  实例化
 */
+ (instancetype)button;

@end
