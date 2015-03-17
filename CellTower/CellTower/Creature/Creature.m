//
//  Creature.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "Creature.h"
#import "CreatureModel.h"

@interface Creature ()

@property (nonatomic , assign, readwrite) CreatureType type;

@end

@implementation Creature

+ (instancetype)creatureWithModel:(CreatureModel *)model
{
    // 1.实例化怪物
    Creature *creature = [self spriteNodeWithImageNamed:model.imageName];
    
    // 2.设置数据
    creature.size = CGSizeMake(15, 15);
    
    creature.imageName = [model.imageName copy];
    creature.HP = model.HP;
    creature.speed = model.speed;
    creature.coin = model.coin;
    creature.type = model.type;
    creature.hidden = model.hidden;
    creature.slowDown = model.slowDown;
    
    return creature;
}

+ (instancetype)creatureWithModel:(CreatureModel *)model position:(CGPoint)position
{
    Creature *creature = [self creatureWithModel:model];
    
    creature.position = position;
    
    return creature;
}

@end
