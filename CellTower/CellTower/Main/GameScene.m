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
#import "ShockTower.h"
#import "RadarTower.h"

#pragma mark 设置碰撞掩码
// 怪物类别
static uint32_t creatureCategory = 1 << 0;
// 塔类别
static uint32_t towerCategory = 1 << 1;


@interface GameScene () <TowerDelegate, SKPhysicsContactDelegate>
{
    NSMutableArray *_creatures;
    Tower *_tower;
}

@end

@implementation GameScene

#pragma mark 加载到view时调用
-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];
    
    _creatures = [NSMutableArray array];

    [self setupPhysical];
    [self setupTower];
    [self setupCreature];
    [self test];
}

- (void)test
{
    NSValue *p1 = [NSValue valueWithCGPoint:CGPointMake(200, 300)];
    NSValue *p2 = [NSValue valueWithCGPoint:CGPointMake(200, 100)];
    NSValue *p3 = [NSValue valueWithCGPoint:CGPointMake(200, 160)];
    NSValue *p4 = [NSValue valueWithCGPoint:CGPointMake(400, 160)];
    
    for (Creature *creature in _creatures) {
        [creature moveWithPath:@[p1, p2, p3, p4]];
    }
}

#pragma mark 开始点击屏幕
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (Creature *creature in _creatures) {
        CTLog(@"%@----%d----%d", creature.imageName, creature.HP, creature.moveSpeed);
    }
}

#pragma mark - Tower代理方法
- (void)tower:(Tower *)tower didDefeatCreature:(Creature *)creature
{
    [creature removeFromParent];
    [_creatures removeObject:creature];
}

#pragma mark - 碰撞检测代理方法
#pragma mark 碰撞开始
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1.取出碰撞的怪物和塔
    Tower *tower = nil;
    Creature *creature = nil;
    if (contact.bodyA.categoryBitMask == towerCategory ||
        contact.bodyB.categoryBitMask == creatureCategory) {
        tower = (Tower *)contact.bodyA.node;
        creature = (Creature *)contact.bodyB.node;
    } else if ( contact.bodyA.categoryBitMask == creatureCategory||
               contact.bodyB.categoryBitMask == towerCategory ){
        tower = (Tower *)contact.bodyB.node;
        creature = (Creature *)contact.bodyA.node;
    } else {
        return;
    }
    
    // 2.通知塔怪物进入范围
    [tower creatureIntoAttackRange:creature];
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    // 1.取出碰撞的怪物和塔
    Tower *tower = nil;
    Creature *creature = nil;
    if (contact.bodyA.categoryBitMask == towerCategory) {
        tower = (Tower *)contact.bodyA.node;
        creature = (Creature *)contact.bodyB.node;
    } else {
        tower = (Tower *)contact.bodyB.node;
        creature = (Creature *)contact.bodyA.node;
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

#pragma mark 设置怪物的物理刚体属性
- (void)setupCreaturePhysicsBody:(Creature *)creature
{
    // 1.2 设置怪物的物理刚体属性
    // 1) 使用怪物的尺寸创建一个圆形刚体
    creature.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:creature.size.width / 2.0];
    // 2) 标示物体的移动是否由仿真引擎负责
    creature.physicsBody.dynamic = YES;
    // 3) 设置类别掩码
    creature.physicsBody.categoryBitMask = creatureCategory;
    // 4) 设置碰撞检测类别掩码
    creature.physicsBody.contactTestBitMask = towerCategory;
    // 5) 设置回弹掩码
    creature.physicsBody.collisionBitMask = 0;
    // 6) 设置精确检测，用在仿真运行速度较高的物体上，防止出现“遂穿”的情况
    creature.physicsBody.usesPreciseCollisionDetection = YES;
}

#pragma mark 设置塔的物理刚体属性
- (void)setupTowerPhysicsBody:(Tower *)tower
{
    // 1.2 设置塔的物理刚体属性
    // 1) 使用塔的范围创建一个圆形刚体
    tower.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:tower.range];
    // 2) 标示物体的移动是否由仿真引擎负责
    tower.physicsBody.dynamic = YES;
    // 3) 设置类别掩码
    tower.physicsBody.categoryBitMask = towerCategory;
    // 4) 设置碰撞检测类别掩码
    tower.physicsBody.contactTestBitMask = creatureCategory;
    // 5) 设置回弹掩码
    tower.physicsBody.collisionBitMask = 0;
    // 6) 设置精确检测，用在仿真运行速度较高的物体上，防止出现“遂穿”的情况
    tower.physicsBody.usesPreciseCollisionDetection = YES;
}


#pragma mark - 私有方法
#pragma mark 创建怪物
- (void)setupCreature
{
    // 1.创建怪物
    CreatureModel *model1 = [CreatureModel creatureModelWithType:CreatureTypeBoss];
    model1.creatureHidden = YES;
    Creature *creature1 = [Creature creatureWithModel:model1 position:CGPointMake(200, 160)];
    [self addChild:creature1];
    [_creatures addObject:creature1];
    
    // 2.设置物理刚体属性
    [self setupCreaturePhysicsBody:creature1];
    
    // 1.创建怪物
    CreatureModel *model2 = [CreatureModel creatureModelWithType:CreatureTypeFly];
    model2.creatureHidden = YES;
    Creature *creature2 = [Creature creatureWithModel:model2 position:CGPointMake(300, 160)];
    [self addChild:creature2];
    [_creatures addObject:creature2];;
    
    // 2.设置物理刚体属性
    [self setupCreaturePhysicsBody:creature2];
    
}

#pragma mark 创建塔
- (void)setupTower
{
    // 1.创建塔
    TowerModel *towerModel = [TowerModel towerModelWithType:TowerTypeRadar];
    RadarTower *tower =[RadarTower towerWithModel:towerModel position:CGPointMake(160, 160)];
    [self addChild:tower];
    tower.delegate = self;
    _tower = tower;
    
    [self setupTowerPhysicsBody:_tower];
}

@end
