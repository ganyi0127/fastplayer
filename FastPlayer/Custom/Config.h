//
//  Config.h
//  Doudizhu
//
//  Created by bi ying on 2018/6/12.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

///判断是否为iphoneX
#define isIphoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))


///定时器
static inline void delay(NSTimeInterval interval, dispatch_block_t block) {  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC * interval)), dispatch_get_main_queue(), block);
}

@interface Config : NSObject

@property (assign, nonatomic) CGSize screenSize;
@property (assign, nonatomic) CGSize viewSize;

@property (assign, nonatomic) CGSize menuSize;

@property (assign, nonatomic) NSString *globeFontName;

@property (assign, nonatomic) CGPoint shotPosition;
@property (assign, nonatomic) CGPoint ballPosition;

@property (assign, nonatomic) NSInteger playerLimit;
@property (assign, nonatomic) CGPoint playerPosition0;
@property (assign, nonatomic) CGPoint playerPosition1;
@property (assign, nonatomic) CGPoint playerPosition2;
@property (assign, nonatomic) CGPoint playerPosition3;
@property (assign, nonatomic) CGPoint playerPosition4;
@property (assign, nonatomic) CGPoint playerPosition5;
@property (assign, nonatomic) CGPoint playerPosition6;
@property (assign, nonatomic) CGPoint playerPosition7;
@property (assign, nonatomic) CGPoint playerPosition8;
@property (assign, nonatomic) CGPoint playerPosition9;

@property (assign, nonatomic) CGFloat screenTop;
@property (assign, nonatomic) CGFloat screenBottom;
@property (assign, nonatomic) CGFloat screenLeft;
@property (assign, nonatomic) CGFloat screenRight;

@property (assign, nonatomic) NSString *keyPathOfCardOriginList; 
@property (assign, nonatomic) NSString *keyPathOfPlayCardOriginList; 
@property (assign, nonatomic) NSString *keyPathOfBankCardOriginList;
@property (assign, nonatomic) NSString *keyPathOfPoolResult; 

@property (assign, nonatomic) UInt32 worldBitmask;
@property (assign, nonatomic) UInt32 ballBitmask;
@property (assign, nonatomic) UInt32 playerBitmask;
@property (assign, nonatomic) UInt32 doorBitmask;
@property (assign, nonatomic) UInt32 goalBitmask;


+(instancetype) shareInstance; 


@end
