//
//  PlayerSel.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/3.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "PlayerSel.h"
#import "PlayerIcon.h"
#import "Score.h"
#import "Config.h"
#import "SKNode+Funcation.h"

@implementation PlayerSel{
    Score *_score;
    Config *_config;
    NSMutableArray<PlayerIcon*> *_playerIconList;
    SKCropNode *_cropNode;
    NSInteger _playerIconCount;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    _config = [Config shareInstance];
    _score = [Score shareInstance];
    
    _index = [_score getPlayerType]; 
    
    _playerIconCount = 5;
}

-(void)createContents{
    _cropNode = [SKCropNode node];
    _cropNode.position = CGPointZero;
    
    _playerIconList = [NSMutableArray array];
    for (NSInteger i=0; i<_playerIconCount; i++) {
        PlayerIcon *playerIcon = [PlayerIcon nodeWithPlayerType:i];
        [_playerIconList addObject:playerIcon];
        CGFloat x = [self getXPositionFromIndex:i];
        playerIcon.position = CGPointMake(x, 0);
        
        CGFloat scale = [self getScaleFromIndex:i];
        [playerIcon setScale:scale];

        CGFloat zPos = [self getZPositionFromIndex:i];
        playerIcon.zPosition = zPos;
        [_cropNode addChild:playerIcon];
    }
    
    //添加遮罩    
    SKSpriteNode *maskNode = [SKSpriteNode spriteNodeWithColor:SKColor.whiteColor size:CGSizeMake(_config.screenRight * 2 * 0.8, 400)];
    maskNode.position = CGPointZero;
    _cropNode.maskNode = maskNode;
    [self addChild:_cropNode];    
}

- (BOOL)selectOffsetIndex:(NSInteger)offsetIndex{
    //播放音效
    SKAction *sound = [SKAction playSoundFileNamed:@"sound/DM-CGS-03" waitForCompletion:NO];
    [self runAction:sound];
    
    
    NSInteger tmp = _index + offsetIndex;
    if (tmp < 0) {
        return NO;
    }else if (tmp > 4){
        return NO;
    }
    
    _index += offsetIndex;
        
    //提示
    PlayerType playerType = _index;
    switch (playerType) {
        case PlayerTypeNormal:
            
            break;
        case PlayerTypeTimer:
            [self showNotif:@"获取时间翻倍"];
            break;
        case PlayerTypeTwins:
            [self showNotif:@"自带跳跃次数"];
            break;
        case PlayerTypeGolder:
            [self showNotif:@"收获金币翻倍"];
            break;
        case PlayerTypeTrickster:
            [self showNotif:@"可飞跃障碍"];
            break;
        default:
            [self showNotif:@"我是小飞侠"];
            break;
    }
    
    //重新排列
    for (NSInteger i=0; i<_playerIconCount; i++) {
        PlayerIcon *playerIcon = [_playerIconList objectAtIndex:i];

        CGFloat x = [self getXPositionFromIndex:i];
        CGFloat scaleX = [self getScaleFromIndex:i];
        
        SKAction *move = [SKAction moveToX:x duration:0.3];
        move.timingMode = SKActionTimingEaseOut;
        SKAction *scale = [SKAction scaleTo:scaleX duration:0.3];
        scale.timingMode = SKActionTimingEaseOut;
        
        SKAction *group = [SKAction group:@[move, scale]];
        [playerIcon runAction:group];
        
        CGFloat zPos = [self getZPositionFromIndex:i];
        playerIcon.zPosition = zPos;
    }
    
    
    //存储选择
    if ([_score isUnlockWithPlayer:_index]) {        
        [_score setPlayerType:_index];
    }
    
    return YES;
}

//根据选择获取playericonX轴位置
-(CGFloat)getXPositionFromIndex:(NSInteger)index{
    CGFloat tmp = 1;
    CGFloat abs = labs(index - _index);
    if (abs == 1) {
        tmp = 1;
    }else if (abs == 2){
        tmp = 0.8;
    }else if (abs == 3){
        tmp = 0.5;
    }else if (abs == 4){
        tmp = 0.3;
    }
    return ((CGFloat)index - (CGFloat)(_playerIconCount / 2 + _index - 2)) * 200 * tmp;
}

//根据选择获取playericon缩放尺寸
-(CGFloat)getScaleFromIndex:(NSInteger)index{
    return 1 - labs(_index - index) * 0.25;
}

//根据选择获取playericonZ轴位置
-(CGFloat)getZPositionFromIndex:(NSInteger)index{
    return 4 - labs(index - _index);
}
@end
