//
//  Ball.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Ball.h"

@implementation Ball
- (instancetype)init
{
    SKTexture *texture = [SKTexture textureWithImageNamed:@""];
    self = [super initWithTexture:texture];
    if (self) {
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    
}

-(void)createContents{
    
}

- (void)followPosition:(CGPoint)position{
    SKAction *move = [SKAction moveTo:position duration:0.3];
    move.timingMode = SKActionTimingEaseIn;
    [self runAction:move];
}
@end
