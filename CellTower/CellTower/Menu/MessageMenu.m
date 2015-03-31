//
//  MessageMenu.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-25.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "MessageMenu.h"
#import "SKButton.h"

@interface MessageMenu()

@property (nonatomic , assign) NSInteger buttonCount;
@property (nonatomic , strong) NSMutableArray *buttons;

@end

@implementation MessageMenu

- (NSMutableArray *)buttonNames {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

#pragma mrak - 私有方法
#pragma mark 初始化

- (instancetype)initWithImageNamed:(NSString *)name
{
    if (self = [super initWithImageNamed:name]) {
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

#pragma mark - 刷新数据
- (void)reloadData
{
    // 1.重新获取数据
    if ([self.dataSource respondsToSelector:@selector(numberOfButtonInMessageMenu:)]) {
        self.buttonCount = [self.dataSource numberOfButtonInMessageMenu:self];
    }
    
    if ([self.dataSource respondsToSelector:@selector(messageMenu:buttonNameOfRow:)]) {
        self.buttons = nil;
        for (int i = 0; i<self.buttonCount; ++i) {
            NSString *name = [self.dataSource messageMenu:self buttonNameOfRow:i];
            [self.buttonNames addObject:name];
        }
    }
    
    [self removeAllChildren];
    // 2.添加按钮
    for (int i = 0; i < self.buttons.count; ++i) {
        NSString *name = self.buttons[i];
        [self addButtonWithName:name tag:i];
    }
    
    // 3.排列位置
    [self layoutChild];
    
    // 4.重设大小
    self.size = CGSizeMake(_width, _rowHeight *_buttonCount);
}

#pragma mark 排列子按钮
- (void)layoutChild
{
    for (int i = 0; i<self.children.count; ++i) {
        CGFloat buttonY =i*_rowHeight - _rowHeight*0.5 ;
        
        SKButton *button = self.children[i];
        button.position = CGPointMake(0, buttonY);
    }
}

#pragma mark 添加按钮
- (void)addButtonWithName:(NSString *)name tag:(int)tag
{
    SKButton *button = [SKButton button];
    button.bgImageName = @"bullet";
    button.bgHighlightImageName = @"test.jpg";
    button.text = @"哈哈";
    button.tag = tag;
    button.size = CGSizeMake(_width, _rowHeight);
    button.callback = ^(){
        if ([self.delegate respondsToSelector:@selector(messageMenu:didTouchButtonOfRow:)]) {
            [self.delegate messageMenu:self didTouchButtonOfRow:tag];
        }
    };
    [self addChild:button];
}



#pragma mark - 公共方法
+ (instancetype)messageMenu
{
    return [[self alloc] initWithImageNamed:@"test.jpg"];
}

#pragma mark 展示
- (void)show
{
    [self reloadData];
}

@end
