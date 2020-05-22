//
//  AppDelegate.m
//  DM100
//
//  Created by 马真红 on 2020/5/22.
//  Copyright © 2020 aika. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<UIGestureRecognizerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      // statusBar
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // window
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window setBackgroundColor:[UIColor clearColor]];
    
    // rootViewControllers
    _rootTabBarController = [[ItemViewController alloc] init];
    _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:_rootTabBarController];
    _rootNavigationController.interactivePopGestureRecognizer.enabled = YES;
    _rootNavigationController.interactivePopGestureRecognizer.delegate = self;
    [_rootNavigationController setNavigationBarHidden:YES];
    
    [_window setRootViewController:_rootNavigationController];
    [_window makeKeyAndVisible];
    return YES;
}




@end
