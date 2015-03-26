//
//  SKNode+Expention.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-22.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "SKNode+Expention.h"
#import "CTGeometryTool.h"

@implementation SKNode (Expention)

- (void)trackToNode:(SKNode *)node duration:(NSTimeInterval)duration completion:(Completion)completion
{
    if (node == nil)
    {
        if (completion) {
            completion();
        }
        return;
    }
    CGPoint offset = CGPointMake(node.position.x - self.position.x, node.position.y - self.position.y);
    CGPoint point = CGPointMake(self.position.x + offset.x/2, self.position.y + offset.y/2);
    SKAction *firstMove = [SKAction moveTo:point duration:duration/2.0];
    SKAction *firstRotate = [SKAction rotateToAngle:[CTGeometryTool angleBetweenPoint1:point andPoint2:self.position] duration:0.01f];
    
    [self runAction:[SKAction group:@[firstMove, firstRotate]] completion:^{
        if (node == nil)
        {
            if (completion) {
                completion();
            }
            return;
        }
        CGPoint offset = CGPointMake(node.position.x - self.position.x, node.position.y - self.position.y);
        CGPoint point = CGPointMake(self.position.x + offset.x/2, self.position.y + offset.y/2);
        SKAction *secMove = [SKAction moveTo:point duration:duration/4.0];
        SKAction *secRotate = [SKAction rotateToAngle:[CTGeometryTool angleBetweenPoint1:point andPoint2:self.position] duration:0.01f];
                               
        [self runAction:[SKAction group:@[secMove, secRotate]] completion:^{
            if (node == nil)
            {
                if (completion) {
                    completion();
                }
                return;
            }
            SKAction *thiMove = [SKAction moveTo:node.position duration:duration/4.0];
            SKAction *thiRotate = [SKAction rotateToAngle:[CTGeometryTool angleBetweenPoint1:node.position andPoint2:self.position] duration:0.01f];
            [self runAction:[SKAction group:@[thiMove, thiRotate]] completion:^{
                if (completion) {
                    completion();
                }
            }];
        }];
    }];
    
}

@end
