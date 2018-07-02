//
//  GroundNet.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface GroundNet : NSObject

@property (assign, nonatomic, readonly) NSInteger columnCount;
@property (assign, nonatomic, readonly) NSInteger rowCount;
@property (assign, nonatomic) NSInteger playerColumnIndex;
@property (assign, nonatomic) NSInteger playerRowIndex;
@property (assign, nonatomic) NSInteger playerTwinsRowIndex;
@property (strong, nonatomic, readonly) NSMutableArray<NSMutableArray<NSValue*>*> *positionsList;

+(instancetype) shareInstance; 
+(GroundNet*)groundNet;
+(GroundNet*)groundNetWithColumnCount:(NSInteger)columnCount withRowCount:(NSInteger)rowCount;

-(GroundNet*)initWithColumnCount:(NSInteger)columnCount withRowCount:(NSInteger)rowCount;


///判断是否可移动
-(BOOL)canPlayerMoveBySteps:(NSInteger)stepsWillTake;

///获取ground尺寸
-(CGSize)getGroundSize;

///根据行列获取ground位置
-(CGPoint)getGroundPositionByColumnIndex:(NSInteger)columnIndex byRowIndex:(NSInteger)rowIndex;
@end
