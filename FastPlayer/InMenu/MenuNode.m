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
#import "RankingNode.h"
#import "Session+Post.h"

@implementation MenuNode{
    Score *_score;
    
    Config *_config;    
    CGSize _menuSize;
    BOOL _showRanking;
    
    ItemButton *_highscoreItemButton;
    PlayerSel *_playerSel;
    SonamButton *_startButton;
    RankingNode *_rankingNode;
    SonamButton *_rankingButton;
    
        
    //存储菜单图层
    SKNode *_menuLayer;
    
    //存储排行榜图层
    SKNode *_rankingLayer;
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
    _score = [Score shareInstance];
    
    _menuSize = _config.menuSize;
    
    _isShow = YES;
    _showRanking = NO;
    
    self.zPosition = 20;
    self.position = CGPointMake(0, [self getShowPosY:_isShow]);
}

-(void)createContents{
    __weak typeof (self)weakSelf = self;
    
    //添加背景
    SKTexture *bgTexture = [SKTexture textureWithImageNamed:@"bg_menu"];
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:bgTexture size:CGSizeMake(_menuSize.width, _menuSize.height)];
    CGFloat scale = (_menuSize.width - 128)/bgTexture.size.width;
    [bg setScale:scale];
    [self addChild:bg];
    
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
    
    //层切换按钮
    SKTexture *rankingNormalTexture = [SKTexture textureWithImageNamed:@""];
    SKTexture *rankingSelectedTexture = [SKTexture textureWithImageNamed:@""];
    _rankingButton = [SonamButton button:@[rankingNormalTexture, rankingSelectedTexture]];
    _rankingButton.position = CGPointMake(_config.screenLeft + 200, _config.menuSize.height / 2 - 200);
    _rankingButton.canSelected = YES;
    _rankingButton.completeBlock = ^(Boolean enable) {
        [weakSelf switchLayer:enable withInit:NO];
    };
    [self addChild:_rankingButton];

    //菜单层+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    _menuLayer = [SKNode node];
    [self addChild:_menuLayer];
    
    //添加highscore
    _highscoreItemButton = [ItemButton nodeWithButtonType:ItemButtonTypeHighscore];
    _highscoreItemButton.position = CGPointMake(0, 300);    
    [_menuLayer addChild:_highscoreItemButton];
    
    //更新highscore值
    [self updateHighscoreValue];
    
    //添加角色选择
    _playerSel = [PlayerSel node];
    _playerSel.position = CGPointMake(0, 0);
    [_menuLayer addChild:_playerSel];
    
    //排行榜层+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    _rankingLayer = [SKNode node];
    [self addChild:_rankingLayer];
        
    _rankingNode = [RankingNode node];
    [_rankingNode setUserInteractionEnabled:NO];
    [_rankingLayer addChild:_rankingNode];
    
    [self switchLayer:_showRanking withInit:YES];
}

///切换图层
-(void)switchLayer:(BOOL)isShowRanking withInit:(BOOL)isInit{
    _showRanking = isShowRanking;
    
    NSTimeInterval duration = isInit ? 0 : 0.3;
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:duration];
    fadeOut.timingMode = SKActionTimingEaseOut;
    SKAction *fadeIn = [SKAction fadeInWithDuration:duration];
    fadeIn.timingMode = SKActionTimingEaseOut;
    
    if (_showRanking) {
        _showRanking = NO;
        //上传最高分数
        [Session addDocumentWithUsername:[_score getUsername] withScore:[_score getScore] withCompleteBlock:^(BOOL successed, NSDictionary *result) {
            if (successed) {
                //更新排行榜
                [self->_rankingNode updateDataByNew:YES WithCompleteBlock:^(BOOL success, NSString *message) {
                    if (success) {
                        
                    }else{
                        NSLog(@"更新排行榜失败!!!!!!!!!!!!!!!!!!!!");
                    }
                }];
            }else{
                NSLog(@"上传最高分数失败!!!!!!!!!!!!!!!!!!!!");
            }
            [self->_menuLayer runAction:fadeOut];
            [self->_rankingNode setUserInteractionEnabled:YES];
            [self->_rankingLayer runAction:fadeIn];
        }];
        
    }else{
        [_menuLayer runAction:fadeIn];
        [_rankingNode setUserInteractionEnabled:NO];
        [_rankingLayer runAction:fadeOut];
    }
}

- (BOOL)autoShow{
    return [self show:!_isShow];
}

- (BOOL)show:(BOOL)isShow{
    _isShow = isShow;
    _startButton.isEnable = _isShow;
    
    //更新highscore值
    if (isShow) {
        [self updateHighscoreValue];
    }
    
    [self runAction:[self getShowAction:_isShow]];
    return !_isShow;
}

- (void)selectPlayerByDirection:(BOOL)isLeftDirection{
    [_playerSel selectOffsetIndex:isLeftDirection ? -1 : 1];
}

///更新highscore值
-(void)updateHighscoreValue{
    NSInteger score = [_score getScore];
    [_highscoreItemButton setNumber:score];
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
