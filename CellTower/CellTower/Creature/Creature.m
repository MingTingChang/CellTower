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
#pragma mark - 私有方法

#pragma mark - 共有方法
#pragma mark 根据模型实例化怪物
+ (instancetype)creatureWithModel:(CreatureModel *)model
{
    if (model == nil) return nil;
    
    // 1.实例化怪物
    Creature *creature = [self spriteNodeWithImageNamed:model.imageName];
    
    // 2.设置数据
    creature.size = CGSizeMake(15, 15);
    creature.position = CGPointMake(-100, -100);
    
    creature.imageName = [model.imageName copy];
    creature.HP = model.HP;
    creature.moveSpeed = model.moveSpeed;
    creature.coin = model.coin;
    creature.type = model.type;
    creature.hidden = model.hidden;
    creature.slowDown = model.slowDown;
    
    return creature;
}

#pragma mark 根据模型和点实例化怪物
+ (instancetype)creatureWithModel:(CreatureModel *)model position:(CGPoint)position
{
    Creature *creature = [self creatureWithModel:model];
    
    creature.position = position;
    
    return creature;
}

#pragma mark 根据路径移动
- (void)moveWithPath:(NSMutableArray *)movePath
{
    if (movePath == nil) return;
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:movePath.count];
    
    // 2.便利所有点
    for(int i = 0; i<movePath.count; i++) {
        
        // 2.1取出当前点
        CGPoint location = CGPointZero;
        if (i == 0) {
            location = self.position;
        } else {
            
            NSValue *locationValue = movePath[i-1];
            location = [locationValue CGPointValue];
        }
        
        // 2.2取出下下一个点
        NSValue *nestValue = movePath[i];
        CGPoint nest = [nestValue CGPointValue];
        
        // 计算时间
        CGPoint offset = CGPointMake(nest.x - location.x, nest.y - location.y);
        CGFloat distance = sqrtf(offset.x*offset.x + offset.y*offset.y);
        NSTimeInterval durarion = distance / self.moveSpeed;
 
        
        // 创建action
        SKAction *move = [SKAction moveTo:nest duration:durarion];
        [arrayM addObject:move];
    }
    
    // 3.创建行为队列
    SKAction *moveSequeue = [SKAction sequence:arrayM];
    
    [self runAction:moveSequeue];
}

@end
