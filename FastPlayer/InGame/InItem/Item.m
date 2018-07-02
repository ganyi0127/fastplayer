//
//  Item.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/2.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Item.h"

@implementation Item

+ (Item *)nodeWithGroundType:(GroundType)groundType{
    return [[self alloc] initWithGroundType:groundType];
}

- (instancetype)initWithGroundType:(GroundType)groundType
{
    self = [super init];
    if (self) {
        _type = groundType;
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    
}

-(void)createContents{
    //处理idle动画
    switch (_type) {
        case GroundTypeTrap:                    //陷阱
            //禁止
            break;
        case GroundTypeTimer:                   //时间
            //播放走秒动画
            break;
        case GroundTypeTwins:                   //分身
            //播放闪烁动画
            break;
        case GroundTypeGolder:                  //金币
            //播放闪耀动画
            break;
        case GroundTypePlayer:                  //敌人
            //播放idle动画
            break;
        default:                                //无
            break;
    }
}

- (void)clearWithPlayerType:(PlayerType)playerType withCompleteBlock:(void (^)(BOOL))completeBlock{
    switch (_type) {
        case GroundTypeTrap:                    //陷阱
            //播放动画 然后消失
            if (playerType == PlayerTypeTrickster) {
                
            }else{
                
            }
            break;
        case GroundTypeTimer:                   //时间
            //移动到时间栏 然后消失
            if (playerType == PlayerTypeTimer) {
                
            }else{
                
            }
            break;
        case GroundTypeTwins:                   //分身
            //播放动画 然后消失
            if (playerType == PlayerTypeTwins) {
                
            }else{
                
            }
            break;
        case GroundTypeGolder:                  //金币
            //移动到金币栏 然后消失
            if (playerType == PlayerTypeGolder) {
                
            }else{
                
            }
            break;
        case GroundTypePlayer:                  //敌人
            //播放暴走动画 不做处理
            
            break;
        default:                                //无
            break;
    }
}
@end
