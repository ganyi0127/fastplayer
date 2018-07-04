//
//  ItemButton.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/3.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SonamNumberLabel.h"

typedef NS_ENUM(NSInteger, ItemButtonType) {
    ItemButtonTypeCoins = 0,
    ItemButtonTypeScore,
    ItemButtonTypeHighscore
};

@interface ItemButton : SKNode

@property (assign, nonatomic) ItemButtonType type;
@property (strong, nonatomic) SonamNumberLabel *sonamNumberLabel;

+(ItemButton*)nodeWithButtonType:(ItemButtonType)itemButtonType;

-(void)setNumber:(NSInteger)number;

@end
