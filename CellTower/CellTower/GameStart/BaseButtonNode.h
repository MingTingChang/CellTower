//
//  BaseButtonNode.h
//  test
//
//  Created by 刘奥明 on 15-4-2.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class BaseButtonNode;

#define kMargin 10
#define kWidth 194
#define kHeight 72
#define kIconCenterX -62
#define kTitleCenterX 28
#define kIconWidth 50
#define kTitleWidth 110
#define kTitleHeight 30

@interface BaseButtonNode : SKSpriteNode
// 图标节点
@property (nonatomic , strong) SKSpriteNode *iconNode;
// 名称
@property (nonatomic, copy) NSString *name;
// 图标名称
@property (nonatomic, copy) NSString *iconName;


/** 根据名字实例化节点 */
+ (instancetype)buttonNodeWithName:(NSString *)name;

- (instancetype)initWithButtonNamed:(NSString *)name;
@end
