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
#import "GameScene.h"

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
    SKTexture *bgTexture = [SKTexture textureWithImageNamed:@"bg_menu"];
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:bgTexture size:CGSizeMake(_menuSize.width, _menuSize.height)];
    CGFloat scale = (_menuSize.width - 128)/bgTexture.size.width;
    [bg setScale:scale];
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
    SKTexture *startTexture = [SKTexture textureWithImageNamed:@"btn_start"];
    _startButton = [SonamButton button:@[startTexture]];
    _startButton.position = CGPointMake(0, -bg.size.height / 2);
    _startButton.completeBlock = ^(Boolean enable) {
        if (enable) {
            [weakSelf show:false];
            [(GameScene*)self.parent startGame:true];            
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
    [_playerSel selectOffsetIndex:isLeftDirection ? -1 : 1];
}

#pragma mark 获取展示动画
-(SKAction*)getShowAction:(BOOL)isShowAction{
    NSTimeInterval duration = 0.2;
    CGFloat moveY = [self getShowPosY:isShowAction];
    SKAction *move = [SKAction moveToY:moveY duration:duration];    
    move.timingMode = SKActionTimingEaseOut;
    return move;
}

#pragma mark 获取展示y轴位置
-(CGFloat)getShowPosY:(BOOL)isShowPosY{
    return isShowPosY ? _config.screenBottom + _config.screenRight + _menuSize.height / 2 : _config.screenTop + _menuSize.height / 2; 
}
@end
