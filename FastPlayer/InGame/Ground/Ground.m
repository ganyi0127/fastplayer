//
//  Ground.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "Ground.h"
#import "GroundNet.h"
#import "Item.h"

@implementation Ground{
    Item *_item;
}

+ (Ground *)nodeWithGroundType:(GroundType)groundType{
    return [[self alloc] initWithGroundType:groundType];
}

- (instancetype)initWithGroundType:(GroundType)groundType
{
    NSInteger random = (NSInteger)(arc4random_uniform(5));
    NSString *textureName = [NSString stringWithFormat:@"bg_%ld", random];
    SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
    SKColor *color = [SKColor clearColor];
    CGSize size = [[GroundNet shareInstance] getGroundSize];
    
    self = [super initWithTexture:texture color:color size: size];
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
    [self createObjectWithType:_type];
}

//根据类型创建附加物品
-(void)createObjectWithType:(GroundType)type{
    //正常情况下，无需创建对应item
    if (type == GroundTypeNone) {
        return;
    }
    
    _item = [Item nodeWithGroundType:_type];
    [self addChild:_item];
}


- (void)triggerObjectByPlayerType:(PlayerType)playerType withCompletion:(void (^)(TriggerType))complection{
    switch (_type) {
        case GroundTypeTimer:            
            if (playerType==PlayerTypeTimer) {
                complection(TriggerTypeDoubleTimer);
            }else{ 
                complection(TriggerTypeTimer);
            }
            break;
        case GroundTypeTwins:
            complection(TriggerTypeTwins);
            break;
        case GroundTypeGolder:
            if (playerType==PlayerTypeGolder) {
                complection(TriggerTypeDoubleGolder);
            }else{
                complection(TriggerTypeGolder);
            }
            break;
        case GroundTypeTrap:
            if (playerType==PlayerTypeTrickster) {
                complection(TriggerTypeNone);
            }else if(playerType==PlayerTypeTwins){
                complection(TriggerTypeTwinsDead);
            }else{
                complection(TriggerTypeMainDead);
            }
            break;
        case GroundTypePlayer:
            if(playerType==PlayerTypeTwins){
                complection(TriggerTypeTwinsDead);
            }else{
                complection(TriggerTypeMainDead);
            }
            break;
        default:            
            complection(TriggerTypeNone);
            break;
    }
}
@end
