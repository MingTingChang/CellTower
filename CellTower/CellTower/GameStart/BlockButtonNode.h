//
//  BlockButtonNode.h
//  test
//
//  Created by 刘奥明 on 15-4-2.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "JumpButtonNode.h"

typedef void(^CompletionBlock)();

@interface BlockButtonNode : JumpButtonNode

@property (nonatomic, copy) CompletionBlock callback;

@end
