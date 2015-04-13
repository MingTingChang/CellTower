//
//  SKButton.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-25.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "SKButton.h"

@interface SKButton ()

@property (nonatomic , strong) SKSpriteNode *iconNode;

@end

@implementation SKButton

- (SKSpriteNode *)iconNode {
    if (!_iconNode) {
        _iconNode = [[SKSpriteNode alloc] init];
    }
    return _iconNode;
}

- (SKLabelNode *)textNode{
    if (_textNode == nil) {
        _textNode = [[SKLabelNode alloc] init];
    }
    return _textNode;
}

#pragma mark 初始化方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark 实例化按钮
+ (instancetype)button
{
    return [[self alloc] init];
}

#pragma mark 点击开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.bgHighlightImageName) {
        self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.bgHighlightImageName]];
    }
}

#pragma mark 背景图片名字
- (void)setBgImageName:(NSString *)bgImageName
{
    _bgImageName = bgImageName;
    self.texture = [SKTexture textureWithImageNamed:bgImageName];
}

#pragma mark 大小
- (void)setSize:(CGSize)size
{
    [super setSize:size];
    self.text = self.text;
}

#pragma mark 标题
- (void)setText:(NSString *)text
{
    _text = text;
    
    self.textNode.text = text;
    self.textNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    self.textNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.textNode.fontSize = self.size.height * 0.5;
    
    if (self.textNode.parent == nil) {
        [self addChild:self.textNode];
    }
}

#pragma mark 点击结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.bgImageName) {
        self.texture = [SKTexture textureWithImage:[UIImage imageNamed:self.bgImageName]];
    }
    
    if (self.callback) {
        self.callback();
    }
}

#pragma mark 失效
- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    if (enabled) {
        self.userInteractionEnabled = YES;
    } else {
        self.userInteractionEnabled = NO;
    }
}

@end
