//
//  Header.h
//  domilink
//
//  Created by 马真红 on 2020/2/11.
//  Copyright © 2020 aika. All rights reserved.
//

#ifndef Domilink_h
#define Domilink_h
#import "MBProgressHUD.h"
#import "MBProgressHUD+showQuickTip.h"
#import "NSDictionary+ContainsKey.h"
#import "NSObject+InAppSetting.h"
#import "UIViewController+AddTitle.h"
#import "UIViewController+Autorotate.h"
#import "UIColor+Hexstring.h"
#import "NSTimer+Controller.h"
#import "SwichLanguage.h"
#import "PostXMLDataCreater.h"
#import "NetWorkModel.h"
//#define ServerURL       @"http://plat.basegps.com:8088/AppServer/server.do"
#define ServerURL       [InAppSetting instance].mServerURL
//#define ServerURL       @"http://test.basegps.com:80/AppServer/server.do"
//#define ServerURL       @"http://www.yidiyitian.cn:8080/AppServer/server.do"

#define TServerURL1       @"http://plat.domilink.com:80/AppServer/server.do"
#define TServerURL2       @"http://test.basegps.com:80/AppServer/server.do"

#pragma mark - Device Data

//#define testTyte TRUE
#define testTyte false

#define VIEWHEIGHT      [[UIScreen mainScreen] bounds].size.height
#define VIEWWIDTH       [[UIScreen mainScreen] bounds].size.width
#define SYSTEMVERSION   [[[UIDevice currentDevice] systemVersion] floatValue]
//#define KIsiPhoneX      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define AliAppKey   @"333458437"
#define AliAppSecret @"3949402524bc479c8d4b88aa465b55c7"

#define KIsiPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define HEADERHEIGHT    (self.view.frame.size.width*0.6)
#define NAVBARHEIGHT    ((SYSTEMVERSION>=7.0)? 64 :44 )
#define TABBARHEIGHT    49
#define IOS7DELTA       ((SYSTEMVERSION>=7.0)? 20 :0 )
#define IOS6DELTA       ((SYSTEMVERSION<7.0)? 20 :0 )
#define IOS7LATER       [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define IPHONE_HEIGHT   [UIScreen mainScreen].bounds

//iphonex的情况下view往下移动的多少
#define IPXMargin (KIsiPhoneX?20:0)
#define IPXLiuHai (KIsiPhoneX?30:20)

#define CarListFontSize 13//列表界面字体统一大小
#define TopBarUIcolor [UIColor colorWithRed:6/255.0 green:123/255.0 blue:206/255.0 alpha:1]
#define LineGraycolor [UIColor colorWithHexString:@"#F7F7F7"]

#pragma mark - Bundle
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#define nstimers 10//定时刷新的时间间隔（s）
#endif /* Header_h */
