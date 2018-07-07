//
//  BuyButton.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/7.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SonamButton.h"
#import "Player.h"

@interface BuyButton : SonamButton

///修改价格
-(void)changePlayerTypeOfPrice:(PlayerType)playerType;

@end
