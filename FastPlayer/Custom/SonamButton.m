//
//  SonamButton.m
//  Doudizhu
//
//  Created by bi ying on 2018/6/12.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "SonamButton.h"
#import "Config.h"

@implementation SonamButton{
    Boolean _hasTexture;
    Boolean _isEnable;
    NSArray *_textures;
    SonamButtonType _type;
    CGSize _customSize;
}

+ (SonamButton*)button:(NSArray *)textures{
    return [[SonamButton alloc] init:textures];
}

- (id)init:(NSArray<SKTexture*> *)textures {
    _customSize = CGSizeMake(150, 80);
    
    self = [super initWithTexture:textures.firstObject color:SKColor.whiteColor size:textures.firstObject.size];
    if (self) {
        [self config];
        [self createContents];
    }
    
    if (textures != NULL && textures.count > 0) {
        _customSize = [(SKTexture *)([textures firstObject]) size];
        [self setSize:_customSize];
        
        _hasTexture = YES;
        _textures = textures;
    }else {     
        
        _hasTexture = NO;
        _textures = [[NSArray alloc] init];
    }
    
    return self;
}

- (void)config{    
    _hasTexture = NO;
    [self setIsEnable:YES];
    
    [self setColor:SKColor.blueColor];
}

- (void)createContents{
    
}

///设置按钮点击状态
- (void)setIsEnable: (Boolean)isEnable {
    _isEnable = isEnable;
    if (!_isEnable) {
        [self setSonamButtonType:(SonamButtonTypeDisable)];
    }
    
    [self setUserInteractionEnabled:_isEnable];
}

///设置按钮状态
- (void)setSonamButtonType: (SonamButtonType) sonamButtonType {
    _type = sonamButtonType;

    switch (_type) {
        case SonamButtonTypeNormal:
            if (_textures != NULL && _textures.count > 0) {                
                [self setTexture:[_textures firstObject]];
            }else {
                [self setColor:[SKColor blueColor]];
            }
            break;
        case SonamButtonTypeHighLighted:
            if (_textures != NULL && _textures.count > 1) {                
                [self setTexture:[_textures objectAtIndex:1]];
            }else {
                [self setColor:[SKColor redColor]];
            }
            break;
        default:
            if (_textures != NULL && _textures.count > 0) {                
                [self setTexture:[_textures lastObject]];
            }else {
                [self setColor:[SKColor grayColor]];
            }
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setSonamButtonType:SonamButtonTypeHighLighted];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setSonamButtonType:SonamButtonTypeNormal];
    if (self.completeBlock) {
        self.completeBlock(_isEnable);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setSonamButtonType:SonamButtonTypeNormal];
}

@end

