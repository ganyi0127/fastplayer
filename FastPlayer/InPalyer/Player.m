//
//  Player.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Player.h"
#import "GroundNet.h"

@implementation Player{
    GroundNet *_groundNet;
}

+ (Player *)nodeWithType:(PlayerType)type{
    return [[self alloc] initWithType:type];
}

- (instancetype)initWithType:(PlayerType)type 
{
    SKTexture *texture = [SKTexture textureWithImageNamed:@""];
    self = [super initWithTexture:texture];
    if (self) {
        _type = type;
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    _groundNet = [GroundNet shareInstance];
    
    _isTwins = false;
    
    [self moveToColumnOffset:0 withCompletion:NULL];
}

-(void)createContents{
    
}

- (void)moveToColumnOffset:(NSInteger)columnOffset withCompletion:(void (^)(NSInteger, NSInteger))completion{

    NSInteger newColumnIndex = _groundNet.playerColumnIndex + columnOffset;
    NSInteger newRowIndex = _isTwins ? _groundNet.playerTwinsRowIndex : _groundNet.playerRowIndex;
    _groundNet.playerColumnIndex = newColumnIndex;
    if (_isTwins) {        
        _groundNet.playerRowIndex = newRowIndex;
    }else{
        _groundNet.playerTwinsRowIndex = newRowIndex;
    }
    CGPoint newPosition = [_groundNet getGroundPositionByColumnIndex:newColumnIndex byRowIndex:newRowIndex];    
    
    SKAction *move = [SKAction moveTo:newPosition duration:0.2];
    move.timingMode = SKActionTimingEaseOut;
    [self runAction:move];
    [self runAction:move completion:^{
        if (completion) {            
            completion(newColumnIndex, newRowIndex);
        }
    }];
    
    if (_twins) {
        [_twins moveToColumnOffset:columnOffset withCompletion:completion];
    }
}
@end
