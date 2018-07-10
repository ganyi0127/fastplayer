//
//  BuyButton.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/7.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "BuyButton.h"
#import "ItemButton.h"
#import "Score.h"

@implementation BuyButton{
    ItemButton *_itemButton;
}

+ (instancetype)node{
    SKTexture *texture = [SKTexture textureWithImageNamed:@"btn_buy"];
    SKTexture *highLightTexture = [SKTexture textureWithImageNamed:@"btn_buy_selected"];
    return [[self alloc] init:@[texture, highLightTexture]];
}

- (id)init:(NSArray *)textures{
    self = [super init:textures];
    return self;
}

- (void)createContents{
    [super createContents];
    
    //添加itemButton
    _itemButton = [ItemButton nodeWithButtonType:ItemButtonTypeCoins];
    _itemButton.position = CGPointMake(-self.size.width / 2 + 100, 20);
    [self addChild:_itemButton];
}


- (void)changePlayerTypeOfPrice:(PlayerType)playerType{
    _playerType = playerType;
    
    NSInteger price = [[Score shareInstance] getPriceFromPlayerType:_playerType];
    [_itemButton setNumber:price];
}

//重写选择方法
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {        
    [self setSonamButtonType:SonamButtonTypeNormal];
    if (self.completeBlock) {
        
        BOOL flag = [[Score shareInstance] unlockPlayer:_playerType];
        self.completeBlock(flag);
    }
}

@end
