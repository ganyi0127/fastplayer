//
//  ControllerButton.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "ControllerButton.h"
#import "Config.h"

@implementation ControllerButton{
    Config *_config;
    
    SKTexture *_normalTexture;
    SKTexture *_touchTexture;
}

+ (ControllerButton *)nodeWithIsLeftDirection:(BOOL)leftDirection{
    return [[self alloc] initWithDirection:leftDirection];
}

- (instancetype)initWithDirection:(BOOL)leftDirection
{
    SKTexture *texture = [SKTexture textureWithImageNamed:@""];
    self = [super initWithTexture:texture];
    if (self) {
        _isLeftDirection = leftDirection;
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    _config = [Config shareInstance];
    [self setUserInteractionEnabled:YES];
    
    _normalTexture = self.texture;
    _touchTexture = [SKTexture textureWithImageNamed:@""];
    
    CGFloat x = _isLeftDirection ? _config.screenLeft / 2 : _config.screenRight / 2;
    self.position = CGPointMake(x, 0);
}

-(void)createContents{
    SKTexture *directionTexture = [SKTexture textureWithImageNamed:@""];
    SKSpriteNode *directionNode = [SKSpriteNode spriteNodeWithTexture:directionTexture];
    directionNode.xScale = _isLeftDirection ? 1 : -1;
    [self addChild:directionNode];
}


//获取点击开始动画
-(SKAction*)getScaleInAction{
    SKAction *scaleIn = [SKAction scaleTo:0.9 duration:0.1];
    scaleIn.timingMode = SKActionTimingEaseOut;
    return scaleIn;
}

//获取点击结束动画
-(SKAction*)getScaleOutAction{
    SKAction *scaleOut = [SKAction scaleTo:1.05 duration:0.08];
    scaleOut.timingMode = SKActionTimingEaseOut;
    SKAction *scaleIn = [SKAction scaleTo:1 duration:0.02];
    scaleIn.timingMode = SKActionTimingEaseIn;
    SKAction *seq = [SKAction sequence:@[scaleOut, scaleIn]];
    return seq;
}

#pragma mark 触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.texture = _touchTexture;
    [self runAction:[self getScaleOutAction]];
    
    //点击回调
    _completeBlock(_isLeftDirection);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.texture = _normalTexture;
    [self runAction:[self getScaleInAction]];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.texture = _normalTexture;
    [self runAction:[self getScaleInAction]];
}
@end
