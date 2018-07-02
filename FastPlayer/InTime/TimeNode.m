//
//  TimeNode.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/2.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "TimeNode.h"
#import "Config.h"

@implementation TimeNode{
    Config *_config;
    
    SKSpriteNode *_mainNode;
    SKSpriteNode *_maskNode;
    
    NSTimer *_timer;
    
    BOOL _isCount;
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

- (void)dealloc
{
    [_timer invalidate];
    _timer = NULL;
}

-(void)config{
    _config = [Config shareInstance];
    
    _maxTime = 30;
    _curTime = _maxTime;
    _isCount = YES;
    
    self.position = CGPointMake(0, _config.screenTop - 200);
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeLoop) userInfo:NULL repeats:YES];
}

-(void)createContents{
    SKTexture *mainTexture = [SKTexture textureWithImageNamed:@""];
    _mainNode = [SKSpriteNode spriteNodeWithTexture:mainTexture];    
    
    _maskNode = [SKSpriteNode spriteNodeWithTexture:mainTexture];
    _maskNode.anchorPoint = CGPointMake(0, 0.5);
    _maskNode.position = CGPointMake(-_maskNode.size.width / 2, 0);
    
    SKCropNode *cropNode = [SKCropNode node];
    cropNode.maskNode = _maskNode;
    [cropNode addChild:_mainNode];
    [self addChild:cropNode];
    
    //开始计时
    [self startCount:!_isCount];
}

///循环调用
-(void)timeLoop{
    _curTime--;

    [self updateMask];
    
    //回调
    [self callBack];
}

//修改遮罩
-(void)updateMask{    
    CGFloat rate = (CGFloat)_curTime / (CGFloat)_maxTime;
    SKAction *scaleX = [SKAction scaleXTo:rate duration:0.5];
    scaleX.timingMode = SKActionTimingEaseOut;
    [_maskNode runAction:scaleX];
}

//回调
-(void)callBack{    
    if (_completeBlock) {        
        _completeBlock(_curTime == 0, _curTime);
    }
    
    if (_curTime == 0) {
        [self startCount:NO];
    }else{
        [self startCount:YES];
    }
}

- (void)setTime:(NSInteger)time{
    _curTime = time;
    
    if (_maxTime < _curTime) {
        _maxTime = _curTime;
    }else if (_curTime <= 0){
        _curTime = 0;
    }
    
    [self updateMask];
    [self callBack];
}

- (void)setMaxTime:(NSInteger)maxTime{
    [self updateMask];
    _maxTime = maxTime;
}

- (void)addTime:(NSInteger)subTime{
    _curTime += subTime;
    if (_maxTime < _curTime) {
        _maxTime = _curTime;
    }else if (_curTime <= 0){
        _curTime = 0;
    }
   
    [self updateMask];
    [self callBack];
}

- (void)reset{
    _curTime = _maxTime;
    
    [self callBack];
}

//开启与关闭
- (void)startCount:(BOOL)flag{
    if (_isCount && !flag) {
        _isCount = NO;
        [_timer setFireDate:[NSDate distantFuture]];
    }else if (!_isCount && flag){        
        _isCount = YES;
        [_timer setFireDate:[NSDate distantPast]];
    }
}
@end