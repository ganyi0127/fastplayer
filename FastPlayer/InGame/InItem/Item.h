//
//  Item.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/2.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Ground.h"
#import "Player.h"

@interface Item : SKSpriteNode

@property(assign, nonatomic) GroundType type;

+(Item*)nodeWithGroundType:(GroundType)groundType;
-(instancetype)initWithGroundType:(GroundType)groundType;

///完成回调(消失动画)
-(void)clearWithPlayerType:(PlayerType)playerType withCompleteBlock:(void (^)(BOOL completed))completeBlock;

@end
