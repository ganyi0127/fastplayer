//
//  MenuNode.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "MenuNode.h"
#import "Config.h"
#import "ItemButton.h"
#import "SonamNumberLabel.h"
#import "SonamButton.h"
#import "Score.h"
#import "Player.h"
#import "PlayerSel.h"

@implementation MenuNode{
    Config *_config;    
    CGSize _menuSize;
    ItemButton *_highscoreItemButton;
    PlayerSel *_playerSel;
    SonamButton *_startButton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    _config = [Config shareInstance];
    
    _menuSize = _config.menuSize;
    
    _isShow = YES;
    
    self.zPosition = 20;
    self.position = CGPointMake(0, [self getShowPosY:_isShow]);
}

-(void)createContents{
    //添加背景
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@""]];
    [self addChild:bg];
    
    //添加highscore
    _highscoreItemButton = [ItemButton nodeWithButtonType:ItemButtonTypeHighscore];
    _highscoreItemButton.position = CGPointMake(0, 300);
    [self addChild:_highscoreItemButton];
    
    //添加角色选择
    _playerSel = [PlayerSel node];
    _playerSel.position = CGPointMake(0, 0);
    [self addChild:_playerSel];
    
    __weak typeof (self)weakSelf = self;
    
    //添加开始按钮
    _startButton = [SonamButton button:@[]];
    _startButton.position = CGPointMake(0, bg.size.height / 2);
    _startButton.completeBlock = ^(Boolean enable) {
        if (enable) {
            [weakSelf show:false];
        }
    };
    [self addChild:_startButton];
}

- (BOOL)autoShow{
    return [self show:!_isShow];
}

- (BOOL)show:(BOOL)isShow{
    _isShow = isShow;
    _startButton.isEnable = _isShow;
    
    [self runAction:[self getShowAction:_isShow]];
    return !_isShow;
}

- (void)selectPlayerByDirection:(BOOL)isLeftDirection{
    
}

#pragma mark 获取展示动画
-(SKAction*)getShowAction:(BOOL)isShowAction{
    NSTimeInterval duration = 0.5;
    CGFloat moveY = [self getShowPosY:isShowAction];
    SKAction *move = [SKAction moveToY:moveY duration:duration];    
    move.timingMode = SKActionTimingEaseOut;
    return move;
}

#pragma mark 获取展示y轴位置
-(CGFloat)getShowPosY:(BOOL)isShowPosY{
    return isShowPosY ? _config.screenTop - _menuSize.height / 2 : _config.screenTop + _menuSize.height / 2; 
}
@end
