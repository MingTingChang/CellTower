//
//  MapStep.h
//  CellTower
//
//  Created by 刘挺 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapStep : NSObject

@property (nonatomic , assign) CGPoint point;

@property (nonatomic , assign) int stepSum;

@property (nonatomic , assign) int currentStep;

@property (nonatomic , assign) int dreamStep;

- (instancetype)initWithPoint:(CGPoint)point curStep:(int)curStep dreamStep:(int)dreamStep;
+ (instancetype)stepWithPoint:(CGPoint)point curStep:(int)curStep dreamStep:(int)dreamStep;

@end
