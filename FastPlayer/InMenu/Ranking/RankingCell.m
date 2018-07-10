//
//  RankingCell.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/8.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "RankingCell.h"
#import "Star.h"
#import "Config.h"

@implementation RankingCell{
    Config *_config;
    
    Star *_star;
    SKLabelNode *_rankingLabel;
    SKLabelNode *_nameLabel;
    SKLabelNode *_scoreLabel;
    
    NSInteger _ranking;
    NSInteger _score;
    NSString *_username;
}

+ (RankingCell *)nodeWithRankingModel:(RankingModel *)rankingModel{
    return [[self alloc] initWithRankingModel:(RankingModel *)rankingModel];
}

- (instancetype)initWithRankingModel:(RankingModel *)rankingModel
{
    SKTexture *texture = [SKTexture textureWithImageNamed:@"ranking_cell"];
    self = [super initWithTexture:texture];
    if (self) {
        _username = rankingModel.username;
        _ranking = rankingModel.ranking;
        _score = rankingModel.score;
        
        [self config];
        [self createContent];
    }
    return self;
}

-(void)config{
    _config = [Config shareInstance];
}

-(void)createContent{
    
    //前三名显示星星
    switch (_ranking) {
        case 1:
            _star = [Star nodeWithStarType: StarTypeOne];
            [self addChild:_star];
            break;
        case 2:
            _star = [Star nodeWithStarType: StarTypeTwo];
            [self addChild:_star];
            break;
        case 3:
            _star = [Star nodeWithStarType: StarTypeThree];
            [self addChild:_star];
            break;
        default:
            break;
    }
    
    if (_star) {
        _star.position = CGPointMake(-self.size.width / 2 + _star.size.width / 2 + 16, 0);
    }
    
    //显示排名
    NSString *rankingText = [NSString stringWithFormat:@"%ld",_ranking];
    _rankingLabel = [SKLabelNode labelNodeWithText:rankingText];
    _rankingLabel.position = CGPointMake(-self.size.width / 2 + 150, 0);
    _rankingLabel.fontSize = 50;
    _rankingLabel.fontColor = SKColor.whiteColor;
    _rankingLabel.fontName = _config.globeFontName;
    [self addChild:_rankingLabel];
    
    //显示玩家名
    _nameLabel = [SKLabelNode labelNodeWithText:_username];
    _nameLabel.position = CGPointMake(0, 0);
    _nameLabel.fontSize = 50;
    _nameLabel.fontColor = SKColor.redColor;
    _nameLabel.fontName = _config.globeFontName;
    [self addChild:_nameLabel];
    
    //显示分数
    NSString *scoreText = [NSString stringWithFormat:@"%ld",_score];
    _scoreLabel = [SKLabelNode labelNodeWithText:scoreText];
    _scoreLabel.position = CGPointMake(180, 0);
    _scoreLabel.fontSize = 50;
    _scoreLabel.fontColor = SKColor.whiteColor;
    _scoreLabel.fontName = _config.globeFontName;
    [self addChild:_scoreLabel];
}
@end
