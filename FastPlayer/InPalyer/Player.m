//
//  Player.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Player.h"
#import "GroundNet.h"
#import "Ground.h"
#import "GameScene.h"

@implementation Player{
    GroundNet *_groundNet;
    
    NSMutableArray<SKTexture*> *_textures;
    
    SKSpriteNode *_leftJump;
    SKSpriteNode *_rightJump;
}

+ (Player *)nodeWithType:(PlayerType)type{
    return [[self alloc] initWithType:type];
}

- (instancetype)initWithType:(PlayerType)type 
{
    _type = type;
    SKTexture *firstTexture = [self updateTexturesWithType:_type];    
    self = [super initWithTexture:firstTexture];
    if (self) {
        [self config];
        [self createContents];
    }
    return self;
}



-(void)config{
    _groundNet = [GroundNet shareInstance];
    
    _isTwins = NO;
    _canMove = YES;
    
    if (_type == PlayerTypeTwins) {
        _jumpCount = 1;
    }else {        
        _jumpCount = 0;
    }
    
    [self moveToColumnOffset:0 withCompletion:NULL];
    
    [self setUserInteractionEnabled:YES];
    
    //播放动画
    [self animTextures];
    
}

-(void)createContents{
    //添加跳跃按钮
    SKTexture *leftTexture = [SKTexture textureWithImageNamed:@"jump_left"];
    SKTexture *rightTexture = [SKTexture textureWithImageNamed:@"jump_right"];
    
    CGSize groundSize = [_groundNet getGroundSize];
    
    _leftJump = [SKSpriteNode spriteNodeWithTexture:leftTexture size:[_groundNet getGroundSize]];
    _leftJump.position = CGPointMake(-groundSize.width, 0);
    _leftJump.name = @"left";
    [self addChild:_leftJump];
    
    _rightJump = [SKSpriteNode spriteNodeWithTexture:rightTexture size:[_groundNet getGroundSize]];
    _rightJump.position = CGPointMake(groundSize.width, 0);
    _rightJump.name = @"right";
    [self addChild:_rightJump];
    
    //初始化增加一个count
    [self addJumpCount:1];
}

- (void)addJumpCount:(NSInteger)subCount{
    _jumpCount += subCount;
    if (_jumpCount < 0) {
        _jumpCount = 0;        
    }
    
    //设置按钮
    _leftJump.hidden = _jumpCount == 0;
    _rightJump.hidden = _jumpCount == 0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_jumpCount == 0) {
        return;
    }
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if ([node.name isEqualToString:@"left"]) {
            [self jumpBy:YES];
        }else if ([node.name isEqualToString:@"right"]){
            [self jumpBy:NO];
        }
    }
}

//初始化贴图
-(SKTexture*)updateTexturesWithType:(PlayerType)type{
    NSString *textureName = @"";
    NSInteger count = 2;
    switch (type) {
        case PlayerTypeNormal:
            textureName = @"player_normal_";
            break;
        case PlayerTypeTimer:
            textureName = @"player_timer_";
            break;
        case PlayerTypeTwins:
            textureName = @"player_twins_";
            break;
        case PlayerTypeGolder:
            textureName = @"player_golder_";
            break;
        default:
            textureName = @"player_trickster_";
            count = 3;
            break;
    }
    
    if (_textures) {
        [_textures removeAllObjects];
    }else{        
        _textures = [NSMutableArray array];
    }
    for (NSInteger i=0; i<count; i++) {
        NSString *name = [NSString stringWithFormat:@"%@%ld",textureName,i];
        SKTexture *texture = [SKTexture textureWithImageNamed:name];
        [_textures addObject:texture];
    }
    
    return [_textures firstObject];
}

- (void)changeType:(PlayerType)playerType{
    if (_type == playerType) {
        return;
    }
    
    _type = playerType;
    
    self.texture = [self updateTexturesWithType:_type];
    
    //播放动画
    [self animTextures];
}

//播放贴图动画
-(void)animTextures{
    
    SKAction *anim = [SKAction animateWithTextures:_textures timePerFrame:0.1 resize:NO restore:NO];
    SKAction *forever = [SKAction repeatActionForever:anim];
    [self runAction:forever];
}

//左右跳跃
-(void)jumpBy:(BOOL)left{
    //播放音效
    SKAction *sound = [SKAction playSoundFileNamed:@"sound/DM-CGS-47" waitForCompletion:NO];
    [self runAction:sound];
    
    [self addJumpCount:-1];
    
    NSInteger newColumnIndex = _groundNet.playerColumnIndex + (left ? -1 : 1);
    NSInteger rowIndex = _isTwins ? _groundNet.playerTwinsRowIndex : _groundNet.playerRowIndex;
    _groundNet.playerColumnIndex = newColumnIndex;

    if (_isTwins) {
        _groundNet.playerRowIndex = rowIndex;
    }else{
        _groundNet.playerTwinsRowIndex = rowIndex;
    }
    
    CGPoint newPosition = [_groundNet getGroundPositionByColumnIndex:newColumnIndex byRowIndex:rowIndex];
    
    _canMove = NO;
    SKAction *move = [SKAction moveTo:newPosition duration:0.1];
    move.timingMode = SKActionTimingEaseIn;
    
    GameScene *scene = (GameScene*)self.parent;
    
    [self runAction:move completion:^{
        self->_canMove = YES;       
        
        [scene checkCollisionWithColumnIndex:newColumnIndex withRowIndex:rowIndex];
    }];
    
    if (_twins) {
        [_twins jumpBy:left];
    }
}

- (void)moveToColumnOffset:(NSInteger)columnOffset withCompletion:(void (^)(NSInteger, NSInteger))completion{
    _canMove = NO; 
    
    
    NSInteger newColumnIndex = _groundNet.playerColumnIndex + columnOffset;
    NSInteger newRowIndex = _isTwins ? _groundNet.playerTwinsRowIndex : _groundNet.playerRowIndex;
    _groundNet.playerColumnIndex = newColumnIndex;
    if (_isTwins) {        
        _groundNet.playerRowIndex = newRowIndex;
    }else{
        _groundNet.playerTwinsRowIndex = newRowIndex;
    }
    CGPoint newPosition = [_groundNet getGroundPositionByColumnIndex:newColumnIndex byRowIndex:newRowIndex];    
    
    SKAction *move = [SKAction moveTo:newPosition duration:0.2];
    move.timingMode = SKActionTimingEaseOut;
    [self runAction:move completion:^{
        self->_canMove = YES;
        
        if (completion) {            
            completion(newColumnIndex, newRowIndex);
        }
    }];
    
    if (_twins) {
        [_twins moveToColumnOffset:columnOffset withCompletion:completion];
    }
}
@end
