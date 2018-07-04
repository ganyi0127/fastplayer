//
//  PlayerSel.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/3.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayerSel : SKNode

@property (assign, nonatomic, readonly) NSInteger index;

-(BOOL)selectOffsetIndex:(NSInteger)offsetIndex;

@end
