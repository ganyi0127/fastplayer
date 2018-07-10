//
//  SonamButton.h
//  Doudizhu
//
//  Created by bi ying on 2018/6/12.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(NSUInteger, SonamButtonType) {
    SonamButtonTypeNormal       = 1 << 0,
    SonamButtonTypeHighLighted  = 1 << 1,
    SonamButtonTypeDisable      = 1 << 2,
    SonamButtonTypeSelected     = 1 << 3
};

@interface SonamButton : SKSpriteNode

@property (assign, nonatomic) NSString *title;
@property (assign, nonatomic) Boolean isEnable;
@property (copy, nonatomic) void (^completeBlock)(Boolean enable);

///是否为可选中
@property (assign, nonatomic) BOOL canSelected;
///判断是否选中
@property (assign, nonatomic, readonly) BOOL isSelected;

+ (SonamButton*)button: (NSArray<SKTexture*>*)textures;
- (id)init: (NSArray *)textures;

-(void)config;
- (void)createContents;

- (void)setSonamButtonType: (SonamButtonType) sonamButtonType;
@end
