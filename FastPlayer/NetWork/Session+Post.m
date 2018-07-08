//
//  Session+Post.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/4.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Session+Post.h"
#import <UIKit/UIKit.h>

@implementation Session (Post)


+ (NSString *)getUUID{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)getDeviceName{
    return [UIDevice currentDevice].name;
}

/** 
 *  获取排行榜
 */
+ (void)getListWithPage:(NSInteger)page CompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    NSDictionary *params = @{@"offset":[NSNumber numberWithInteger:page]};
    [self postWithParams:params withAction:@"list" withCompleteBlock:completeBlock];
}

/** 
 *  保存分数 
 *  @param username 玩家名 #仅第一次插入生效,本地保存一份吧
 *  @param score 分数
 */
+ (void)addDocumentWithUsername:(NSString *)username withScore:(NSInteger)score withCompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    NSDictionary *params = @{@"uuid":[Session getUUID],@"username":username,@"score":[NSNumber numberWithInteger:score]};
    [self postWithParams:params withAction:@"addscore" withCompleteBlock:completeBlock];
}

/** 更新玩家姓名
 *  @param username 新玩家名
 */
+ (void)updateFieldWithUsername:(NSString *)username withCompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    NSDictionary *params = @{@"uuid":[Session getUUID],@"username":username};
    [self postWithParams:params withAction:@"updateusername" withCompleteBlock:completeBlock];
}

/**
 * 获取玩家排名
 */
+ (void)getRankingWithCompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    NSDictionary *params = @{@"uuid":[Session getUUID]};
    [self postWithParams:params withAction:@"getranking" withCompleteBlock:completeBlock];
}
@end
