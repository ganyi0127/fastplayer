//
//  GameScene.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "GameScene.h"
#import "Config.h"
#import "Controller.h"
#import "MenuNode.h"
#import "GroundNode.h"
#import "Ground.h"
#import "GroundNet.h"
#import "Player.h"
#import "SonamButton.h"
#import "Score.h"
#import "TimeNode.h"
#import "ItemButton.h"

@implementation GameScene {
    Player *_player;
    GroundNode *_groundNode;
    GroundNet *_groundNet;
    Score *_score;
    Config *_config;
    TimeNode *_timeNode;
    ItemButton *_coinItemButton;
    ItemButton *_scoreItemButton;
    
    //记录当前分数
    NSInteger _curScore;    
    
}

- (void)didMoveToView:(SKView *)view {
    [self config];
    [self createContents];
}

-(void)config{
    _config = [Config shareInstance];
    _groundNet = [GroundNet shareInstance];
    _score = [Score shareInstance];
    
    _isStart = NO;
    _isOver = NO;
}

-(void)createContents{
    __weak __typeof (self) weakSelf = self;
    
    _groundNode = [GroundNode node];
    [self addChild:_groundNode];
    
    MenuNode *menuNode = [MenuNode node];
    [self addChild:menuNode];
    
    Controller *controller = [Controller node];
    //__weak Player *weakPlayer = _player;
    controller.completeBlock = ^(BOOL isLeft) {         //操作移动  
        //判断是否已开启游戏
        if (!self.isStart) {
            //控制菜单
            [menuNode selectPlayerByDirection:isLeft];
            return;
        }
        
        
        //判断是否可以移动
        if (![self->_groundNet canPlayerMoveBySteps:isLeft ? -1 : 1] || !(self->_player.canMove)) {
            return;
        }
        
        NSInteger stepsWillTake = 1;
        
        //添加时间（每走一步增加时间）
        [self->_timeNode addTime:1];
        
        //添加分数
        self->_curScore += stepsWillTake;
        [self->_scoreItemButton setNumber:self->_curScore];
        
        
        //移动背景
        [self->_groundNode takeStep:stepsWillTake];
                
        //移动角色
        NSInteger columnOffset = isLeft ? -1 : 1;
        [self->_player moveToColumnOffset:columnOffset withCompletion:^(NSInteger newColumnIndex, NSInteger newRowIndex) {
            //检查碰撞
            Ground *ground = [self->_groundNode getGroundByColumnIndex:newColumnIndex byRowIndex:newRowIndex];
            [ground triggerObjectByPlayerType:self->_player.type withCompletion:^(TriggerType triggerType) {
                switch (triggerType) {
                    case TriggerTypeTimer:              //获取时间   
                        [self->_timeNode addTime:2];
                        break;
                    case TriggerTypeDoubleTimer:        //获取双倍时间
                        [self->_timeNode addTime:4];
                        break;
                    case TriggerTypeTwins:              //分身
                        break;
                    case TriggerTypeGolder:             //获取金币
                    {
                        NSInteger coin = [_score addCoins:1];
                        [self->_coinItemButton setNumber:coin];
                    }
                        break;
                    case TriggerTypeDoubleGolder:       //获取双倍金币
                    {
                        NSInteger coin = [_score addCoins:2];
                        [self->_coinItemButton setNumber:coin];
                    }
                        break;
                    case TriggerTypeMainDead:           //主体死亡
                        [weakSelf shakeByCount:6];
                        break;
                    case TriggerTypeTwinsDead:          //分身死亡
                        [weakSelf shakeByCount:3];
                        break;
                    default:                            //无
                        break;
                }
            }];
        }];
    };
    [self addChild:controller];
    
    //添加玩家
    PlayerType playerType = [_score getPlayerType];
    _player = [Player nodeWithType:playerType];
    [self addChild:_player];    
    
    //添加定时器
    _timeNode = [TimeNode node];
    _timeNode.completeBlock = ^(BOOL stop, NSInteger curTime) {
        if (stop) {
            //结束
            
            //存储分数
            [self->_score setScore:self->_curScore];            
            
            //打开菜单
            BOOL isMenuHidden = [menuNode autoShow];            
            [weakSelf startGame:isMenuHidden];
            self->_isOver = YES;                        
        }
    };
    [self addChild:_timeNode];    
    
    
    
    //添加菜单按钮
    SonamButton *menuButton = [SonamButton button:@[[SKTexture textureWithImageNamed:@"btn_menu"]]];
    menuButton.position = CGPointMake(_config.screenLeft + 120, _config.screenTop - 150);
    menuButton.completeBlock = ^(Boolean enable) {
        if (enable) {
            //存储分数
            [self->_score setScore:self->_curScore]; 
            
            //控制菜单
            BOOL isMenuHidden = [menuNode autoShow];
            [weakSelf startGame:isMenuHidden];
        }
    };
    [self addChild:menuButton];
    
    CGFloat itemButtonPosX = _config.screenRight - 200;
    
    //添加金币按钮
    _coinItemButton = [ItemButton nodeWithButtonType:ItemButtonTypeCoins];
    _coinItemButton.position = CGPointMake(itemButtonPosX, _config.screenTop - 120);
    NSInteger coins = [_score getCoins];
    [_coinItemButton setNumber:coins];
    [self addChild:_coinItemButton];
    
    //添加分数按钮
    _scoreItemButton = [ItemButton nodeWithButtonType:ItemButtonTypeScore];
    _scoreItemButton.position = CGPointMake(itemButtonPosX, _coinItemButton.position.y - 150);
    [_scoreItemButton setNumber:0];
    [self addChild:_scoreItemButton];
}

///场景抖动
-(void)shakeByCount:(NSInteger)count{
    NSMutableArray<SKAction*> *actions = [NSMutableArray array];
            
    for (NSInteger i=0; i<count; i++) {        
        NSTimeInterval duration = 0.05 + 0.03 * (CGFloat)i;
        SKAction *scaleOut = [SKAction scaleTo:1.1 duration:duration];
        scaleOut.timingMode = SKActionTimingEaseInEaseOut;        
        SKAction *scaleIn = [SKAction scaleTo:1 duration:duration];
        scaleIn.timingMode = SKActionTimingEaseInEaseOut;
        [actions addObjectsFromArray:@[scaleOut, scaleIn]];
    }
    
    SKAction *seq = [SKAction sequence:actions];
    [_groundNode runAction:seq completion:^{
        
    }];
}

//重置
-(void)restartGame{
    _isOver = NO;
    _isStart = YES;
    _curScore = 0;
    [_timeNode reset];    
}

//开始/暂停游戏
-(void)startGame:(BOOL)isRun{    
    if (_isOver) {
        [_groundNode reset];
        [self restartGame];
    }else{        
        _isStart = isRun;
        [_timeNode startCount:isRun];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {    
    for (UITouch *touch in touches) {
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
    }
}

#pragma mark 更新
-(void)update:(CFTimeInterval)currentTime {
    
}

@end
