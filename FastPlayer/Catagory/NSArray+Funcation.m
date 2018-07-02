//
//  NSArray+Funcation.m
//  ddz
//
//  Created by bi ying on 2018/6/13.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "NSArray+Funcation.h"

@implementation NSArray (Funcation)
- (NSArray *)sonam_mapUsingBlock:(id (^)(id, NSUInteger))block {    
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [resultArr addObject:block(obj, idx)];
    }];
    return resultArr;
}

- (NSArray *)sonam_filter:(BOOL (^)(id))block{

    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            [array addObject:obj];
        }
    }];
    
    return array;
}
@end
