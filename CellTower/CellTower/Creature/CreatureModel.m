//
//  CreatureModel.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "CreatureModel.h"

@implementation CreatureModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)creatureWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
