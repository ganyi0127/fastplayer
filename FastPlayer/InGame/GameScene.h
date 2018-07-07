//
//  GameScene.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property(nonatomic, assign) BOOL isOver;
@property (assign, nonatomic) BOOL isStart;

-(void)startGame:(BOOL)isRun;

@end
