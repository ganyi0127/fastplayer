//
//  ClickView.h
//  BlockUser
//
//  Created by taoqi007 on 2018/1/10.
//  Copyright © 2018年 taoqi007. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClickView : UIView
@property(nonatomic,strong)void(^clickblock)(NSString*string); //block第一种写法


//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
@property(nonatomic,strong)ReturnValueBlock block; //blokc第二种写法
@end
