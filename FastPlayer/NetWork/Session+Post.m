//
//  Session+Post.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/4.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Session+Post.h"

@implementation Session (Post)

+ (void)getListCompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    [self postWithParams:NULL withAction:@"list" withCompleteBlock:completeBlock];
}

+ (void)addDocumentWithUUID:(NSString *)uuid withUsername:(NSString *)username withScore:(NSInteger)score withCompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    NSDictionary *params = @{@"uuid":uuid,@"username":username,@"score":[NSNumber numberWithInteger:score]};
    [self postWithParams:params withAction:@"addscore" withCompleteBlock:completeBlock];
}

+ (void)updateFieldWithUUID:(NSString *)uuid withUsername:(NSString *)username withCompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    NSDictionary *params = @{@"uuid":uuid,@"username":username};
    [self postWithParams:params withAction:@"updateusername" withCompleteBlock:completeBlock];
}

+ (void)getRankingWithUUID:(NSString *)uuid withCompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    NSDictionary *params = @{@"uuid":uuid};
    [self postWithParams:params withAction:@"getranking" withCompleteBlock:completeBlock];
}
@end
