//
//  SKNode+Expention.h
//  CellTower
//
//  Created by 刘奥明 on 15-3-22.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void(^Completion)();

@interface SKNode (Expention)

/**
 *  追踪某个节点
 *
 *  @param node       要追踪的节点
 *  @param duration   持续时间
 *  @param completion 完成回调
 */
- (void)trackToNode:(SKNode *)node duration:(NSTimeInterval)duration completion:(Completion)completion;

@end
