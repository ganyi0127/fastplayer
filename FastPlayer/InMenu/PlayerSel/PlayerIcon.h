//
//  PlayerIcon.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/3.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"

@interface PlayerIcon : SKSpriteNode

@property (assign, nonatomic, readonly) PlayerType playerType;
@property (assign, nonatomic, readonly) BOOL isLocked;
@property (assign, nonatomic, readonly) NSInteger price;

+(PlayerIcon*)nodeWithPlayerType:(PlayerType)playerType;

-(void)setSelected:(BOOL)isSelected;

-(BOOL)unlock;
@end
