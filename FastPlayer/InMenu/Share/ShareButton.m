//
//  ShareButton.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/3.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "ShareButton.h"
#import "Score.h"

@implementation ShareButton{
    Score *_score;
}

+ (ShareButton *)nodeWithShareButtonType:(ShareButtonType)shareButtonType{
    return [[self alloc] initWithShareButtonType:shareButtonType];
}

- (instancetype)initWithShareButtonType:(ShareButtonType)shareButtonType
{
    self = [super init];
    if (self) {
        _type = shareButtonType;
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    _score = [Score shareInstance];
}

-(void)createContents{
    
}

-(void)share{
    NSInteger highestScore = [_score getScore];
    NSString *textToShare = [NSString stringWithFormat:@"我在游戏中获取了%@高分，快来试试吧!",highestScore];
    
    UIImage *imageToShare = [UIImage imageNamed:@"iosshare.jpg"]; 
    
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id<APPID>?mt=8"];
    
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
}
@end
