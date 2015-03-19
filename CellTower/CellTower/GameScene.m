//
//  GameScene.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "GameScene.h"
#import "Creature.h"
#import "SlowDownTower.h"
#import "CTGeometryTool.h"

@interface GameScene () <TowerDelegate>
{
    Creature *_creature;
    Tower *_tower;
}

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];

    [self test];
}

- (void)test
{
    // 1.创建怪物
    CreatureModel *model = [CreatureModel creatureModelWithType:CreatureTypeBoss];
    Creature *creature = [Creature creatureWithModel:model position:CGPointMake(100, 100)];
    [self addChild:creature];
    _creature = creature;
    
    // 2.创建塔
    TowerModel *towerModel = [TowerModel towerModelWithType:TowerTypeSlowDown];
    SlowDownTower *tower =[SlowDownTower towerWithModel:towerModel position:CGPointMake(50, 50)];
    [self addChild:tower];
    tower.delegate = self;
    _tower = tower;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSValue *p1 = [NSValue valueWithCGPoint:CGPointMake(100, 150)];
    NSValue *p2 = [NSValue valueWithCGPoint:CGPointMake(150, 150)];
    NSValue *p3 = [NSValue valueWithCGPoint:CGPointMake(150, 200)];
    
    
    [_creature moveWithPath:@[p1, p2, p3]];
    
    CreatureModel *creatureModel = [CreatureModel creatureModelWithType:CreatureTypeBomb];
    Creature *bullet = [Creature creatureWithModel:creatureModel];
    bullet.size = CGSizeMake(8, 8);
    [self addChild:bullet];
    
    [_tower fireWithCreature:_creature bullet:bullet];
    CTLog(@"%@", [_tower class]);

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - 代理方法
- (void)tower:(Tower *)tower didDefeatCreature:(Creature *)creature
{
    [creature removeFromParent];
    _creature = nil;
}

@end
