//
//  MSServiceContent.m
//  EggplantAlbums
//
//  Created by yeby on 13-8-6.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//



@interface MSUtil : NSObject

+ (void)showTipsWithHUD:(NSString *)labelText showTime:(CGFloat)time;
+ (void)showTipsWithView:(UIView *)uiview labelText:(NSString *)labelText showTime:(CGFloat)time;
+(void) showHudMessage:(NSString*) msg hideAfterDelay:(NSInteger) sec uiview:(UIView *)uiview;


@end
