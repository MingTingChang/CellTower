//
//  Creature.m
//  CellTower
//
//  Created by 刘奥明 on 15-3-17.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "Creature.h"
#import "CTGeometryTool.h"

@interface Creature ()

@property (nonatomic , assign, readwrite) CreatureType type;

@end

@implementation Creature
#pragma mark - 私有方法
#pragma mark 初始化
- (instancetype)initWithModel:(CreatureModel *)model
{
    if (model == nil) return nil;
    
    if (self = [super initWithImageNamed:model.imageName]) {
        self.size = CGSizeMake(15, 15);
        self.zPosition = 1;
        self.position = CGPointMake(-100, -100);
        
        self.imageName = [model.imageName copy];
        self.HP = model.HP;
        self.realHP = model.HP;
        self.moveSpeed = model.moveSpeed;
        self.coin = model.coin;
        self.type = model.type;
        self.creatureHidden = model.creatureHidden;
        self.alpha = self.creatureHidden ? 0.5 : 1.0;
        self.slowDown = model.slowDown;
        [self setupCreaturePhysicsBody:self];
    }
    
    return self;
}

#pragma mark 减速环
- (SKSpriteNode *)SlowDownCircle {
    if (!_SlowDownCircle) {
        _SlowDownCircle = [SKSpriteNode spriteNodeWithImageNamed:@"SlowDownCircle"];
        _SlowDownCircle.size = self.size;
        _SlowDownCircle.position = CGPointMake(0,0);
    }
    return _SlowDownCircle;
}

#pragma mark 是否隐形
- (void)setCreatureHidden:(BOOL)creatureHidden
{
    _creatureHidden = creatureHidden;
    self.alpha = self.creatureHidden ? 0.2 : 1.0;
}

#pragma mark - 公有方法
#pragma mark 根据模型实例化怪物
+ (instancetype)creatureWithModel:(CreatureModel *)model
{
    
    return [[self alloc] initWithModel:model];
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
    
    [self removeAllActions];
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:movePath.count];
    
    // 2.遍历所有点
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
 
        // 创建rotiaeAction
        SKAction *rotateAction = [SKAction rotateToAngle:[CTGeometryTool angleBetweenPoint1:nest andPoint2:location] duration:0.2f];
        
        // 创建moveAction
        SKAction *moveAction = [SKAction moveTo:nest duration:durarion];
        [arrayM addObject:[SKAction group:@[rotateAction, moveAction]]];
    }
    
    // 3.创建行为队列
    SKAction *moveSequeue = [SKAction sequence:arrayM];
    
    [self runAction:moveSequeue];
}

#pragma mark 被减速
- (void)beSlowDown:(Tower *)tower
{
    if (self.slowDown) return;
    
    self.slowDown = YES;
    
    // 1.减慢移动速度
    self.moveSpeed *= 0.3;
    // 1.1 通知代理状态改变
    if ([self.delegate respondsToSelector:@selector(creatureMoveStateDidChange:)]) {
        [self.delegate creatureMoveStateDidChange:self];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.moveSpeed *= 2;
        self.slowDown = NO;
        // 1.2 通知代理状态改变
        if ([self.delegate respondsToSelector:@selector(creatureMoveStateDidChange:)]) {
            [self.delegate creatureMoveStateDidChange:self];
        }
        [self.SlowDownCircle removeFromParent];
    });

    
    // 2.添加减速效果
    if (self.SlowDownCircle.scene == nil) {
        [self addChild:self.SlowDownCircle];
        SKAction *rotate = [SKAction rotateByAngle:M_PI duration:1.0f];
        [self.SlowDownCircle runAction:[SKAction repeatActionForever:rotate]];
    }
}

#pragma mark 设置怪物的物理刚体属性
- (void)setupCreaturePhysicsBody:(Creature *)creature
{
    // 1.2 设置怪物的物理刚体属性
    // 1) 使用怪物的尺寸创建一个圆形刚体
    creature.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:creature.size.width / 2.0];
    
    /**
     2)若打开dynamic,则节点可能由于碰撞而被引擎改变位置
     但是若碰撞的两者都关闭,则无法发生碰撞.
     */
    creature.physicsBody.dynamic = YES;
    // 3) 设置节点的类别掩码 , 设置之后可以被碰到
    creature.physicsBody.categoryBitMask = creatureCategory;
    // 4) 设置碰撞检测类别掩码 , 设置之后可以主动碰到那些类别的节点
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

@end
