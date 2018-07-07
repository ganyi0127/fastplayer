//
//  Session+Post.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/4.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Session+Post.h"

@implementation Session (Post)

/** 
 *  获取排行榜
 */
+ (void)getListCompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    [self postWithParams:NULL withAction:@"list" withCompleteBlock:completeBlock];
}

/** 
 *  保存分数 
 *  @param uuid 设备唯一标示
 *  @param username 玩家名 #仅第一次插入生效,本地保存一份吧
 *  @param score 分数
 */
+ (void)addDocumentWithUUID:(NSString *)uuid withUsername:(NSString *)username withScore:(NSInteger)score withCompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    NSDictionary *params = @{@"uuid":uuid,@"username":username,@"score":[NSNumber numberWithInteger:score]};
    [self postWithParams:params withAction:@"addscore" withCompleteBlock:completeBlock];
}

/** 更新玩家姓名
 *  @param uuid 设备唯一标示
 *  @param username 新玩家名
 */
+ (void)updateFieldWithUUID:(NSString *)uuid withUsername:(NSString *)username withCompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    NSDictionary *params = @{@"uuid":uuid,@"username":username};
    [self postWithParams:params withAction:@"updateusername" withCompleteBlock:completeBlock];
}

/**
 * 获取玩家排名
 * @param uuid 设备唯一标示
 */
+ (void)getRankingWithUUID:(NSString *)uuid withCompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    NSDictionary *params = @{@"uuid":uuid};
    [self postWithParams:params withAction:@"getranking" withCompleteBlock:completeBlock];
}
@end
