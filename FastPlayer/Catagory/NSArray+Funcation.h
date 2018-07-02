//
//  NSArray+Funcation.h
//  ddz
//
//  Created by bi ying on 2018/6/13.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<__covariant ObjectType> (Funcation)
- (NSArray *)sonam_mapUsingBlock:(id (^)(ObjectType obj, NSUInteger idx))block;
- (NSArray *)sonam_filter:(BOOL (^)(ObjectType obj))block;
@end
