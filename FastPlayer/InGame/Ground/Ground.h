//
//  Ground.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"

typedef NS_ENUM(NSInteger, GroundType) {
    GroundTypeNone = 0,
    GroundTypeTimer,
    GroundTypeTwins,
    GroundTypeGolder,
    GroundTypeTrap,
    GroundTypePlayer
};

typedef NS_ENUM(NSInteger, TriggerType) {
    TriggerTypeNone = 0,
    TriggerTypeTimer,
    TriggerTypeDoubleTimer,
    TriggerTypeTwins,
    TriggerTypeGolder,
    TriggerTypeDoubleGolder,
    TriggerTypeMainDead,
    TriggerTypeTwinsDead
};


@interface Ground : SKSpriteNode

+(Ground*)nodeWithGroundType: (GroundType)groundType;

@property (assign, nonatomic, readonly) GroundType type;

@property (assign, nonatomic, readonly) NSInteger columnIndex;
@property (assign, nonatomic, readonly) NSInteger rowIndex;

///触发物品
-(void)triggerObjectByPlayerType:(PlayerType)playerType withCompletion:(void(^)(TriggerType triggerType))complection;


@end
