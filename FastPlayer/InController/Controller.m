//
//  Controller.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Controller.h"
#import "Config.h"
#import "ControllerButton.h"

@implementation Controller{
    Config *_config;
    
    ControllerButton *_leftButton;
    ControllerButton *_rightButton;
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
    
    [self setUserInteractionEnabled:YES];
    
    self.position = CGPointMake(0, _config.screenBottom + (_config.screenSize.height - _config.menuSize.height) / 2);
}

-(void)createContents{
    
    _leftButton = [ControllerButton nodeWithIsLeftDirection:YES];
    _leftButton.completeBlock = ^(BOOL isLeftDirection) {
        self->_completeBlock(isLeftDirection);
    };
    [self addChild:_leftButton];
    
    _rightButton = [ControllerButton nodeWithIsLeftDirection:NO];
    _rightButton.completeBlock = ^(BOOL isLeftDirection) {
        self->_completeBlock(isLeftDirection);
    };
    [self addChild:_rightButton];
}

@end

