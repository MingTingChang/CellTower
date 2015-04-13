//
//  GameStartScene.m
//  test
//
//  Created by 刘奥明 on 15-3-31.
//  Copyright (c) 2015年 MingTingChang. All rights reserved.
//

#import "GameStartScene.h"
#import "JumpButtonNode.h"
#import "SwitchButtonNode.h"
#import "BlockButtonNode.h"
#import "GameScene.h"
#import "CTBgMusicPlayer.h"
#import "Common.h"


typedef void(^Completion)();

@interface GameStartScene ()

@property (nonatomic , strong) NSDictionary *buttonNodeLists;

@property (nonatomic , strong) NSMutableArray *buttonNodes;

@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameStartScene

- (NSDictionary *)buttonNodeLists {
    if (!_buttonNodeLists) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ButtonNode.plist" ofType:nil];
        _buttonNodeLists = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _buttonNodeLists;
}

- (NSMutableArray *)buttonNodes {
    if (!_buttonNodes) {
        _buttonNodes = [NSMutableArray array];
    }
    return _buttonNodes;
    
}


#pragma mark 移到场景中时
- (void)didMoveToView:(SKView *)view
{
    // 1.添加背景
    [self setupBgNode];
    // 2.添加标题
    [self setupTitleNode];
    // 3.添加按钮
    [self setAllButtonNode];
    // 4.初始化背景音乐
    [self setupBgMusic];
}

#pragma mark 初始化背景音乐
- (void)setupBgMusic
{
    BOOL audio = [[NSUserDefaults standardUserDefaults] boolForKey:kAudio];
    if (audio) {
        [[CTBgMusicPlayer sharedPlayer] playBgMusic];
    }
}

#pragma mark 加载场景资源并执行回调
+ (void)loadScaneAssetsWithCompletionHandeler:(AssetsLoadCompletionHandler)callback
{
    // 1.异步加载资源
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadScaneAssets];
        
        // 2.主线程执行回调
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback();
            });
        }
    });
}

#pragma mark - 私有方法
#pragma mark 加载场景资源
+ (void)loadScaneAssets
{
    
}

#pragma mark 添加背景
- (void)setupBgNode
{
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"e_main_bg"];
    bgNode.size = self.size;
    bgNode.position = CGPointMake(self.size.width/2.0, self.size.height/2.0);
    [self addChild:bgNode];
}

#pragma mark 添加标题Node
- (void)setupTitleNode
{
    SKSpriteNode *titleNode = [SKSpriteNode spriteNodeWithImageNamed:@"e_main_title"];
    titleNode.size = CGSizeMake(300, 100);
    titleNode.position = CGPointMake(self.size.width/2.0, 280);
    [self addChild:titleNode];
}

#pragma mark 开始点击屏幕
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    NSArray *nodes = [self nodesAtPoint:location];
    for (SKNode *node in nodes) {
        if ([node isKindOfClass:[BaseButtonNode class]]) {
            BaseButtonNode *buttonNode = (BaseButtonNode *)node;
            [self touchButtonNode:buttonNode];
            break;
        }
    }
}

#pragma mark 点击了节点按钮
- (void)touchButtonNode:(BaseButtonNode *)buttonNode
{
    if ([buttonNode isKindOfClass:[BlockButtonNode class]]) {
        BlockButtonNode *button = (BlockButtonNode *)buttonNode;
        [self touchBlockButtonNode:button];
    } else if ([buttonNode isKindOfClass:[SwitchButtonNode class]]) {
        SwitchButtonNode *button = (SwitchButtonNode *)buttonNode;
        [self touchSwitchButtonNode:button];
    } else if ([buttonNode isKindOfClass:[JumpButtonNode class]]) {
        JumpButtonNode *button = (JumpButtonNode *)buttonNode;
        [self touchJumpButtonNode:button];
    }
}

#pragma mark 点击了block按钮
- (void)touchBlockButtonNode:(BlockButtonNode *)buttonNode
{
    // 0.旋转
    [buttonNode rotateIconNode];
    
    // 1.移动
    [self moveAllButtonNodeCompletion:^{
        if (buttonNode.callback) {
            buttonNode.callback();
        }
    }];
}

#pragma mark 点击了开关按钮
- (void)touchSwitchButtonNode:(SwitchButtonNode *)buttonNode
{
    [buttonNode touchButton];
    
    if ([buttonNode.name isEqualToString:@"audio"]) {
        [self changeBgMusicState];
    }
}

