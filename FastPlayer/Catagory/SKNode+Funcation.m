//
//  SKNode+Funcation.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/9.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "SKNode+Funcation.h"
#import "Config.h"

@implementation SKNode (Funcation)

- (void)showNotif:(NSString *)notifString{
    //return;
    __weak SKScene *scene;
    __weak SKNode *tmpParent;
    while (!scene) {
        tmpParent = tmpParent ? tmpParent.parent : self.parent;
        if ([tmpParent isKindOfClass:[SKScene class]]) {            
            scene = tmpParent;
        }
    }
    
    SKTexture *bgTexture = [SKTexture textureWithImageNamed:@"bg_notif"];
    CGPoint originPosition = CGPointMake(0, [Config shareInstance].screenTop + bgTexture.size.height / 2);
    CGPoint targetPosition = CGPointMake(0, [Config shareInstance].screenTop - bgTexture.size.height / 2);
    
    CGFloat zPosition = 100;
    
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithTexture:bgTexture];
    bg.position = originPosition;
    bg.zPosition = zPosition;
    [scene addChild:bg];
    
    //添加label
    SKLabelNode *label = [[SKLabelNode alloc] init];
    label.fontSize = 50;
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    label.fontColor = SKColor.whiteColor;
    label.fontName = [Config shareInstance].globeFontName;
//    label.zPosition = zPosition + 1;
    label.text = notifString;
    [bg addChild:label];
    
    //动画
    SKAction *moveDown = [SKAction moveTo:targetPosition duration:0.2];
    moveDown.timingMode = SKActionTimingEaseOut;
    SKAction *wait = [SKAction waitForDuration:2];
    SKAction *moveUp = [SKAction moveTo:targetPosition duration:0.2];
    moveUp.timingMode = SKActionTimingEaseOut;
    SKAction *remove = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[moveDown,wait,moveUp,remove]];
    [bg runAction:seq];
}

@end
