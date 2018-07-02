//
//  SonamNumberLabel.m
//  DodgeBall
//
//  Created by bi ying on 2018/6/21.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "SonamNumberLabel.h"

@interface SonamNumberLabel()

@end

@implementation SonamNumberLabel{
    NSArray *_textureList;
    NSMutableArray *_numberList;
    SKColor *_color;
    CGFloat _colorBlendFactor;
    CGFloat _intervalOfNumbers;
}

+ (SonamNumberLabel *)numberLabel{
    return [[SonamNumberLabel alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    _numberScale = 1;
    _color = SKColor.whiteColor;
    _colorBlendFactor = 1;
    
    _intervalOfNumbers = 10;
}

- (void)createContents{
    [self addAtlas];
    _scoreNumber = 0;
    _numberList = [NSMutableArray array];
    [self updateCount];
    
}
- (void) resetNumber{
    [self setScoreNumber:0];
}

- (void)setScoreNumber:(NSInteger)scoreNumber{
    _scoreNumber = scoreNumber;
    [self clearCounter];
    [self updateCount];
}

- (void) clearCounter
{
    for (SKSpriteNode *number in _numberList) {
        [number removeFromParent];
    }
    [_numberList removeAllObjects];
}

- (void)setColor:(UIColor *)color{
    for (SKSpriteNode *number in _numberList) {
        number.color = color;
        number.colorBlendFactor = _colorBlendFactor;
    }
}

//***************************------  atlas texture ------*******************************
#pragma mark 添加贴图
- (void)addAtlas{
    NSMutableArray *numberArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString *textureName = [NSString stringWithFormat:@"%d",i]; 

        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [numberArray addObject:texture];
    }
    _textureList = [[NSArray alloc] initWithArray:numberArray];
}

- (void) addNumber:(NSInteger)digit atIndex:(int)index {
    
    NSString * numberName =[NSString stringWithFormat:@"%d", (int) digit];
    SKSpriteNode * number = [SKSpriteNode spriteNodeWithTexture: [_textureList objectAtIndex:digit]];
    number.color = _color;
    number.colorBlendFactor = _colorBlendFactor;
    number.anchorPoint = CGPointMake(0.5, 0);
    number.name = numberName;
    [number setScale:_numberScale];
    [self addChild:number];
    [number runAction:[self getShowAction]];
    [_numberList insertObject:number atIndex:index];
}

#pragma mark 更新显示数字
- (void) updateCount{
    NSInteger displayNumber = _scoreNumber;
    NSInteger digit;
    int figure = 0;
    
    if (displayNumber == 0) {
        [self addNumber:0 atIndex:0];
        return;
    }
    
    while (displayNumber) {
        digit = displayNumber % 10;
        displayNumber /= 10;
        
        NSString *numberName = [NSString stringWithFormat:@"number-%d",(int)digit];
        
        if (figure < [_numberList count] && [_numberList objectAtIndex:figure] != [NSNull null]) {
            
            SKSpriteNode *oldNumberNode = [_numberList objectAtIndex:figure];
            if ([numberName isEqualToString:oldNumberNode.name]) {
                
                figure ++;
                continue;
            }else{
                [oldNumberNode removeFromParent];
                [_numberList removeObject:oldNumberNode];
            }
        }
        [self addNumber:digit atIndex:figure];
        figure++;
    }
    [self updateNumbersPosition];
}

- (SKAction *) getShowAction
{
    SKAction * act = [SKAction group:@[
                                       [SKAction scaleBy:1.1
                                                duration:0.0],
                                       [SKAction scaleBy:1.1
                                                duration:0.2]
                                       ]];
    return act;
}
- (void) updateNumbersPosition {
    NSMutableArray *perNumber = [NSMutableArray array];
    CGFloat x = 0.0;
    for (SKSpriteNode * number in _numberList) {
        CGFloat y = number.position.y;
        number.position = CGPointMake(x, y);
        for (SKSpriteNode * number in perNumber) {
            number.position = CGPointMake(number.position.x + number.size.width/2 + _intervalOfNumbers, y);
        }
        x -= number.size.width/2;
        [perNumber addObject:number];
    }
}
@end
