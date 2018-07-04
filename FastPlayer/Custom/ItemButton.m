//
//  ItemButton.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/3.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "ItemButton.h"

@implementation ItemButton{
    SKSpriteNode *_item;
}

+ (ItemButton *)nodeWithButtonType:(ItemButtonType)itemButtonType{
    return [[self alloc] initWithButtonType:itemButtonType];
}

- (instancetype)initWithButtonType:(ItemButtonType)itemButtonType
{
    self = [super init];
    if (self) {
        _type = itemButtonType;
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    
}

-(void)createContents{
    
    //根据类型添加item
    NSString *itemTextureName;
    switch (_type) {
        case ItemButtonTypeCoins:
            itemTextureName = @"";
            break;
        case ItemButtonTypeScore:
            itemTextureName = @"";
            break;            
        default:
            itemTextureName = @"";
            break;
    }
    SKTexture *itemTexture = [SKTexture textureWithImageNamed:itemTextureName];
    _item = [SKSpriteNode spriteNodeWithTexture:itemTexture];
    [self addChild:_item];
    
    //添加sonamNumberLabel
    _sonamNumberLabel = [SonamNumberLabel numberLabel];
    [self addChild:_sonamNumberLabel];
    
    //更新ui 
    [self updateChildrens];
}

- (void)setNumber:(NSInteger)number{
    [_sonamNumberLabel setScoreNumber:number];
    
    //更新位置
    [self updateChildrens];
}

//更新所有子对象
-(void)updateChildrens{
    SKAction *sonamNumberLabelAction = [self getSonamNumberLabelAction];
    [_sonamNumberLabel runAction:sonamNumberLabelAction];
    
    SKAction *itemAction = [self getItemAction];
    [_item runAction:itemAction];
}

//获取item动画
-(SKAction*)getItemAction{
    SKAction *scaleOut = [SKAction scaleTo:1.1 duration:0.1];
    scaleOut.timingMode = SKActionTimingEaseOut;
    SKAction *scaleIn = [SKAction scaleTo:1 duration:0.1];
    scaleIn.timingMode = SKActionTimingEaseIn;
    return [SKAction sequence:@[scaleOut, scaleIn]];
}

//获取sonamNumberLabel位置动画
-(SKAction*)getSonamNumberLabelAction{
    CGPoint sonamNumberLabelPosition = [self getSonamNumberLabelNewPosition];
    SKAction *move = [SKAction moveTo:sonamNumberLabelPosition duration:0.2];
    move.timingMode = SKActionTimingEaseOut;
    return move;
}

//获取sonamNumberLabel位置
-(CGPoint)getSonamNumberLabelNewPosition{
    CGRect sonamNumberLabelRect = [_sonamNumberLabel calculateAccumulatedFrame];
    CGFloat posX = sonamNumberLabelRect.size.width / 2 + 16;
    return CGPointMake(posX, 0);
}
@end
