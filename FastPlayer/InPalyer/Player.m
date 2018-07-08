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
    
    NSMutableArray<SKTexture*> *_textures;
}

+ (Player *)nodeWithType:(PlayerType)type{
    return [[self alloc] initWithType:type];
}

- (instancetype)initWithType:(PlayerType)type 
{
    NSString *textureName = @"";
    NSInteger count = 2;
    switch (type) {
        case PlayerTypeNormal:
            textureName = @"player_normal_";
            break;
        case PlayerTypeTimer:
            textureName = @"player_timer_";
            break;
        case PlayerTypeTwins:
            textureName = @"player_twins_";
            break;
        case PlayerTypeGolder:
            textureName = @"player_golder_";
            break;
        default:
            textureName = @"player_trickster_";
            count = 3;
            break;
    }
    
    _textures = [NSMutableArray array];
    for (NSInteger i=0; i<count; i++) {
        NSString *name = [NSString stringWithFormat:@"%@%ld",textureName,i];
        SKTexture *texture = [SKTexture textureWithImageNamed:name];
        [_textures addObject:texture];
    }
    
    SKTexture *firstTexture = [_textures firstObject];    
    self = [super initWithTexture:firstTexture];
    if (self) {
        _type = type;
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    _groundNet = [GroundNet shareInstance];
    
    _isTwins = NO;
    _canMove = YES;
    
    [self moveToColumnOffset:0 withCompletion:NULL];
    
    //播放动画
    SKAction *anim = [SKAction animateWithTextures:_textures timePerFrame:0.1 resize:NO restore:NO];
    SKAction *forever = [SKAction repeatActionForever:anim];
    [self runAction:forever];
}

-(void)createContents{
}

- (void)moveToColumnOffset:(NSInteger)columnOffset withCompletion:(void (^)(NSInteger, NSInteger))completion{
    _canMove = NO; 
    
    
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
        self->_canMove = YES;
        
        if (completion) {            
            completion(newColumnIndex, newRowIndex);
        }
    }];
    
    if (_twins) {
        [_twins moveToColumnOffset:columnOffset withCompletion:completion];
    }
}
@end