#pragma mark 改变背景音乐状态
- (void)changeBgMusicState
{
    BOOL audio = [[NSUserDefaults standardUserDefaults] boolForKey:kAudio];
    
    if (audio) {
        [[CTBgMusicPlayer sharedPlayer] playBgMusic];
    } else {
        [[CTBgMusicPlayer sharedPlayer] stop];
    }
}

#pragma mark 点击了跳跃节点按钮
- (void)touchJumpButtonNode:(JumpButtonNode *)buttonNode
{
    // 0.旋转
    [buttonNode rotateIconNode];
    
    // 1.移动
    [self moveAllButtonNodeCompletion:^{
        self.buttonNodes = nil;
        NSArray *array = self.buttonNodeLists[buttonNode.name];
        if (array.count < 1 ) return;
        for (NSDictionary *dict in array) {
            [self addButtonNodesWithHidden:YES item:dict];
        }
        [self moveAllButtonNodeCompletion:nil];
    }];
}

#pragma mark 移动所有按钮节点
- (void)moveAllButtonNodeCompletion:(Completion)completion
{
    JumpButtonNode *button1 = self.buttonNodes[0];
    [self moveButtonNode:button1 completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JumpButtonNode *button2 = self.buttonNodes[1];
        [self moveButtonNode:button2 completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JumpButtonNode *button3 = self.buttonNodes[2];
            [self moveButtonNode:button3 completion:^{
                if (completion) {
                    completion();
                }
            }];
        });
    });
}

#pragma mark 移动节点按钮
- (void)moveButtonNode:(JumpButtonNode *)buttonNode completion:(Completion)completion
{
    SKAction *move = [SKAction moveByX:-(self.size.width/2.0 + buttonNode.size.width/2.0) y:0 duration:0.5f];;
    move.timingMode = SKActionTimingEaseOut;
    [buttonNode runAction:move completion:^{
        if (buttonNode.position.x < 0) {
            [buttonNode removeFromParent];
        }
        if (completion) {
            completion();
        }
    }];
}

#pragma mark 添加所有按钮节点
- (void)setAllButtonNode
{
    NSDictionary *array = self.buttonNodeLists[@"home"];
    for (NSDictionary *dict in array) {
        [self addButtonNodesWithHidden:NO item:dict];
    }
}

#pragma mark 添加按钮节点
- (void)addButtonNodesWithHidden:(BOOL)hidden item:(NSDictionary *)item
{
    switch ([item[@"type"] intValue]) {
        case 0:
            [self addJumpButtonNodesWithHidden:hidden name:item[@"name"]];
            break;
        case 1:
            [self addSwitchButtonNodesWithHidden:hidden name:item[@"name"]];
            break;
        case 2:
            [self addBlockButtonNodesWithHidden:hidden name:item[@"name"]];
            break;
            
        default:
            break;
    }
}

#pragma mark 添加跳跃按钮节点
- (void)addJumpButtonNodesWithHidden:(BOOL)hidden name:(NSString *)name
{
    JumpButtonNode *buttonNode = [JumpButtonNode buttonNodeWithName:name];
    CGFloat pointX = hidden ? self.size.width + buttonNode.size.width/2.0 : self.size.width/2.0;
    buttonNode.position = CGPointMake(pointX, 200 - 80*self.buttonNodes.count);
    [self addChild:buttonNode];
    [self.buttonNodes addObject:buttonNode];
}

#pragma mark 添加开关按钮节点
- (void)addSwitchButtonNodesWithHidden:(BOOL)hidden name:(NSString *)name
{
    SwitchButtonNode *buttonNode = [SwitchButtonNode buttonNodeWithName:name];
    CGFloat pointX = hidden ? self.size.width + buttonNode.size.width/2.0 : self.size.width/2.0;
    buttonNode.position = CGPointMake(pointX, 200 - 80*self.buttonNodes.count);
    [self addChild:buttonNode];
    [self.buttonNodes addObject:buttonNode];
}

#pragma mark 添加block按钮节点
- (void)addBlockButtonNodesWithHidden:(BOOL)hidden name:(NSString *)name
{
    BlockButtonNode *buttonNode = [BlockButtonNode buttonNodeWithName:name];
    CGFloat pointX = hidden ? self.size.width + buttonNode.size.width/2.0 : self.size.width/2.0;
    buttonNode.position = CGPointMake(pointX, 200 - 80*self.buttonNodes.count);
    [self addChild:buttonNode];
    [self.buttonNodes addObject:buttonNode];
    
    buttonNode.callback = ^{
        GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
        scene.size = self.size;
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene];
    };
}

@end
