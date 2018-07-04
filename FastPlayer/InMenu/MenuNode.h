//
//  MenuNode.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MenuNode : SKNode

@property (assign, nonatomic, readonly) BOOL isShow;

///自动
-(BOOL)autoShow;

///显示/隐藏
-(BOOL)show:(BOOL)isShow;

//选择操作
-(void)selectPlayerByDirection:(BOOL)isLeftDirection;

@end
