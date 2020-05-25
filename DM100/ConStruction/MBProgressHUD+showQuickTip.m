//
//  MBProgressHUD+showQuickTip.m
//  VideoOnline
//
//  Created by Horace.Yuan on 15/1/11.
//  Copyright (c) 2015年 Goman. All rights reserved.
//

#import "MBProgressHUD+showQuickTip.h"

static MBProgressHUD *s_hud;
static int s_hudCount;

@implementation MBProgressHUD (showQuickTip)

+ (void)showQuickTipWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow]
                                              animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud setLabelText:text];
    [hud hide:YES afterDelay:1.0f];
}

+ (void)showQuickTipWIthTitle:(NSString *)title withText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow]
                                              animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud setLabelText:title];
    [hud setDetailsLabelText:text];
    [hud hide:YES afterDelay:1.0f];
}

+ (void)showLogTipWIthTitle:(NSString *)title withText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow]
                                              animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud setLabelText:title];
    [hud setDetailsLabelText:text];
    [hud hide:YES afterDelay:3.0f];
}

+ (void)showHUDInKeyWindow
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow
                         animated:YES];
}
+ (void)hideAllHUDInKeyWindow;
{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow
                             animated:YES];
}


+ (void)showShareWaitingProgressHUD
{
    [self showShareWaitingProgressHUDInView:[[UIApplication sharedApplication] keyWindow]];
}

+ (void)hideShareWaitingProgressHUD
{
    s_hudCount--;
    if (s_hudCount == 0)
    {
        [s_hud hide:YES];
        s_hud = nil;
    }
}


+ (void)showShareWaitingProgressHUDInView:(UIView *)view
{
    if (s_hudCount == 0)
    {
        s_hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    s_hudCount++;
}


@end
