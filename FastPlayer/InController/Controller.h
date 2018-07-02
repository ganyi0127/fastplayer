//
//  Controller.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Controller : SKNode

@property (strong, nonatomic) void (^completeBlock)(BOOL isLeft);

@end
