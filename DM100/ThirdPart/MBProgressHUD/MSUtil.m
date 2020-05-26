//
//  MSServiceContent.m
//  EggplantAlbums
//
//  Created by yeby on 13-8-6.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#import "MSUtil.h"


#import "MBProgressHUD.h"
#import "MSUtil.h"



@implementation MSUtil


+ (void)showTipsWithHUD:(NSString *)labelText showTime:(CGFloat)time
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[[[UIApplication sharedApplication] delegate] window]] ;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = labelText;
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:hud];
    
    [hud hide:YES afterDelay:time];
}

+ (void)showTipsWithView:(UIView *)uiview labelText:(NSString *)labelText showTime:(CGFloat)time
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:uiview] ;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = labelText;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [uiview addSubview:hud];
    
    [hud hide:YES afterDelay:time];
}

+(void) showHudMessage:(NSString*) msg hideAfterDelay:(NSInteger) sec uiview:(UIView *)uiview{
    MBProgressHUD* hud2 = [MBProgressHUD showHUDAddedTo:uiview animated:YES];
    hud2.mode = MBProgressHUDModeText;
    hud2.labelText = msg;
    hud2.margin = 12.0f;
    hud2.yOffset = 20.0f;
    hud2.removeFromSuperViewOnHide = YES;
    [hud2 hide:YES afterDelay:sec];
}


@end
