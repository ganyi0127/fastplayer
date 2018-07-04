//
//  Session.h
//  FastPlayer
//
//  Created by bi ying on 2018/7/4.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject

+(void)postWithParams:(NSDictionary*)params withAction:(NSString*)action withCompleteBlock:(void (^)(BOOL successed, NSDictionary *result))completeBlock;
@end
