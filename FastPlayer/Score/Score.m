//
//  Score.m
//  Doudizhu
//
//  Created by bi ying on 2018/6/12.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Score.h"

@implementation Score{
    NSString *_fileName;
    NSString *_filePath;
    NSString *_scoreKey;
    NSString *_coinsKey;
    NSString *_playerTypeKey;
}

static Score *_instance = nil;  

+(instancetype) shareInstance  {  
    static dispatch_once_t onceToken ;  
    dispatch_once(&onceToken, ^{  
        _instance = [[self alloc] init] ;  
    });  
    
    return _instance ;  
}  

- (id)init {
    if (self = [super init]) {
        [self config];
        [self createContents];
    }    
    return self;
}

- (void)config{
    _scoreKey = @"score";
    _coinsKey = @"coins";
    _playerTypeKey = @"playertype";
    
    _fileName = @"Score";
    NSString *resourceStr = [NSString stringWithFormat:@"/%@", _fileName];
    _filePath = [NSBundle.mainBundle pathForResource:resourceStr ofType:@"plist"];
}

- (void)createContents{
    
}

- (NSString *)documentPath{
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths.firstObject;
    return [NSString stringWithFormat:@"%@/%@.plist", path, _fileName];
}

- (NSMutableDictionary *)readDocument{
    NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL fileExist = [fileManger fileExistsAtPath:[self documentPath]];
    NSMutableDictionary *dic;
    if (fileExist) {
        dic = [NSMutableDictionary dictionaryWithContentsOfFile:[self documentPath]];
    }else {
        dic = [NSMutableDictionary dictionaryWithContentsOfFile:_filePath];
    }
    return dic;
}

#pragma mark 积分
//判断是否能设置积分（是否小于0越界）
- (BOOL)canAddScore:(NSInteger)subScore{
    NSDictionary *dic = [self readDocument];
    NSInteger score = ((NSNumber*)[dic objectForKey:_scoreKey]).integerValue + subScore;
    return score >= 0;
}

- (NSInteger)getScore{
    NSDictionary *dic = [self readDocument];
    return ((NSNumber *)[dic objectForKey: _scoreKey]).integerValue;
}

- (NSInteger)setScore:(NSInteger)score{  
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self readDocument]];
    NSNumber *object = [NSNumber numberWithInteger:score];
    [dic setObject:object forKey:_scoreKey];
    [dic writeToFile:[self documentPath] atomically:YES];
    return score;
}

- (NSInteger)addScore:(NSInteger)subScore{
    NSMutableDictionary *dic = [self readDocument];
    NSInteger score;
    if ((NSInteger)[dic valueForKey:_scoreKey] + subScore < 0) {
        score = 0;
    }else{        
        score = (NSInteger)[dic valueForKey:_scoreKey] + subScore;
    }
    
    [dic setObject:[NSNumber numberWithInteger:score] forKey:_scoreKey];
    [dic writeToFile:[self documentPath] atomically:YES];
    return score;
}

#pragma mark 金币
//判断是否能设置积分（是否小于0越界）
- (BOOL)canAddCoins:(NSInteger)subCoins{
    NSDictionary *dic = [self readDocument];
    NSInteger coins = ((NSNumber*)[dic objectForKey:_coinsKey]).integerValue + subCoins;
    return coins >= 0;
}

- (NSInteger)getCoins{
    NSDictionary *dic = [self readDocument];
    return ((NSNumber *)[dic objectForKey: _coinsKey]).integerValue;
}

- (NSInteger)setCoins:(NSInteger)coins{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self readDocument]];
    NSNumber *object = [NSNumber numberWithInteger:coins];
    [dic setObject:object forKey:_coinsKey];
    [dic writeToFile:[self documentPath] atomically:YES];
    return coins;
}

- (NSInteger)addCoins:(NSInteger)subCoins{
    NSMutableDictionary *dic = [self readDocument];
    NSInteger coins;
    if ((NSInteger)[dic valueForKey:_coinsKey] + subCoins < 0) {
        coins = 0;
    }else{        
        coins = (NSInteger)[dic valueForKey:_coinsKey] + subCoins;
    }
    
    [dic setObject:[NSNumber numberWithInteger:coins] forKey:_coinsKey];
    [dic writeToFile:[self documentPath] atomically:YES];
    return coins;
}

#pragma mark 角色类型
- (PlayerType)getPlayerType{
    NSDictionary *dic = [self readDocument];
    return ((NSNumber *)[dic objectForKey: _playerTypeKey]).integerValue;
}

- (PlayerType)setPlayerType:(PlayerType)playerType{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self readDocument]];
    NSNumber *object = [NSNumber numberWithInteger:playerType];
    [dic setObject:object forKey:_playerTypeKey];
    [dic writeToFile:[self documentPath] atomically:YES];
    return playerType;
}
@end
