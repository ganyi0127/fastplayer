//
//  Item.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/2.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Item.h"
#import "GroundNet.h"
#import "Config.h"

@implementation Item{
    GroundNet *_groundNet;
    Config *_config;    
    
    NSMutableArray<SKTexture*> *_idleTextures;
    NSMutableArray<SKTexture*> *_clearTextures;
}

+ (Item *)nodeWithGroundType:(GroundType)groundType{
    return [[self alloc] initWithGroundType:groundType];
}

- (instancetype)initWithGroundType:(GroundType)groundType
{
    NSString *idleTextureName = @"";
    NSInteger idleCount = 1;
    NSString *clearTextureName = @"";
    NSInteger clearCount = 1;
    switch (groundType) {
        case GroundTypeGolder:
            idleTextureName = @"item_golder_";
            idleCount = 9;
            clearTextureName = @"item_golder_";
            clearCount = 9;
            break;
        case GroundTypeTrap:
            idleTextureName = @"item_trickster_";
            idleCount = 1;
            clearTextureName = @"item_trickster_";
            clearCount = 1; //13;
            break;
        case GroundTypePlayer:
            idleTextureName = @"item_normal_player_";
            idleCount = 2;
            clearCount = 0;
            break;
        case GroundTypeTimer:
            idleTextureName = @"item_timer_";
            idleCount = 4;
            clearCount = 0;
            break;
        case GroundTypeTwins:
            idleTextureName = @"item_twins_";
            idleCount = 5;
            clearCount = 0;
            break;
        default:
            idleCount = 0;
            clearCount = 0;
            break;
    }
    
    _idleTextures = [NSMutableArray array];
    for (NSInteger i=0; i<idleCount; i++) {
        NSString *textureName = [NSString stringWithFormat:@"%@%ld",idleTextureName,i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [_idleTextures addObject:texture];
    }
    
    _clearTextures = [NSMutableArray array];
    for (NSInteger i=0; i<clearCount; i++) {
        NSString *textureName = [NSString stringWithFormat:@"%@%ld",clearTextureName,i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [_clearTextures addObject:texture];
    }
    
    
    SKTexture *firstTexture = [_idleTextures firstObject];
    self = [super initWithTexture:firstTexture];
    if (self) {
        _type = groundType;
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    _config = [Config shareInstance];
    _groundNet = [GroundNet shareInstance]; 
}

-(void)createContents{
    //处理idle动画
    switch (_type) {
        case GroundTypeTrap:                    //陷阱
            //禁止
            [self setScale: _groundNet.getGroundSize.width / self.texture.size.width];
            break;
        case GroundTypeTimer:                   //时间
            //播放走秒动画
        {
            SKAction *anim = [SKAction animateWithTextures:_idleTextures timePerFrame:0.2 resize:NO restore:NO];
            SKAction *animForever = [SKAction repeatActionForever:anim];
            [self runAction:animForever];
        }
            [self setScale:0.5];
            break;
        case GroundTypeTwins:                   //分身
            //播放闪烁动画
        {
            SKAction *anim = [SKAction animateWithTextures:_idleTextures timePerFrame:0.2 resize:NO restore:NO];
            SKAction *animForever = [SKAction repeatActionForever:anim];
            [self runAction:animForever];
        }
            [self setScale:0.5];
            break;
        case GroundTypeGolder:                  //金币
            //播放闪耀动画
        {
            SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
            fadeIn.timingMode = SKActionTimingEaseInEaseOut;
            SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5];
            fadeOut.timingMode = SKActionTimingEaseInEaseOut;
            SKAction *seq = [SKAction sequence:@[fadeIn,fadeOut]];
            SKAction *fadeForever = [SKAction repeatActionForever:seq];
            SKAction *anim = [SKAction animateWithTextures:_idleTextures timePerFrame:0.1];
            SKAction *animForever = [SKAction repeatActionForever:anim];
            SKAction *group = [SKAction group:@[fadeForever,animForever]];
            [self runAction:group];
        }
            [self setScale:0.5];
            break;
        case GroundTypePlayer:                  //敌人
            //播放idle动画
        {
            SKAction *anim = [SKAction animateWithTextures:_idleTextures timePerFrame:0.2 resize:NO restore:NO];
            SKAction *animForever = [SKAction repeatActionForever:anim];
            [self runAction:animForever];
        }
            [self setScale:0.4];
            break;
        default:                                //无
            break;
    }
}

- (void)clearWithPlayerType:(PlayerType)playerType withCompleteBlock:(void (^)(BOOL))completeBlock{
    CGFloat hugeZPostion = 100;
    
    switch (_type) {
        case GroundTypeTrap:                    //陷阱
            //播放动画 然后消失
            if (playerType == PlayerTypeTrickster) {
                
            }else{
                SKAction *anim = [SKAction animateWithTextures:_clearTextures timePerFrame:0.1 resize:NO restore:NO];
                [self runAction:anim];
                completeBlock(YES);
            }            
            break;
        case GroundTypeTimer:                   //时间
            //移动到时间栏 然后消失
            if (playerType == PlayerTypeTimer) {
                
            }else{
                
            }
        {
            self.zPosition = hugeZPostion;
            NSTimeInterval duration = 0.5;
            SKAction *scaleOut = [SKAction scaleTo:2 duration:duration];
            scaleOut.timingMode = SKActionTimingEaseOut;
            SKAction *fadeOut = [SKAction fadeOutWithDuration:duration];
            fadeOut.timingMode = SKActionTimingEaseOut;
            SKAction *group = [SKAction group:@[scaleOut,fadeOut]];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *seq = [SKAction sequence:@[group,remove]];
            
            [self runAction:seq completion:^{
                completeBlock(YES);
            }];
        }   
            break;
        case GroundTypeTwins:                   //分身
            //播放动画 然后消失
            if (playerType == PlayerTypeTwins) {
                
            }else{
                
            }
            
        {
            self.zPosition = hugeZPostion;
            NSTimeInterval duration = 0.5;
            SKAction *scaleOut = [SKAction scaleTo:2 duration:duration];
            scaleOut.timingMode = SKActionTimingEaseOut;
            SKAction *fadeOut = [SKAction fadeOutWithDuration:duration];
            fadeOut.timingMode = SKActionTimingEaseOut;
            SKAction *group = [SKAction group:@[scaleOut,fadeOut]];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *seq = [SKAction sequence:@[group,remove]];
            
            [self runAction:seq completion:^{
                completeBlock(YES);
            }];
        }  
            
            break;
        case GroundTypeGolder:                  //金币
            //移动到金币栏 然后消失
        {
            if (playerType == PlayerTypeGolder) {
                
            }else{
                
            }
            [self removeAllActions];
            self.zPosition = hugeZPostion;
            NSTimeInterval duration = 0.2;
            CGPoint targetPosition = CGPointMake(_config.screenRight - 50, _config.screenTop - 50);
            CGPoint targetPositionInScene = [self.parent.parent convertPoint:targetPosition fromNode:self];
            SKAction *move = [SKAction moveTo:targetPositionInScene duration:duration];
            move.timingMode = SKActionTimingEaseOut;
            SKAction *scaleIn = [SKAction scaleTo:0.5 duration:duration];
            scaleIn.timingMode = SKActionTimingEaseOut;
            SKAction *group = [SKAction group:@[move,scaleIn]];
            group.duration = duration;
            SKAction *wait = [SKAction waitForDuration:0.1];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *seq = [SKAction sequence:@[group,wait,remove]];
            [self runAction:seq completion:^{
                completeBlock(YES);
            }];
        }
            break;
        case GroundTypePlayer:                  //敌人
            //播放暴走动画 不做处理
            completeBlock(YES);
            break;
        default:                                //无
            break;
    }
}
@end
