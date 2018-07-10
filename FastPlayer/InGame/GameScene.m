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
#import <AVFoundation/AVFoundation.h>

@implementation GameScene {
    Player *_player;
    GroundNode *_groundNode;
    GroundNet *_groundNet;
    Score *_score;
    Config *_config;
    TimeNode *_timeNode;
    ItemButton *_coinItemButton;
    ItemButton *_scoreItemButton;
    MenuNode *_menuNode;
    
    //记录当前分数
    NSInteger _curScore;    
    
    
    //音效
    AVAudioPlayer *_audioPlayer;
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
    

    //播放背景音乐
    NSURL *musicUrl = [[NSBundle mainBundle] URLForResource:@"music/music00.mp3" withExtension:NULL];
    NSError *error = NULL;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
    _audioPlayer.numberOfLoops = -1;
    if (error == NULL) {        
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
    }
}

-(void)createContents{
    __weak __typeof (self) weakSelf = self;
    
    _groundNode = [GroundNode node];
    [self addChild:_groundNode];
    
    _menuNode = [MenuNode node];
    [self addChild:_menuNode];
    
    [_menuNode setTextField:self];
    
    Controller *controller = [Controller node];
    //__weak Player *weakPlayer = _player;
    controller.completeBlock = ^(BOOL isLeft) {         //操作移动  
        
        
        //判断是否已开启游戏
        if (!self.isStart) {
            //控制菜单
            [self->_menuNode selectPlayerByDirection:isLeft];
            return;
        }
        
        
        //播放音效
        SKAction *sound = [SKAction playSoundFileNamed:@"sound/DM-CGS-07" waitForCompletion:NO];
        [self runAction:sound];
        
        if (self.isOver) {
            return;
        }
        
        //判断是否可以移动
        if (![self->_groundNet canPlayerMoveBySteps:isLeft ? -1 : 1] || !(self->_player.canMove)) {
            return;
        }
        
        NSInteger stepsWillTake = 1;
        
        //添加时间（每走一步增加时间）
        [self->_timeNode addTime:0.5];
        
        //添加分数
        self->_curScore += stepsWillTake;
        [self->_scoreItemButton setNumber:self->_curScore];
        
        
        //移动背景
        [self->_groundNode takeStep:stepsWillTake];
                
        //移动角色
        NSInteger columnOffset = isLeft ? -1 : 1;
        [self->_player moveToColumnOffset:columnOffset withCompletion:^(NSInteger newColumnIndex, NSInteger newRowIndex) {
            //检查碰撞
            [weakSelf checkCollisionWithColumnIndex:newColumnIndex withRowIndex:newRowIndex];
        }];
    };
    [self addChild:controller];
    
    //添加玩家
    PlayerType playerType = [_score getPlayerType];
    _player = [Player nodeWithType:playerType];
    [self addChild:_player];    
    
    //添加定时器
    _timeNode = [TimeNode node];
    _timeNode.completeBlock = ^(BOOL stop, NSTimeInterval curTime) {
        if (stop) {
            //结束
            
            //存储分数
            [self->_score setScore:self->_curScore];            
            
            //打开菜单
            BOOL isMenuHidden = [_menuNode autoShow];            
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
            BOOL isMenuHidden = [self->_menuNode autoShow];
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


///检查碰撞
-(void)checkCollisionWithColumnIndex:(NSInteger)columnIndex withRowIndex:(NSInteger)rowIndex{
    __weak __typeof (self)weakSelf = self;
    
    Ground *ground = [self->_groundNode getGroundByColumnIndex:columnIndex byRowIndex:rowIndex];
    [ground triggerObjectByPlayerType:self->_player.type withCompletion:^(TriggerType triggerType) {
        switch (triggerType) {
            case TriggerTypeTimer:              //获取时间   
            {
                //播放音效
                SKAction *sound = [SKAction playSoundFileNamed:@"sound/DM-CGS-26" waitForCompletion:NO];
                [weakSelf runAction:sound];
                
                [self->_timeNode addTime:1];
            }
                break;
            case TriggerTypeDoubleTimer:        //获取双倍时间
            {
                //播放音效
                SKAction *sound = [SKAction playSoundFileNamed:@"sound/DM-CGS-26" waitForCompletion:NO];
                [weakSelf runAction:sound];
                
                [self->_timeNode addTime:2];
            }
                break;
            case TriggerTypeTwins:              //分身(修改为跳跃)
                [self->_player addJumpCount:1];
                break;
            case TriggerTypeGolder:             //获取金币
            {
                //播放音效
                SKAction *sound = [SKAction playSoundFileNamed:@"sound/DM-CGS-27" waitForCompletion:NO];
                [weakSelf runAction:sound];
                
                NSInteger coin = [self->_score addCoins:1];
                [self->_coinItemButton setNumber:coin];
            }
                break;
            case TriggerTypeDoubleGolder:       //获取双倍金币
            {
                //播放音效
                SKAction *sound = [SKAction playSoundFileNamed:@"sound/DM-CGS-27" waitForCompletion:NO];
                [weakSelf runAction:sound];
                
                NSInteger coin = [self->_score addCoins:2];
                [self->_coinItemButton setNumber:coin];
            }
                break;
            case TriggerTypeMainDead:           //主体死亡
            {
                //播放音效
                SKAction *sound = [SKAction playSoundFileNamed:@"sound/DM-CGS-18" waitForCompletion:NO];
                [weakSelf runAction:sound];
                
                [weakSelf shakeByCount:5 withCompletion:^{
                    //结束                                                        
                    
                    //打开菜单
                    BOOL isMenuHidden = [self->_menuNode autoShow];            
                    //[weakSelf startGame:isMenuHidden];
                }];
            }
                break;
            case TriggerTypeTwinsDead:          //分身死亡
                [weakSelf shakeByCount:3 withCompletion:NULL];
                break;
            default:                            //无
                break;
        }
    }];
}

///场景抖动
-(void)shakeByCount:(NSInteger)count withCompletion: (void (^)()) completion{
    //存储分数
    [_score setScore:_curScore];            
    _isOver = YES;
    _isStart = NO;
    
    NSMutableArray<SKAction*> *actions = [NSMutableArray array];
            
    for (NSInteger i=0; i<count; i++) {        
        NSTimeInterval duration = 0.03 + 0.02 * (CGFloat)i;
        SKAction *scaleOut = [SKAction scaleTo:1.08 duration:duration];
        scaleOut.timingMode = SKActionTimingEaseInEaseOut;        
        SKAction *scaleIn = [SKAction scaleTo:1 duration:duration];
        scaleIn.timingMode = SKActionTimingEaseInEaseOut;
        [actions addObjectsFromArray:@[scaleOut, scaleIn]];
    }
    
    SKAction *wait = [SKAction waitForDuration:1];
    [actions addObject:wait];
    
    SKAction *seq = [SKAction sequence:actions];
    [_groundNode runAction:seq completion:^{
        if (completion) {
            completion();
        }
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
        //更新角色选择
        PlayerType playerType = [_score getPlayerType];
        [_player changeType:playerType];
        
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
