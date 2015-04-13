//
//  JumpButtonNode.m
//  test
//
//  Created by 刘奥明 on 15-3-31.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "JumpButtonNode.h"

@implementation JumpButtonNode

#pragma mark 旋转iconNode
- (void)rotateIconNode
{
    if ([self.iconNode hasActions]) return;
    SKAction *rotateAction = [SKAction rotateByAngle:-M_PI * 2 duration:2.0f];
    rotateAction.timingMode = SKActionTimingEaseInEaseOut;
    
    SKAction *big = [SKAction scaleTo:1.1f duration:0.2f];
    SKAction *small = [SKAction scaleTo:1.0f duration:0.2f];
    SKAction *scaleAction = [SKAction sequence:@[big, small]];
    
    [self.iconNode runAction:[SKAction group:@[rotateAction, scaleAction]]];
}

@end
