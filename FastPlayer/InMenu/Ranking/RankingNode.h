//
//  RankingNode.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/8.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface RankingNode : SKSpriteNode

@property (assign, nonatomic, readonly) CGSize visableSize;

-(void)updateDataByNew:(BOOL)isNew WithCompleteBlock:(void (^)(BOOL success, NSString *message))completeBlock;

@end
