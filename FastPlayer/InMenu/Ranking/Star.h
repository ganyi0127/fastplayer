//
//  Star.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/8.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Star : SKSpriteNode
typedef NS_ENUM(NSInteger, StarType) {
    StarTypeOne = 0,
    StarTypeTwo,
    StarTypeThree
};


+(Star*)nodeWithStarType:(StarType)starType;

@end
