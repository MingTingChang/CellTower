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

+ (instancetype)creatureModelWithDict:(NSDictionary *)dict
{
   return [[self alloc] initWithDict:dict];
}

+ (instancetype)creatureModelWithType:(CreatureType)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"creature.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSDictionary *dict = array[type];
    
    return [self creatureModelWithDict:dict];
}

@end
