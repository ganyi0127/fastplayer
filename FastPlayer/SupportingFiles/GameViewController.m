//
//  GameViewController.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/1.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import <LeisureGame/LeisureGame.h>

@interface GameViewController()<GameModelDelegate>
@end


@implementation GameViewController{
    BOOL _isMyModelType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GameModel *model=[[GameModel alloc]init];
    model.ModelDelegate=self;
    //参数解释 gametype 如果不是Leisure time 就需要你自己去写UIwebview 加载界面
    //MyGame 为你的游戏链接
    //isLand==1 你的游戏强制横屏 不等于1 则不强制横屏
    [model getModel:@{@"gametype":@"Leisure time2",@"MyGame":@"https://www.baidu.com",@"isLand":@2}];
}

- (void)GameStateStr:(NSString *)States{
    if ([States containsString:@"授权成功"]) {        
        [self loadGame]; 
    }
}

-(void)loadGame{    
    _isMyModelType = YES;
    
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;    
    [skView presentScene:scene];  
    
    [skView setShowsNodeCount:YES];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (_isMyModelType) {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
