//
//  MBProgressHUD+showQuickTip.h
//  VideoOnline
//
//  Created by Horace.Yuan on 15/1/11.
//  Copyright (c) 2015年 Goman. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (showQuickTip)

+ (void)showQuickTipWithText:(NSString *)text;
+ (void)showQuickTipWIthTitle:(NSString *)title withText:(NSString *)text;
+ (void)showLogTipWIthTitle:(NSString *)title withText:(NSString *)text;
+ (void)showHUDInKeyWindow;
+ (void)hideAllHUDInKeyWindow;

+ (void)showShareWaitingProgressHUD;
+ (void)showShareWaitingProgressHUDInView:(UIView *)view;
+ (void)hideShareWaitingProgressHUD;

@end
