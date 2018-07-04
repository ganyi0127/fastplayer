//
//  Session.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/4.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Session.h"

#define Host @"http://localhost:8082"

@implementation Session

+ (void)postWithParams:(NSDictionary *)params withAction:(NSString *)action withCompleteBlock:(void (^)(BOOL, NSDictionary *))completeBlock{
    
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];

    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",Host,action];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];

    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = requestData;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != NULL) {
            NSLog(@"response数据处理错误: %@", error);
        }
        
        NSError *resultError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&resultError];
        
        NSLog(@"result:%@",result);
        
        NSInteger code = ((NSNumber *)[result objectForKey:@"code"]).integerValue;
        dispatch_async(dispatch_get_main_queue(), ^{
            completeBlock(code==200,result);
        });
    }];
    
    [task resume];
}
@end
