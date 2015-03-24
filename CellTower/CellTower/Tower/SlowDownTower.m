//
//  SlowDownTower.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-19.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "SlowDownTower.h"
#import "CTGeometryTool.h"
#import "Creature.h"

@implementation SlowDownTower

#pragma mark 重写射击方法
- (void)shootWithCreature:(Creature *)creature completion:(shootCompletionBlock)completion
{
    // 1.攻击
    [super shootWithCreature:creature completion:^(Creature *creature){
        // 2.减速
        [creature beSlowDown:self];
        completion(creature);
    } ];
}

@end
