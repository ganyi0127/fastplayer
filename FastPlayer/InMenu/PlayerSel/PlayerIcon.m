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
}

+ (PlayerIcon *)nodeWithPlayerType:(PlayerType)playerType{
    return [[self alloc] initWithPlayerType:playerType];
}

- (instancetype)initWithPlayerType:(PlayerType)playerType 
{
    self = [super init];
    if (self) {
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    _score = [Score shareInstance];
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
