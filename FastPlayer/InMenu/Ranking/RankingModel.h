//
//  RankingModel.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/8.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankingModel : NSObject

@property (strong, nonatomic) NSString *username;
@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger ranking;
@end
