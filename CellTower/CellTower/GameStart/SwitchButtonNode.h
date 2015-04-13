//
//  SwitchButtonNode.h
//  test
//
//  Created by 刘奥明 on 15-4-2.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "BaseButtonNode.h"

@interface SwitchButtonNode : BaseButtonNode

@property (nonatomic , assign, getter=isSelected) BOOL selected;

@property (nonatomic, copy) NSString *iconOffName;

- (void)touchButton;

@end
