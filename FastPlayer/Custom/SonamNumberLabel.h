//
//  SonamNumberLabel.h
//  DodgeBall
//
//  Created by bi ying on 2018/6/21.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SonamNumberLabel : SKNode

@property(nonatomic,assign) NSInteger scoreNumber;
@property(assign, nonatomic) CGFloat numberScale;

+(SonamNumberLabel*)numberLabel;

-(void)clearCounter;
-(void)setScoreNumber:(NSInteger)scoreNumber;
-(void)resetNumber;
-(void)setColor: (SKColor*)color;

@end
