//
//  RankingCell.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/8.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RankingModel.h"

@interface RankingCell : SKSpriteNode

+(RankingCell*)nodeWithRankingModel:(RankingModel*)rankingModel;

@end
