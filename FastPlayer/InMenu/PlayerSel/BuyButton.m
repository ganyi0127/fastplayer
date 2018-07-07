//
//  BuyButton.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/7.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "BuyButton.h"

@implementation BuyButton

+ (instancetype)node{
    SKTexture *texture = [SKTexture textureWithImageNamed:@"btn_buy"];
    return [[self alloc] init:@[texture]];
}

- (id)init:(NSArray *)textures{
    self = [super init:textures];
    return self;
}


- (void)changePlayerTypeOfPrice:(PlayerType)playerType{
    
}

@end
