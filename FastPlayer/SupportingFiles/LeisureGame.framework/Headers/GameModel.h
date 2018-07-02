//
//  GameModel.h
//  GameFramework
//
//  Created by Carr on 29/6/2018.
//  Copyright © 2018年 LeisureGames. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GameModelDelegate<NSObject>
-(void)GameStateStr:(NSString *)States;
@end
@interface GameModel : NSObject
@property (nonatomic ,retain)id <GameModelDelegate>ModelDelegate;
+ (void)gamelabe:(UILabel *)label font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment numberOfLine:(CGFloat)numberOfLine;
-(void)getModel:(NSDictionary *)dictionary;
+ (void)gamePropertyWithTextField:(UITextField *)textField textFont:(CGFloat)textFont textColor:(UIColor *)textColor textPlaceHolder:(NSString *)placeHolder mayege:(CGFloat)textPlaceHolderFont sad:(UIColor *)textPlaceHolderTextColor textAlignment:(NSTextAlignment)textAlignment;
@end
