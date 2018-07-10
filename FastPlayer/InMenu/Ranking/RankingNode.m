//
//  RankingNode.m
//  FastPlayer
//
//  Created by bi ying on 2018/7/8.
//  Copyright © 2018年 sonam. All rights reserved.
//

#import "RankingNode.h"
#import "RankingModel.h"
#import "RankingCell.h"
#import "Session+Post.h"
#import "Config.h"
#import "SKNode+Funcation.h"

@implementation RankingNode{
    Config *_config;
    
    //存储当前页
    NSInteger _page;    
    
    //cell高度
    CGFloat _cellHeight;
    
    //偏移距离
    CGFloat _offset;
    
    //存储数据
    NSMutableArray<RankingModel*> *_dataList;
    
    //存储cell
    NSMutableArray<RankingCell*> *_cellList;
    
    //滑动
    BOOL _canScroll;
    
    //遮罩
    CGFloat _edge;
    SKCropNode *_cropNode;
}

- (instancetype)init
{
    SKTexture *texture = [SKTexture textureWithImageNamed:@"bg_ranking"];
    self = [super initWithTexture:texture];
    if (self) {
        [self config];
        [self createContents];
    }
    return self;
}

-(void)config{
    _config = [Config shareInstance];
    
    _dataList = [NSMutableArray array];
    _cellList = [NSMutableArray array];
    
    _edge = 16;
    _page = 0;
    _cellHeight = 0;
    _offset = 0;
    _visableSize = CGSizeMake(_config.screenRight * 2 * 0.8, _config.menuSize.height * 0.6);
    
    //初始化数据
    [self updateDataByNew:YES WithCompleteBlock:NULL];
}

-(void)createContents{
    
    _cropNode = [SKCropNode node];
    SKTexture *maskTexture = [SKTexture textureWithImageNamed:@"mask_ranking"];
    SKSpriteNode *mask = [SKSpriteNode spriteNodeWithTexture:maskTexture];
    _cropNode.maskNode = mask;
    [self addChild:_cropNode];
    
}

#pragma mark 获取数据
- (void)updateDataByNew:(BOOL)isNew WithCompleteBlock:(void (^)(BOOL, NSString *))completeBlock{
    if (isNew) {
        _page = 0;
        _offset = 0;
        
        [_dataList removeAllObjects];
        for (RankingCell *cell in _cellList) {
            [cell removeFromParent];
        }
        [_cellList removeAllObjects];
    }
    //获取数据
    [self getDataWithCompleteBlock:completeBlock];         
}

///请求数据
-(void)getDataWithCompleteBlock:(void (^)(BOOL, NSString *))completeBlock{
    __weak __typeof (self)weakSelf = self;
    
    //获取数据
    [Session getListWithPage:_page CompleteBlock:^(BOOL successed, NSDictionary *result) {   
        if (!successed) {
            [weakSelf showNotif:@"获取数据失败"];
            //回调
            if (completeBlock) {
                completeBlock(NO,@"获取数据失败");
            }
            return;
        }
        NSString *message = [result objectForKey:@"message"];
        NSDictionary *data = [result objectForKey:@"data"];
        
        if (data == NULL) {
            if (completeBlock) {
                completeBlock(NO,@"数据解析错误");
            }
            return;
        }
        
        //请求数据成功处理
        NSArray *list = [data objectForKey:@"result"];
        NSNumber *newPageNumber = [data objectForKey:@"page"];
        NSNumber *limitNumber = [data objectForKey:@"limit"];        
        
        self->_page = newPageNumber.integerValue;
        
        [weakSelf addCellData:list];       
        
        //回调
        if (completeBlock) {
            completeBlock(YES,message);
        }
    }];  
}

///追加数据
-(void)addCellData:(NSArray*)cellModelDataList{
    
    NSMutableArray<RankingModel*> *array = [NSMutableArray array];
    //添加元数据
    for (NSInteger i=0; i<cellModelDataList.count; i++) {
        NSDictionary *cellModelData = [cellModelDataList objectAtIndex:i];
        
        NSInteger ranking = i + 1;
        NSString *username = cellModelData[@"username"];
        NSInteger score = ((NSNumber*)cellModelData[@"score"]).integerValue;
        
        RankingModel *rankingModel = [[RankingModel alloc] init];
        rankingModel.ranking = ranking;
        rankingModel.username = username;
        rankingModel.score = score;
        
        [array addObject:rankingModel];
    }
    
    [_dataList addObjectsFromArray:array];
    //赋值
    for (RankingModel *model in array) {
        RankingCell *cell = [RankingCell nodeWithRankingModel:model];
        if (_cellHeight == 0) {
            _cellHeight = cell.size.height;
        }
        cell.position = [self getCellPosition];
        //[self addChild:cell];
        [_cropNode addChild:cell];
        [_cellList addObject:cell];
    }            
}

///获取最新cell位置
-(CGPoint)getCellPosition{
    NSInteger count = _cellList.count;
    CGFloat y = _visableSize.height / 2 - _cellHeight / 2 - _cellHeight * (CGFloat)count + _offset;
    return CGPointMake(0, y);
}

-(CGPoint)getCellPositionBy:(NSInteger)index{
    CGFloat y = _visableSize.height / 2 - _cellHeight / 2 - _cellHeight * (CGFloat)index + _offset;
    return CGPointMake(0, y);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _canScroll = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_canScroll) {
        return;
    }
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        CGPoint preLocation = [touch previousLocationInNode:self];
        
        CGFloat delta = location.y - preLocation.y;
        
        _offset+=delta;
        
        for (NSInteger i=0; i<_cellList.count; i++) {
            RankingCell *cell = [_cellList objectAtIndex:i];
            cell.position = [self getCellPositionBy:i];
        }  
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _canScroll = NO;
    
    [self scrollBack];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _canScroll = NO;
    
    [self scrollBack];
}

//回弹&&判断是否需要加载或刷新
-(void)scrollBack{
    if (_cellList.count == 0) {
        return;
    }
    
    RankingCell *firstCell = [_cellList firstObject];
    RankingCell *lastCell = [_cellList lastObject];
    
    
    CGFloat cellHeight = firstCell.size.height;
    
    CGFloat topY = self.size.height / 2 - cellHeight - _edge;
    CGFloat bottomY = -self.size.height / 2 + cellHeight + _edge;
    
    CGFloat totalCellHeight = firstCell.size.height * (CGFloat)_cellList.count + _edge * 2;
    
    if (firstCell.position.y < topY) {
        _offset = 0;
        [self cellListScrollBy:_offset];
        
        [self updateDataByNew:YES WithCompleteBlock:NULL];
    }else {
        if (totalCellHeight > self.size.height) {
            if (lastCell.position.y > bottomY) {
                _offset = totalCellHeight - self.size.height;
                [self cellListScrollBy:_offset];
            }
            
            [self updateDataByNew:NO WithCompleteBlock:NULL];
        }else{
            _offset = 0;
            [self cellListScrollBy:_offset];
        }
    }
}

-(void)cellListScrollBy:(CGFloat)offset{    
    _offset = offset;
    
    CGFloat duration = 0.1;
    for (NSInteger i=0; i<_cellList.count; i++) {
        RankingCell *cell = [_cellList objectAtIndex:i];
        CGFloat targetY = [self getCellPositionBy:i].y;
        CGFloat distance = labs(cell.position.y - targetY);
        SKAction *moveY = [SKAction moveToY:targetY duration:targetY / 1000];
        moveY.timingMode = SKActionTimingEaseOut;
        [cell runAction:moveY];
    } 
}
@end
