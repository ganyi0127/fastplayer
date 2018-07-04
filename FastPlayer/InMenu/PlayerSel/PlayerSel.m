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

@implementation PlayerSel{
    Score *_score;
    Config *_config;
    NSMutableArray<PlayerIcon*> *_playerIconList;
    SKCropNode *_cropNode;
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
}

-(void)createContents{
    _cropNode = [SKCropNode node];
    
    _playerIconList = [NSMutableArray array];
    for (NSInteger i=0; i<5; i++) {
        PlayerIcon *playerIcon = [PlayerIcon nodeWithPlayerType:i];
        [_playerIconList addObject:playerIcon];
        [_cropNode addChild:playerIcon];
    }
    
    //添加遮罩    
    SKSpriteNode *maskNode = [SKSpriteNode spriteNodeWithColor:SKColor.whiteColor size:CGSizeMake(_config.screenSize.width * 0.7, 200)];
    _cropNode.maskNode = maskNode;
    [self addChild:_cropNode];    
}

- (BOOL)selectOffsetIndex:(NSInteger)offsetIndex{
    NSInteger tmp = _index + offsetIndex;
    if (tmp < 0) {
        return false;
    }
    _index += offsetIndex;
    
    
    
    //存储选择
    
    return YES;
}
@end
