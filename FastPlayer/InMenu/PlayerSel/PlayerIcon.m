//
//  PlayerIcon.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/3.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "PlayerIcon.h"
#import "Score.h"

@implementation PlayerIcon{
    Score *_score;
    NSMutableArray<SKTexture*> *_textures;
}

+ (PlayerIcon *)nodeWithPlayerType:(PlayerType)playerType{
    return [[self alloc] initWithPlayerType:playerType];
}

- (instancetype)initWithPlayerType:(PlayerType)playerType 
{
    _textures = [NSMutableArray array];
    NSString *textureName = @"";
    NSInteger count = 2;
    switch (playerType) {
        case PlayerTypeNormal:
            textureName = @"playerIcon_normal_";
            break;            
        case PlayerTypeGolder:
            textureName = @"playerIcon_golder_";
            break;
        case PlayerTypeTimer:
            textureName = @"playerIcon_timer_";
            break;
        case PlayerTypeTwins:
            textureName = @"playerIcon_twins_";
            count = 3;
            break;
        default:
            textureName = @"playerIcon_trickster_";
            break;
    }
    
    for (NSInteger i=0; i<count; i++) {
        NSString *name = [NSString stringWithFormat:@"%@%ld",textureName,i];
        SKTexture *texture = [SKTexture textureWithImageNamed:name];
        [_textures addObject:texture];
    }
    
    
    SKTexture *firstTexutre = [_textures firstObject];
    self = [super initWithTexture:firstTexutre color:SKColor.clearColor size:firstTexutre.size];
    
    if (self) {
        
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    _score = [Score shareInstance];
    
//    CGFloat scale = 200 / self.texture.size.height;
//    [self setScale:scale];
    
    //播放idle动画
    SKAction *anim = [SKAction animateWithTextures:_textures timePerFrame:0.2 resize:false restore:true];
    SKAction *forever = [SKAction repeatActionForever:anim];
    [self runAction:forever];
}

-(void)createContents{
    
}

- (void)setSelected:(BOOL)isSelected{
    SKAction *selectAction = [self getActionBySelected:isSelected];
    [self runAction:selectAction];
}

-(BOOL)unlock{
    return [_score unlockPlayer:_playerType];
}

//获取选中动画
-(SKAction*)getActionBySelected:(BOOL)isSelected{
    if (isSelected) {
        SKAction *scaleOut = [SKAction scaleTo:1.05 duration:0.2];
        scaleOut.timingMode = SKActionTimingEaseOut;
        SKAction *scaleIn = [SKAction scaleTo:0.98 duration:0.1];
        scaleIn.timingMode = SKActionTimingEaseInEaseOut;
        SKAction *scaleOri = [SKAction scaleTo:1 duration:0.05];
        scaleOri.timingMode = SKActionTimingEaseInEaseOut;
        return [SKAction sequence:@[scaleOut,scaleIn,scaleOri]];
    }else{
        SKAction *scaleIn = [SKAction scaleTo:0.95 duration:0.2];
        scaleIn.timingMode = SKActionTimingEaseOut;
        SKAction *scaleOut = [SKAction scaleTo:0.98 duration:0.1];
        scaleOut.timingMode = SKActionTimingEaseInEaseOut;
        SKAction *scaleOri = [SKAction scaleTo:0.96 duration:0.05];
        scaleOri.timingMode = SKActionTimingEaseInEaseOut;
        return [SKAction sequence:@[scaleIn, scaleOut, scaleOri]];
    }
}

@end
