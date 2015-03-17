//
//  MapStep.m
//  CellTower
//
//  Created by 刘挺 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "MapStep.h"

@implementation MapStep

- (instancetype)initWithPoint:(CGPoint)point curStep:(int)curStep dreamStep:(int)dreamStep
{
    if (self = [super init]) {
        self.point = point;
        self.currentStep = curStep;
        self.dreamStep = dreamStep;
    }
    return self;
}

+ (instancetype)stepWithPoint:(CGPoint)point curStep:(int)curStep dreamStep:(int)dreamStep
{
    return [[self alloc] initWithPoint:point curStep:curStep dreamStep:dreamStep];
}

- (int)stepSum
{
    return self.currentStep + self.dreamStep;
}


@end
