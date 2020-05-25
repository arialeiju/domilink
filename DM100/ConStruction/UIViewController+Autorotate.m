//
//  UIViewController+Autorotate.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/2.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "UIViewController+Autorotate.h"

@implementation UIViewController (Autorotate)

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
