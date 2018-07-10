//
//  TimeNode.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/2.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TimeNode : SKSpriteNode

@property (assign, nonatomic, readonly) NSTimeInterval curTime;
@property (assign, nonatomic, readonly) NSTimeInterval maxTime;

@property (copy, nonatomic) void (^completeBlock)(BOOL stop, NSTimeInterval curTime);


///设置时间
-(void)setTime:(NSTimeInterval)time;

///设置max时间
-(void)setMaxTime:(NSTimeInterval)maxTime;

///修改时间
-(void)addTime:(NSTimeInterval)subTime;

///暂停
-(void)startCount:(BOOL)flag;


///重置
-(void)reset;
@end
