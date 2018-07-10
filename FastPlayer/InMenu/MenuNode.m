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
#import "SKNode+Funcation.h"
#import "BuyButton.h"

@interface MenuNode()<UITextFieldDelegate>
@end

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
    UITextField *_usernameField;
    CGRect _usernameShowRect;
    CGRect _usernameHiddenRect;
    BuyButton *_buyButton;
    
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

- (void)setTextField:(GameScene *)scene{
    //用户名
    _usernameShowRect = CGRectMake(100, 120, 200, 24);
    _usernameHiddenRect = CGRectMake(100, 120 - _config.viewSize.height, 200, 24);
    _usernameField = [[UITextField alloc] initWithFrame:_usernameShowRect];
    [_usernameField setTextAlignment:NSTextAlignmentCenter];
    _usernameField.placeholder = @"点击输入玩家名";
    _usernameField.text = [_score getUsername];
    _usernameField.delegate = self;
    UIView *view = (UIView*)scene.view;
    [view addSubview:_usernameField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (text.length != 0) {        
        if ([_score setUsername:text]){
            //上传
            __weak typeof (self)weakSelf = self;
            [Session updateFieldWithUsername:text withCompleteBlock:^(BOOL successed, NSDictionary *result) {
                NSString *notifString = successed ? @"更新玩家名成功" : @"更新玩家名失败";
                [weakSelf showNotif:notifString];
            }];
        }
        return YES;
    }else{
        [self showNotif:@"玩家名不能为空"];
        [textField setText:[_score getUsername]];
        return NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger maxLength = 20;
    
    
    if (string.length + range.length + textField.text.length > maxLength) {
        return NO;
    }
    
    return YES;
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
            //播放音效
            SKAction *sound = [SKAction playSoundFileNamed:@"sound/DM-CGS-31" waitForCompletion:NO];
            [weakSelf runAction:sound];
            
            [weakSelf show:false];
            [(GameScene*)self.parent startGame:true];            
        }
    };
    [self addChild:_startButton];
    
    //层切换按钮
    SKTexture *rankingNormalTexture = [SKTexture textureWithImageNamed:@"btn_ranking"];
    SKTexture *rankingSelectedTexture = [SKTexture textureWithImageNamed:@"btn_ranking_selected"];
    _rankingButton = [SonamButton button:@[rankingNormalTexture, rankingSelectedTexture]];
    _rankingButton.position = CGPointMake(_config.screenLeft + 180, _config.menuSize.height / 2 - 270);
    _rankingButton.canSelected = YES;
    _rankingButton.completeBlock = ^(Boolean enable) {
        //播放音效
        SKAction *sound = [SKAction playSoundFileNamed:@"sound/DM-CGS-25" waitForCompletion:NO];
        [weakSelf runAction:sound];
        
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
    
    //添加购买按钮
    _buyButton = [BuyButton node];
    _buyButton.position = CGPointMake(0, -bg.size.height / 2 + 300);
    _buyButton.hidden = [_score isUnlockWithPlayer:[_score getPlayerType]];
    [_buyButton changePlayerTypeOfPrice:[_score getPlayerType]];
    _buyButton.completeBlock = ^(Boolean enable) {
        if (enable) {
            self->_buyButton.hidden = YES;
            [weakSelf showNotif:@"购买成功"];
        }else{
            [weakSelf showNotif:@"金币不足"];
        }
    };
    [_menuLayer addChild:_buyButton];
    
    //排行榜层+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    _rankingLayer = [SKNode node];
    [self addChild:_rankingLayer];
        
    _rankingNode = [RankingNode node];
    _rankingNode.position = CGPointMake(0, -50);
    [_rankingNode setUserInteractionEnabled:NO];
    [_rankingLayer addChild:_rankingNode];
    
    [self switchLayer:_showRanking withInit:YES];
}

///切换图层
-(void)switchLayer:(BOOL)isShowRanking withInit:(BOOL)isInit{
    __weak __typeof (self)weakSelf = self;
    
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
                        [weakSelf showNotif:@"更新排行榜失败"];
                    }
                }];
            }else{
                //[weakSelf showNotif:@"网络请求失败"];
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
    if (_usernameField.isEditing) {
        [_usernameField endEditing:NO];
    }
    
    _isShow = isShow;
    _startButton.isEnable = _isShow;
    
    //更新highscore值
    if (isShow) {
        [self updateHighscoreValue];                    
    }
    
    //textField动画
    [UIView animateWithDuration:0.2 animations:^{
        [self->_usernameField setFrame:isShow ? _usernameShowRect : _usernameHiddenRect];
    }];
    
    
    [self runAction:[self getShowAction:_isShow]];
    return !_isShow;
}

- (void)selectPlayerByDirection:(BOOL)isLeftDirection{
    [_playerSel selectOffsetIndex:isLeftDirection ? -1 : 1];
    
    PlayerType selectedPlayerType = _playerSel.index;
    
    _buyButton.hidden = [_score isUnlockWithPlayer:selectedPlayerType];
    [_buyButton changePlayerTypeOfPrice:selectedPlayerType];
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
