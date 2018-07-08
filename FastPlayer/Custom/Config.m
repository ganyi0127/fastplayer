//
//  Config.m
//  Doudizhu
//
//  Created by bi ying on 2018/6/12.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Config.h"

@implementation Config
static Config* _instance = nil;  

+(instancetype) shareInstance  {  
    static dispatch_once_t onceToken ;  
    dispatch_once(&onceToken, ^{  
        _instance = [[self alloc] init] ;  
    }) ;  
    
    return _instance ;  
}  

- (id)init {
    if (self = [super init]) {
        [self config];
        [self createContents];
    }    
    return self;
}

- (void)config{
    _screenSize = CGSizeMake(1242, 2208);
    _viewSize = [[UIScreen mainScreen] bounds].size;
    _globeFontName = @"Thonburi-Bold";
    
    _keyPathOfCardOriginList = @"cardOriginList";
    _keyPathOfPlayCardOriginList = @"playCardOriginList";
    _keyPathOfBankCardOriginList = @"bankCardOriginList";
    _keyPathOfPoolResult = @"poolResult";
    
    //top
    if (_screenSize.height / _screenSize.width > _viewSize.height / _viewSize.width) {        
        CGFloat height = _viewSize.height * _screenSize.width / _viewSize.width; 
        _screenTop = height / 2;
    }else {
        _screenTop = _screenSize.height / 2;
    }
    
    //bottom
    if (_screenSize.height / _screenSize.width > _viewSize.height / _viewSize.width) { 
        CGFloat height = _viewSize.height * _screenSize.width / _viewSize.width;
        _screenBottom = -height / 2;
    }else {
        _screenBottom = -_screenSize.height / 2;
    }
    
    //left
    if (_screenSize.height / _screenSize.width < _viewSize.height / _viewSize.width) { 
        CGFloat width = _viewSize.width * _screenSize.height / _viewSize.height;
        _screenLeft = -width / 2;
    }else {
        _screenLeft = -_screenSize.width / 2;
    }
    
    //right
    if (_screenSize.height / _screenSize.width < _viewSize.height / _viewSize.width) { 
        CGFloat width = _viewSize.width * _screenSize.height / _viewSize.height;
        _screenRight = width / 2;
    }else {
        _screenRight = _screenSize.width / 2;
    }
    
    _menuSize = CGSizeMake(_screenSize.width * 0.95, _screenSize.height - _screenSize.width / 2);
    
    _shotPosition = CGPointMake(0, -900);  
    _ballPosition = CGPointMake(0, -900);
    
    _playerLimit = 10;
    
    _playerPosition0 = CGPointMake(0, -700);
    _playerPosition1 = CGPointMake(50, -400);
    _playerPosition2 = CGPointMake(-50, -100);
    _playerPosition3 = CGPointMake(-50, 300);
    _playerPosition4 = CGPointMake(0, 500);
    _playerPosition5 = CGPointMake(350, -600);
    _playerPosition6 = CGPointMake(-350, -500);
    _playerPosition7 = CGPointMake(350, 400);
    _playerPosition8 = CGPointMake(-350, 600);
    _playerPosition9 = CGPointMake(0, 700);
    
    _worldBitmask   = 0x01 << 0;
    _ballBitmask    = 0x01 << 1;
    _playerBitmask  = 0x01 << 2;
    _doorBitmask    = 0x01 << 3;
    _goalBitmask    = 0x01 << 4;
}

- (void)createContents{
    
}
@end
