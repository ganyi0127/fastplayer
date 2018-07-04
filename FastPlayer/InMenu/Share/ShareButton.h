//
//  ShareButton.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/3.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger,ShareButtonType) {
    ShareButtonTypeWechat = 0,
    ShareButtonTypeQQ,
    ShareButtonTypeFacebook,
    ShareButtonTypeWeibo
};

@interface ShareButton : SKSpriteNode

@property (assign, nonatomic) ShareButtonType type;

+(ShareButton*)nodeWithShareButtonType:(ShareButtonType)shareButtonType;

@end
