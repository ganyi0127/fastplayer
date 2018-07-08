//
//  Star.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/8.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Star.h"

@implementation Star

+ (Star *)nodeWithStarType:(StarType)starType{
    return [[self alloc] initWithStarType:starType];
}

- (instancetype)initWithStarType:(StarType)starType
{
    NSString *textureName;
    switch (starType) {
        case StarTypeOne:
            textureName = @"";
            break;
        case StarTypeTwo:
            textureName = @"";
            break;            
        default:
            textureName = @"";
            break;
    }
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    self = [super initWithTexture:texture];
    if (self) {
        
    }
    return self;
}
@end
