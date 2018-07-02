//
//  MenuNode.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "MenuNode.h"
#import "Config.h"
#import "SonamNumberLabel.h"
#import "SonamButton.h"
#import "Score.h"
#import "Player.h"

@implementation MenuNode{
    Config *_config;    
    CGSize _menuSize;
    
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
}

- (BOOL)autoShow{
    return [self show:!_isShow];
}

- (BOOL)show:(BOOL)isShow{
    _isShow = isShow;
    
    [self runAction:[self getShowAction:_isShow]];
    return !_isShow;
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
