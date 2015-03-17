//
//  TowerModel.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "TowerModel.h"

@implementation TowerModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)towerModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (instancetype)towerModelWithType:(TowerType)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tower.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSDictionary *dict = array[type];
    
    return [self towerModelWithDict:dict];
}

@end
