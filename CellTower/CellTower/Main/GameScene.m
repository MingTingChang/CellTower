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

@interface GameScene () <SKPhysicsContactDelegate,GameMapDelegate>

@property (nonatomic , strong) GameMap *gameMap;

@property (nonatomic , strong) SKLabelNode *label;

@property (nonatomic , strong) NSTimer *timer;

@end

@implementation GameScene

#pragma mark 加载到view时调用
-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor lightGrayColor];
    
    _gameMap = [GameMap mapWithType:MapTypeTwoInTwoOut];
    _gameMap.anchorPoint = CGPointMake(0, 0);
    _gameMap.position = CGPointMake(124, 0);
    _gameMap.delegate = self;
    [self addChild:_gameMap];
    
    _label = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%ld %d",_gameMap.gold,_gameMap.playerHP]];
    _label.position = CGPointMake(20, self.size.height * 0.5);
    _label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _label.fontSize = 20;
    _label.fontColor = [UIColor redColor];
    _label.zPosition = 10;
    [self addChild:_label];

    [self setupPhysical];
    
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(test2) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.gameMap.willBulid = !self.gameMap.willBulid;
}

- (void)test2
{
    static int i = 5;
    i--;
    if (i == 0) {
        self.gameMap.curWaveNum ++;
        for (int i = 0; i < 50; i++) {
            [self.gameMap addCreatureWithType:arc4random_uniform(8) outlet:arc4random_uniform(2)];
        }
        i = 5;
    }
}

#pragma mark - GameMap代理方法
- (void)gameMapDidGameOver
{
    self.label.text = [NSString stringWithFormat:@"Game Over"];
    [_timer invalidate];
    _timer = nil;
}

- (void)update:(NSTimeInterval)currentTime
{
    if (_gameMap.playerHP > 0) {
        _label.text = [NSString stringWithFormat:@"%ld %d",_gameMap.gold,_gameMap.playerHP];
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
