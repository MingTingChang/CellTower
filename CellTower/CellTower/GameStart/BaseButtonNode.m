//
//  BaseButtonNode.m
//  test
//
//  Created by 刘奥明 on 15-4-2.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "BaseButtonNode.h"

#import "BaseButtonNode.h"

@interface BaseButtonNode()

@end

@implementation BaseButtonNode

+ (instancetype)buttonNodeWithName:(NSString *)name
{
    return [[self alloc] initWithButtonNamed:name];
}

#pragma mark - 私有方法
#pragma mark 初始化touchButton
- (instancetype)initWithButtonNamed:(NSString *)name
{
    if (self = [super initWithImageNamed:@"ui_frame_menu"]) {
        self.size = CGSizeMake(kWidth, kHeight);
        self.name = name;
        
        _iconName = [NSString stringWithFormat:@"ui_icon_%@", name];
        NSString *titleName = [NSString stringWithFormat:@"ui_title_%@", name];
        
        // 1.添加图标
        SKSpriteNode *iconNode = [SKSpriteNode spriteNodeWithImageNamed:_iconName];
        iconNode.size = CGSizeMake(kIconWidth, kIconWidth);
        iconNode.position = CGPointMake(kIconCenterX, 0);
        [self addChild:iconNode];
        self.iconNode = iconNode;
        
        // 2.添加标题
        SKSpriteNode *titleNode = [SKSpriteNode spriteNodeWithImageNamed:titleName];
        titleNode.size = CGSizeMake(kTitleWidth, kTitleHeight);
        titleNode.position = CGPointMake(kTitleCenterX, 0);
        [self addChild:titleNode];
    }
    return self;
}

@end