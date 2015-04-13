//
//  SwitchButtonNode.m
//  test
//
//  Created by 刘奥明 on 15-4-2.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "SwitchButtonNode.h"

@implementation SwitchButtonNode

- (instancetype)initWithButtonNamed:(NSString *)name
{
    if (self = [super initWithButtonNamed:name]) {
        
        self.iconOffName = [NSString stringWithFormat:@"ui_icon_%@_off", name];
        
        // 2.恢复偏好设置
        self.selected = [[NSUserDefaults standardUserDefaults] boolForKey:self.name];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    NSString *name = selected ? self.iconName : self.iconOffName;
    self.iconNode.texture = [SKTexture textureWithImageNamed:name];
    
    // 储存偏好设置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:selected forKey:self.name];
    [defaults synchronize];
}

- (void)touchButton
{
    // 0.设置选中状态
    self.selected = !self.isSelected;
    
    // 1.放大图标
    [self scaleIconNode];
}

- (void)scaleIconNode
{
    if ([self.iconNode hasActions]) return;
    SKAction *big = [SKAction scaleTo:1.1f duration:0.2f];
    SKAction *small = [SKAction scaleTo:1.0f duration:0.2f];
    SKAction *scaleAction = [SKAction sequence:@[big, small]];
    
    [self.iconNode runAction:scaleAction];
}

@end
