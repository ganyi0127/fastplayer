//
//  Player.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger,PlayerType) {
    PlayerTypeNormal = 0,
    PlayerTypeTimer,
    PlayerTypeGolder,
    PlayerTypeTrickster,
    PlayerTypeTwins
};

@interface Player : SKSpriteNode

@property (weak, nonatomic, readonly) Player *twins;
@property (assign, nonatomic, readonly) BOOL isTwins;
@property (assign, nonatomic, readonly) PlayerType type;
@property (assign, nonatomic, readonly) BOOL canMove;

+(Player*)nodeWithType:(PlayerType)type;

-(void)moveToColumnOffset:(NSInteger)columnOffset withCompletion:(void (^)(NSInteger newColumnIndex, NSInteger newRowIndex)) completion;

@end
