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
#import "Common.h"
#import "GameMap.h"

@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic , strong) GameMap *gameMap;

@end

@implementation GameScene

#pragma mark 加载到view时调用
-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor lightGrayColor];
    
    _gameMap = [GameMap spriteNodeWithImageNamed:@"test.jpg" gridPixel:10 mapType:MapTypeOneInOneOut];
    _gameMap.anchorPoint = CGPointMake(0, 0);
    _gameMap.position = CGPointMake(124, 10);

    [self addChild:_gameMap];

    [self setupPhysical];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (int i = 0; i < 20; i++) {
        int y = arc4random_uniform(20) + self.gameMap.position.y + self.gameMap.size.height * 0.5 - 20;
        CGPoint pos = CGPointMake(0, y);
        [_gameMap addCreatureWithType:arc4random_uniform(8) point:pos];
    }
}


#pragma mark - 碰撞检测代理方法
#pragma mark 碰撞开始
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1.取出碰撞的怪物和塔
    Tower *tower = nil;
    Creature *creature = nil;
    
    if (contact.bodyA.categoryBitMask == creatureCategory &&
        contact.bodyB.categoryBitMask == towerCategory) { // 怪撞塔
        tower = (Tower *)contact.bodyB.node;
        creature = (Creature *)contact.bodyA.node;
        [tower creatureIntoAttackRange:creature];
    } else if (contact.bodyA.categoryBitMask == towerCategory &&
       contact.bodyB.categoryBitMask == creatureCategory) { // 塔撞怪
        tower = (Tower *)contact.bodyA.node;
        creature = (Creature *)contact.bodyB.node;
        [tower creatureIntoAttackRange:creature];
    } else if ( contact.bodyA.categoryBitMask == creatureCategory &&
               contact.bodyB.categoryBitMask == radarTowerCategory ){ // 怪撞雷达
        tower = (Tower *)contact.bodyB.node;
        creature = (Creature *)contact.bodyA.node;
        [tower creatureIntoAttackRange:creature];
    } else if ( contact.bodyA.categoryBitMask == radarTowerCategory &&
               contact.bodyB.categoryBitMask == creatureCategory ){ // 雷达撞怪
        tower = (Tower *)contact.bodyA.node;
        creature = (Creature *)contact.bodyB.node;
        [tower creatureIntoAttackRange:creature];
    }
}

#pragma mark 碰撞结束
- (void)didEndContact:(SKPhysicsContact *)contact
{
    // 1.取出碰撞的怪物和塔
    Tower *tower = nil;
    Creature *creature = nil;
    
    if (contact.bodyA.categoryBitMask == towerCategory &&
        contact.bodyB.categoryBitMask == creatureCategory) {
        tower = (Tower *)contact.bodyA.node;
        creature = (Creature *)contact.bodyB.node;
    } else if ( contact.bodyA.categoryBitMask == creatureCategory &&
               contact.bodyB.categoryBitMask == towerCategory ){
        tower = (Tower *)contact.bodyB.node;
        creature = (Creature *)contact.bodyA.node;
    } else if ( contact.bodyA.categoryBitMask == creatureCategory &&
               contact.bodyB.categoryBitMask == radarTowerCategory ){
        tower = (Tower *)contact.bodyB.node;
        creature = (Creature *)contact.bodyA.node;
    } else if ( contact.bodyA.categoryBitMask == radarTowerCategory &&
               contact.bodyB.categoryBitMask == creatureCategory ){
        tower = (Tower *)contact.bodyA.node;
        creature = (Creature *)contact.bodyB.node;
    } else {
        return;
    }
    // 2.通知塔怪物离开范围
    [tower creatureLeaveAttackRange:creature];
}

#pragma mark - 设置物理引擎方法
#pragma mark 初始化物理引擎
- (void)setupPhysical
{
    // 定义物理仿真世界的属性(重力)
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    self.physicsWorld.contactDelegate = self;
}

@end
