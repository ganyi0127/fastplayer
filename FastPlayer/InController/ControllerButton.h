//
//  ControllerButton.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ControllerButton : SKSpriteNode

@property (assign, nonatomic) BOOL isLeftDirection;
@property (copy, nonatomic) void (^completeBlock)(BOOL isLeftDirection);

+(ControllerButton*)nodeWithIsLeftDirection:(BOOL)leftDirection;
@end
