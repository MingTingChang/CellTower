//
//  GameScene.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "GameScene.h"
#import "Creature.h"
#import "CTGeometryTool.h"
#import "SniperTower.h"
#import "RocketTower.h"
#import "AirTower.h"
#import "ShockTower.h"
#import "CannonTower.h"
#import "RadarTower.h"
#import "Common.h"

@interface GameScene () <TowerDelegate, SKPhysicsContactDelegate>
{
    NSMutableArray *_creatures;
    NSMutableArray *_towers;
}

@end

@implementation GameScene

#pragma mark 加载到view时调用
-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor lightGrayColor];
    
    _creatures = [NSMutableArray array];
    _towers = [NSMutableArray array];

    [self setupPhysical];
    [self setupAllTower];
    [self setupAllCreature];
    [self test];
}

- (void)test
{
    NSValue *p1 = [NSValue valueWithCGPoint:CGPointMake(200, 300)];
    NSValue *p2 = [NSValue valueWithCGPoint:CGPointMake(200, 100)];
    NSValue *p3 = [NSValue valueWithCGPoint:CGPointMake(200, 160)];
    NSValue *p4 = [NSValue valueWithCGPoint:CGPointMake(400, 160)];
    
    for (Creature *creature in _creatures) {
        [creature moveWithPath:@[p4, p3, p2, p1]];
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
    if (creature == nil) return;

    [_creatures removeObject:creature];
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
    if (creature.creatureHidden == YES) {
        creature.physicsBody.contactTestBitMask = radarTowerCategory;
    } else {
        creature.physicsBody.contactTestBitMask = towerCategory;
    }
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
    if (tower.type == TowerTypeRadar) {
        tower.physicsBody.categoryBitMask = radarTowerCategory;
    } else {
        tower.physicsBody.categoryBitMask = towerCategory;
    }
    // 4) 设置碰撞检测类别掩码
//    tower.physicsBody.contactTestBitMask = creatureCategory;
    // 5) 设置回弹掩码
    tower.physicsBody.collisionBitMask = 0;
    // 6) 设置精确检测，用在仿真运行速度较高的物体上，防止出现“遂穿”的情况
    tower.physicsBody.usesPreciseCollisionDetection = YES;
}


#pragma mark - 私有方法
#pragma mark 创建所有怪物
- (void)setupAllCreature
{
    for (int i = 0; i < 30; i++) {
        int type = arc4random_uniform(8);
        int x = 500 + arc4random_uniform(50);
        int y = arc4random_uniform(320);
        
        [self setupCreature:type position:CGPointMake(x, y)];
    }

//    [self setupCreature:1 position:CGPointMake(400, 160)];
    
}

#pragma mark 创建所有塔
- (void)setupAllTower
{
    TowerModel *airTowerModel = [TowerModel towerModelWithType:TowerTypeAir];
    AirTower *airTower = [AirTower towerWithModel:airTowerModel position:CGPointMake(160, 160)];
    [self setupTower:airTower];
    
    TowerModel *airTowerModel2 = [TowerModel towerModelWithType:TowerTypeRocker];
    RocketTower *airTower2 = [RocketTower towerWithModel:airTowerModel2 position:CGPointMake(160, 100)];
    [self setupTower:airTower2];
    
    TowerModel *cannonTowerModel = [TowerModel towerModelWithType:TowerTypeShock];
    ShockTower *cannonTower = [ShockTower towerWithModel:cannonTowerModel position:CGPointMake(160, 200)];
    [self setupTower:cannonTower];
    
    TowerModel *radarTowerModel = [TowerModel towerModelWithType:TowerTypeRadar];
    RadarTower *radarTower = [RadarTower towerWithModel:radarTowerModel position:CGPointMake(140, 160)];
    [self setupTower:radarTower];

}

#pragma mark 创建怪物
- (void)setupCreature:(CreatureType)type position:(CGPoint)position
{
    // 1.创建怪物
    CreatureModel *model1 = [CreatureModel creatureModelWithType:type];
    model1.creatureHidden = YES;
    Creature *creature1 = [Creature creatureWithModel:model1 position:position];
    [self addChild:creature1];
    creature1.HP = 5;
    [_creatures addObject:creature1];
    
    // 2.设置物理刚体属性
    [self setupCreaturePhysicsBody:creature1];
    
}

#pragma mark 创建塔
- (void)setupTower:(Tower *)tower
{
    [self addChild:tower];
    tower.delegate = self;
    [_towers addObject:tower];
    [self setupTowerPhysicsBody:tower];
}

@end
