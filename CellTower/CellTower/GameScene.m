//
//  GameScene.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "GameScene.h"
#import "Creature.h"
#import "Tower.h"

@interface GameScene ()
{
    Creature *_creature;
    Tower *_tower;
}

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {

    [self test];
    [self test];
}

- (void)test
{
    
    // 1.创建怪物
    Creature *creature = [Creature spriteNodeWithImageNamed:@"creature_bomb"];
    creature.HP = 100;
    creature.size = CGSizeMake(15, 15);
    creature.position = CGPointMake(100, 100);
    [self addChild:creature];
    _creature  = creature;
    
    TowerModel *model = [TowerModel towerModelWithType:TowerTypeAir];
    
    Tower *t1 = [Tower towerWithModel:model position:CGPointMake(150, 150)];
    [self addChild:t1];
    
    // 2.创建塔
    Tower *tower = [Tower spriteNodeWithImageNamed:@"tower_cannon"];
    tower.damage = 5;
    tower.size = CGSizeMake(30, 30);
    tower.position = CGPointMake(150, 100);
    [self addChild:tower];
    _tower = tower;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"creature_bomb"];
    bullet.size = CGSizeMake(10, 10);
    [self addChild:bullet];
    
    [_creature runAction:[SKAction moveToY:300 duration:3.0f]];
    
    [_tower fireWithCreature:_creature bullet:bullet];

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
