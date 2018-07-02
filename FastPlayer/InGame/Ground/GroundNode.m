//
//  GroundNode.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "GroundNode.h"
#import "GroundNet.h"
#import "Ground.h"
#import "Config.h"

@implementation GroundNode{
    Config *_config;
    GroundNet *_groundNet;
    
    //存储地面贴图
    NSMutableArray<NSMutableArray<Ground*>*> *_groundsList;
    
    //存储groundtype概率
    NSInteger _percentOfGroundTypeNone;
    NSInteger _percentOfGroundTypeTimer;
    NSInteger _percentOfGroundTypeTwins;
    NSInteger _percentOfGroundTypeGolder;
    NSInteger _percentOfGroundTypeTrap;
    NSInteger _percentOfGroundTypePlayer;
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
    _groundNet = [GroundNet shareInstance];
    
    _percentOfGroundTypeNone = 60;
    _percentOfGroundTypeTimer = 2;
    _percentOfGroundTypeTwins = 4;
    _percentOfGroundTypeGolder = 10;
    _percentOfGroundTypeTrap = 4;
    _percentOfGroundTypePlayer = 20;
    
    _groundsList = [NSMutableArray array];
}

-(void)createContents{
    [self checkGrounds];
}

- (void)takeStep:(NSInteger)count{
    
    //移除
    [self clearGroundsList];
    
    //移动grounds
    for (NSInteger rowIndex=0; rowIndex<_groundsList.count; rowIndex++) {
        NSMutableArray<Ground*> *grounds = [_groundsList objectAtIndex:rowIndex];
        for (NSInteger columnIndex=0; columnIndex<grounds.count; columnIndex++) {
            Ground *ground = [grounds objectAtIndex:columnIndex];
            SKAction *move = [self getActionByColumnIndex:columnIndex byRowIndex:rowIndex - 1 + count];
            [ground runAction:move];
        }
    }
    
    
    [self checkGrounds];    
}

- (Ground *)getGroundByColumnIndex:(NSInteger)columnIndex byRowIndex:(NSInteger)rowIndex{
    return [[_groundsList objectAtIndex:rowIndex] objectAtIndex:columnIndex];
}

//判断是否需要移除ground(移除屏幕外的情况)
-(void)clearGroundsList{
    for (NSInteger rowIndex=0; rowIndex<_groundsList.count; rowIndex++) {
        NSMutableArray<Ground*> *grounds = [_groundsList objectAtIndex:rowIndex];
        Ground *firstGround = [grounds firstObject];
        if (firstGround.position.y < _config.screenBottom) {
            for (Ground *ground in grounds) {
                [ground removeFromParent];
            }
            [_groundsList removeObjectAtIndex:rowIndex];
        }
    }
}

//根据位置获取移动动画
-(SKAction*)getActionByColumnIndex:(NSInteger)columnIndex byRowIndex:(NSInteger)rowIndex{
    CGPoint position = [_groundNet getGroundPositionByColumnIndex:columnIndex byRowIndex:rowIndex];
    NSTimeInterval duration = 0.2;
    SKAction *move = [SKAction moveTo:position duration:duration];
    move.timingMode = SKActionTimingEaseOut;
    return move;
}

//判断是否需要新建ground
-(void)checkGrounds{
    while (_groundsList.count < _groundNet.rowCount) {
        [self createNewGrounds];
    }
}

//新建grounds
-(void)createNewGrounds{
    NSMutableArray<Ground*> *groundList = [NSMutableArray array];
    
    //获取当前row
    NSInteger curRow = _groundsList.count;
    
    for (int i=0; i<_groundNet.columnCount; i++) {
        GroundType groundType = _groundsList.count < 6 ? GroundTypeNone : [self getRandomGroundType];
        Ground *ground = [Ground nodeWithGroundType:groundType];
        ground.position = [_groundNet getGroundPositionByColumnIndex:i byRowIndex:curRow];
        [groundList addObject:ground];
        [self addChild:ground];        
    }
    
    [_groundsList addObject:groundList];
}

//随机获取groundType
-(GroundType)getRandomGroundType{
    NSInteger random = (NSInteger)(arc4random_uniform(100));
    NSArray<NSNumber *> *list = @[[NSNumber numberWithInteger:_percentOfGroundTypeNone],
                                  [NSNumber numberWithInteger:_percentOfGroundTypeTimer],
                                  [NSNumber numberWithInteger:_percentOfGroundTypeTwins],
                                  [NSNumber numberWithInteger:_percentOfGroundTypeGolder],
                                  [NSNumber numberWithInteger:_percentOfGroundTypeTrap],
                                  [NSNumber numberWithInteger:_percentOfGroundTypePlayer]];
    
    GroundType randomGroundType = 0;
    
    for (NSInteger i=0; i<list.count; i++) {
        NSNumber *number = [list objectAtIndex:i];
        NSInteger percent = number.integerValue;
        if (random > percent) {
            random -= percent;            
        }else{
            randomGroundType = i;
            break;
        }
    }
    return randomGroundType;
}
@end
