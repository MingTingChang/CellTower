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

@property (nonatomic , strong) SKLabelNode *label;

@end

@implementation GameScene

#pragma mark 加载到view时调用
-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor lightGrayColor];
    
    _gameMap = [GameMap mapWithType:MapTypeOneInOneOut];
    _gameMap.anchorPoint = CGPointMake(0, 0);
    _gameMap.position = CGPointMake(124, 0);
    [self addChild:_gameMap];
    
    _label = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%ld",_gameMap.gold]];
    _label.position = CGPointMake(20, self.size.height * 0.5);
    _label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _label.fontSize = 30;
    _label.fontColor = [UIColor redColor];
    _label.zPosition = 10;
    [self addChild:_label];

    [self setupPhysical];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(test2) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
}

- (void)test2
{
    static int i = 3;
    i--;
    if (i == 0) {
        self.gameMap.curWaveNum ++;
        for (int i = 0; i < 20; i++) {
            [self.gameMap addCreatureWithType:arc4random_uniform(8) outlet:arc4random_uniform(2)];
        }
        i = 3;
    }
}

- (void)update:(NSTimeInterval)currentTime
{
    _label.text = [NSString stringWithFormat:@"%ld",_gameMap.gold];
    
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
