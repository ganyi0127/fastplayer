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

@implementation GameScene {
    Player *_player;
    GroundNode *_groundNode;
    GroundNet *_groundNet;
    Score *_score;
    Config *_config;
    TimeNode *_timeNode;
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
    _groundNode = [GroundNode node];
    [self addChild:_groundNode];
    
    MenuNode *menuNode = [MenuNode node];
    [self addChild:menuNode];
    
    Controller *controller = [Controller node];
    //__weak Player *weakPlayer = _player;
    controller.completeBlock = ^(BOOL isLeft) {         //操作移动  
        //判断是否已开启游戏
        if (!_isStart) {
            //控制菜单
            return;
        }
        
        
        //判断是否可以移动
        if (![self->_groundNet canPlayerMoveBySteps:isLeft ? -1 : 1]) {
            return;
        }
        
        NSInteger stepsWillTake = 1;
        [self->_groundNode takeStep:stepsWillTake];
                
        NSInteger columnOffset = isLeft ? -1 : 1;
        [self->_player moveToColumnOffset:columnOffset withCompletion:^(NSInteger newColumnIndex, NSInteger newRowIndex) {
            //检查碰撞
            Ground *ground = [self->_groundNode getGroundByColumnIndex:newColumnIndex byRowIndex:newRowIndex];
            [ground triggerObjectByPlayerType:self->_player.type withCompletion:^(TriggerType triggerType) {
                switch (triggerType) {
                    case TriggerTypeTimer:              //获取时间                        
                        break;
                    case TriggerTypeDoubleTimer:        //获取双倍时间
                        break;
                    case TriggerTypeTwins:              //分身
                        break;
                    case TriggerTypeGolder:             //获取金币
                        break;
                    case TriggerTypeDoubleGolder:       //获取双倍金币
                        break;
                    case TriggerTypeMainDead:           //主体死亡
                        break;
                    case TriggerTypeTwinsDead:          //分身死亡
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
        }
    };
    [self addChild:_timeNode];    
    
    __weak __typeof (self) weakSelf = self;
    
    //添加菜单按钮
    SonamButton *menuButton = [SonamButton button:@[[SKTexture textureWithImageNamed:@""]]];
    menuButton.position = CGPointMake(_config.screenLeft + 50, _config.screenTop - 120);
    menuButton.completeBlock = ^(Boolean enable) {
        if (enable) {
            BOOL isMenuHidden = [menuNode autoShow];
            [weakSelf startGame:isMenuHidden];
        }
    };
    [self addChild:menuButton];
}

//重置
-(void)restartGame{
    _isOver = NO;
    _isStart = YES;
    [_timeNode reset];    
}

//
-(void)startGame:(BOOL)isRun{    
    if (_isOver) {
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


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
