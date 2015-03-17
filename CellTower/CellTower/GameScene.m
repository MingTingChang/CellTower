//
//  GameScene.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "GameScene.h"
<<<<<<< Updated upstream
#import "Creature.h"
#import "Tower.h"

@interface GameScene ()
{
    Creature *_creature;
    Tower *_tower;
}

@end
=======
#import "Map.h"
>>>>>>> Stashed changes

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
<<<<<<< Updated upstream
    
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
=======
//    Map *map = [Map spriteWithTexture:[SKTexture textureWithImageNamed:@"tower_shock"]
//                            gridPixel:10
//                                 type:MapTypeOneEnterDoor];
//    [map findOutPathFrom:CGPointMake(12, 16) to:CGPointMake(35, 59)];
//    [self addChild:map];
>>>>>>> Stashed changes
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
