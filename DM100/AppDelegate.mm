//
//  AppDelegate.m
//  DM100
//
//  Created by 马真红 on 2020/5/22.
//  Copyright © 2020 aika. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
@interface AppDelegate ()<UIGestureRecognizerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      // statusBar
    
    //初始化应用语言
    [SwichLanguage initUserLanguage];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // window
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window setBackgroundColor:[UIColor clearColor]];
    
    // rootViewControllers
    _rootTabBarController = [[TabBarViewController alloc] init];
    _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:_rootTabBarController];
    _rootNavigationController.interactivePopGestureRecognizer.enabled = YES;
    _rootNavigationController.interactivePopGestureRecognizer.delegate = self;
    [_rootNavigationController setNavigationBarHidden:YES];
    
    [_window setRootViewController:_rootNavigationController];
    [_window makeKeyAndVisible];
    
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"Z9n7Ww98CCHscn98Qh28vKZOBIWjUrOP" authDelegate:self];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [mapManager start:@"Z9n7Ww98CCHscn98Qh28vKZOBIWjUrOP"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"启动引擎失败");
    }else
    {
        NSLog(@"百度模块初始化成功");
    }
    
    return YES;
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError
{
    NSLog(@"location auth onGetPermissionState %ld",(long)iError);
    
}


@end
