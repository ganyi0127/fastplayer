//
//  Session+Post.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/4.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Session.h"

@interface Session (Post)

///获取排行榜
+(void)getListCompleteBlock:(void (^)(BOOL successed, NSDictionary *result))completeBlock;

///上传分数(只有第一次添加username才有效)
+(void)addDocumentWithUUID:(NSString*)uuid withUsername:(NSString*)username withScore:(NSInteger)score withCompleteBlock:(void (^)(BOOL successed, NSDictionary *result))completeBlock;

///修改用户名
+(void)updateFieldWithUUID:(NSString*)uuid withUsername:(NSString*)username withCompleteBlock:(void (^)(BOOL successed, NSDictionary *result))completeBlock;

///获取排名
+(void)getRankingWithUUID:(NSString*)uuid withCompleteBlock:(void (^)(BOOL successed, NSDictionary *result))completeBlock;
@end
