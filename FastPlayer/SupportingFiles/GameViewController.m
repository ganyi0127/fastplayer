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
    UIImageView *_imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:_imageView];
//    
//                
//    GameModel *model=[[GameModel alloc]init];
//    model.ModelDelegate=self;
//    [model getModel:@{@"gametype":@"Leisure time2",@"MyGame":@"",@"isLand":@2}];
    
    [self loadGame];
}

//- (void)GameStateStr:(NSString *)States{
//    if ([States containsString:@"授权成功"]) {   
//        [_imageView removeFromSuperview];
//        _isMyModelType = YES;
//        [self loadGame]; 
//    }
//    
//}

-(void)loadGame{    
    _isMyModelType = YES;
    
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;    
    [skView presentScene:scene];  
    
    //[skView setShowsNodeCount:YES];
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
