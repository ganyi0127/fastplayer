//
//  TimeNode.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/2.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TimeNode : SKSpriteNode

@property (assign, nonatomic, readonly) NSInteger curTime;
@property (assign, nonatomic, readonly) NSInteger maxTime;

@property (copy, nonatomic) void (^completeBlock)(BOOL stop, NSInteger curTime);


///设置时间
-(void)setTime:(NSInteger)time;

///设置max时间
-(void)setMaxTime:(NSInteger)maxTime;

///修改时间
-(void)addTime:(NSInteger)subTime;

///暂停
-(void)startCount:(BOOL)flag;


///重置
-(void)reset;
@end
