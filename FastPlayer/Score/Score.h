//
//  Score.h
//  Doudizhu
//
//  Created by bi ying on 2018/6/12.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface Score : NSObject

+(instancetype) shareInstance; 

///判断是否可添加积分
-(BOOL)canAddScore: (NSInteger)subScore;
///获取当前积分
- (NSInteger)getScore;
///设置当前积分
- (NSInteger)setScore: (NSInteger)score;
///修改当前积分
- (NSInteger)addScore: (NSInteger)subScore;

///判断是否可添加金币
-(BOOL)canAddCoins:(NSInteger)subCoins;
///获取当前金币
-(NSInteger)getCoins;
///设置当前金币
-(NSInteger)setCoins:(NSInteger)coins;
///修改当前金币
-(NSInteger)addCoins:(NSInteger)subCoins;
///获取价格
-(NSInteger)getPriceFromPlayerType:(PlayerType)playerType;

///获取当前选择的角色
-(PlayerType)getPlayerType;
///设置当前选择的角色
-(PlayerType)setPlayerType:(PlayerType)playerType;

///判断角色是否已解锁
-(BOOL)isUnlockWithPlayer:(PlayerType)playerType;
///解锁玩家
-(BOOL)unlockPlayer:(PlayerType)playerType;


///获取玩家名
-(NSString*)getUsername;
///更新玩家名
-(BOOL)setUsername:(NSString *)username;
@end
