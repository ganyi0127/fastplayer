//
//  GroundNode.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Ground.h"

@interface GroundNode : SKNode

///根据行列获取对应ground
-(Ground*)getGroundByColumnIndex:(NSInteger)columnIndex byRowIndex:(NSInteger)rowIndex;

///移动步数
-(void)takeStep:(NSInteger)count;

///重置
-(void)reset;
@end
