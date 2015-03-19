//
//  SlowDownTower.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-19.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "SlowDownTower.h"
#import "Creature.h"

@implementation SlowDownTower

- (void)fireWithCreature:(Creature *)creature bullet:(SKSpriteNode *)bullet
{
    [creature beSlowDown:self];
    [super fireWithCreature:creature bullet:bullet];
}

@end
