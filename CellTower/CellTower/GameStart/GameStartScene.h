//
//  GameStartScene.h
//  test
//
//  Created by 刘奥明 on 15-3-31.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void(^AssetsLoadCompletionHandler)();

@interface GameStartScene : SKScene

/**
 *  加载场景资源
 *
 *  @param callback 回调
 */
+ (void)loadScaneAssetsWithCompletionHandeler:(AssetsLoadCompletionHandler)callback;

@end
