//
//  GroundNet.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "GroundNet.h"
#import "Config.h"

@implementation GroundNet{
    Config *_config;
}

static GroundNet *_instance = nil;  

+(instancetype) shareInstance  {  
    static dispatch_once_t onceToken ;  
    dispatch_once(&onceToken, ^{  
        _instance = [self groundNet];
    });  
    
    return _instance ;  
}  

+ (GroundNet *)groundNet{
    return [[self alloc] initWithColumnCount:7 withRowCount:16];
}

+ (GroundNet *)groundNetWithColumnCount:(NSInteger)columnCount withRowCount:(NSInteger)rowCount{
    return [[self alloc] initWithColumnCount:columnCount withRowCount:rowCount];
}

- (GroundNet *)initWithColumnCount:(NSInteger)columnCount withRowCount:(NSInteger)rowCount{    
    self = [super init];
    if (self) {
        _columnCount = columnCount;
        _rowCount = rowCount;
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    _config = [Config shareInstance];
    
    _playerColumnIndex = _columnCount / 2;
    _playerRowIndex = 6;
    _playerTwinsRowIndex = _playerRowIndex + 2;
}

-(void)createContents{
    
}

- (BOOL)canPlayerMoveBySteps:(NSInteger)stepsWillTake{
    NSInteger willColumnIndex = _playerColumnIndex + stepsWillTake;
    if (willColumnIndex < 0) {
        return NO;
    }else if (willColumnIndex > _columnCount - 1){
        return NO;
    }
    return YES;
}

- (CGSize)getGroundSize{
    CGFloat groundLength = _config.screenRight * 2 / _columnCount;
    return CGSizeMake(groundLength, groundLength);
}

- (CGPoint)getGroundPositionByColumnIndex:(NSInteger)columnIndex byRowIndex:(NSInteger)rowIndex{
    CGFloat groundLength = [self getGroundSize].width;
    CGFloat x = _config.screenLeft + groundLength / 2 + groundLength * (CGFloat)columnIndex;
    CGFloat y = _config.screenBottom - groundLength / 2 + groundLength * (CGFloat)rowIndex;
    return CGPointMake(x, y);
}
@end
