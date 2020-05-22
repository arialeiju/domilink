//
//  AppDelegate.h
//  DM100
//
//  Created by 马真红 on 2020/5/22.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ItemViewController *rootTabBarController;
@property (strong, nonatomic, readonly) UINavigationController *rootNavigationController;

@end
