//
//  InAppSetting.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/3/31.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "InAppSetting.h"
#import "AppDelegate.h"
//#import <CloudPushSDK/CloudPushSDK.h>//by aika test
@implementation InAppSetting

@synthesize user_itemList;
@synthesize selectid;
@synthesize LangNo;//语言版本 -1未设置  0中文 1英文
@synthesize mapType;//地图版本 默认0  0谷歌地图 1百度地图
@synthesize type;//记录登录类型
@synthesize userId;//用户ID
@synthesize username;//登陆账号名字
@synthesize curloginNo;//登录帐号
@synthesize curuserId;//用户ID
@synthesize curusername;//登陆账号名字
@synthesize HadLogin;
@synthesize dict;
@synthesize indexPath;
@synthesize _dataSource;
+ (instancetype)instance
{
    static dispatch_once_t pred = 0;
    __strong static InAppSetting *s_inAppSetting;
    dispatch_once(&pred, ^
                  {
                      s_inAppSetting = [[InAppSetting alloc] init];
                      s_inAppSetting.HadLogin=false;
                      s_inAppSetting.user_itemList= [NSMutableArray array];
                      s_inAppSetting.selectid=0;
                  });
    return s_inAppSetting;
}


#pragma mark - property stored in UserDefault
- (BOOL)isFirstRun
{
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"Key_UserDefault_AlreadyRun"];
    if(flag == NO)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Key_UserDefault_AlreadyRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return !flag;
    
}

- (void)setMapType:(int)mmapType
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:mmapType forKey:@"Key_UserDefault_mapType"];
    [userDefaults synchronize];
}

- (int)mapType
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"Key_UserDefault_mapType"];
}

- (void)setPassword:(NSString *)password
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:password forKey:@"Key_UserDefault_password"];
    [userDefaults synchronize];
}

- (NSString *)password
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"Key_UserDefault_password"];
}

- (void)setLoginNo:(NSString *)loginNo
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:loginNo forKey:@"Key_UserDefault_loginNo"];
    [userDefaults synchronize];
}

- (NSString *)loginNo
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"Key_UserDefault_loginNo"];
}

- (void)setRememberPasswordState:(BOOL)electronicFenceState
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:electronicFenceState forKey:@"Key_rememberPasswordState"];
    [userDefault synchronize];
}

- (BOOL)rememberPasswordState{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"Key_rememberPasswordState"];
}

- (void)setAutoLoginState:(BOOL)electronicFenceState
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:electronicFenceState forKey:@"Key_autoLoginState"];
    [userDefault synchronize];
}

- (BOOL)autoLoginState{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"Key_autoLoginState"];
}


- (void)setUsernameList:(NSArray *)usernameList
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:usernameList
                     forKey:@"Key_UserDefault_usernameList"];
    [userDefaults synchronize];
}

- (NSArray *)usernameList
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"Key_UserDefault_usernameList"];
}

- (void)loginOut
{
    
    self.dataModel.isLogin = NO;
    self.dataModel.isExperience = NO;
    self.HadLogin=false;
    
    self.inAppSetting.loginNo = nil;
    self.inAppSetting.userId = nil;
    self.inAppSetting.username=nil;
    self.inAppSetting.type= nil;
    self.inAppSetting.password=nil;
    self.inAppSetting.curloginNo=nil;
    self.inAppSetting.curuserId=nil;
    self.inAppSetting.curusername=nil;
    //self.inAppSetting.username = nil;
    //self.inAppSetting.password = nil;
    [self.user_itemList removeAllObjects];
    
    if (self.dict!=nil) {
        [self.dict removeAllObjects];
        self.dict=nil;
    }
    if (self._dataSource!=nil) {
        [self._dataSource removeAllObjects];
        self._dataSource=nil;
    }
    
    self.indexPath=nil;
    
// by aika test
//    [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
//        if (res.success) {
//            NSLog(@"unbindAccount  success");
//        } else {
//            NSLog(@"unbindAccount  failed, error: %@", res.error);
//        }
//
//    }];
}
- (NSString *)getTimeDurationWithtimeSpanInSeconds:(NSTimeInterval )timeSpanInSeconds
{
    
    
    long checktime=timeSpanInSeconds;
    //NSLog(@"checktime=%ld",checktime);
    if (checktime<0) {
        return @"";
    }
    
    
    long day=timeSpanInSeconds/(24*60*60);
    long hour=(timeSpanInSeconds/(60*60)-day*24);
    long min=((timeSpanInSeconds/(60))-day*24*60-hour*60);
    
    if(day>0)
    {
        if(day>60)
        {
            return [SwichLanguage getString:@"overday"];
        }else
        {
            if(hour>0)
            {
                return  [NSString stringWithFormat:@"%ld%@%ld%@", day,[SwichLanguage getString:@"day"],hour,[SwichLanguage getString:@"hour"]];
            }else if(min>0)
            {
                return  [NSString stringWithFormat:@"%ld%@%ld%@", day,[SwichLanguage getString:@"day"],min,[SwichLanguage getString:@"min"]];
            }else
            {
                return  [NSString stringWithFormat:@"%ld%@", day,[SwichLanguage getString:@"day"]];
            }
        }
    }else if(hour>0&&min>=1)
    {
         return  [NSString stringWithFormat:@"%ld%@%ld%@", hour,[SwichLanguage getString:@"hour"],min,[SwichLanguage getString:@"min"]];
    }else if(hour>0&&min==0)
    {
        return  [NSString stringWithFormat:@"%ld%@", hour,[SwichLanguage getString:@"hour"]];
    }else if(min>0)
    {
        return  [NSString stringWithFormat:@"%ld%@", min,[SwichLanguage getString:@"min"]];
    }else
    {
        return  [SwichLanguage getString:@"lessmin"];
    }
    
    return @"";
}
/**
 * 检测是否有数据, page2刷新或者按钮点击前都需要检测
 */
-(Boolean)checkhaddata
{
    if(self.user_itemList!=nil)
    {
        if(self.user_itemList.count>self.selectid)
        {
            return true;
        }
    }
    
    //弹框提醒
     [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"nodevice"] withText:nil];
    return false;
}

/**
 * 获取当前设备的参数
 */
-(UnitModel*)getSelectUnit
{
    UnitModel* mUnitModel=[self.user_itemList objectAtIndex:self.selectid];
    return mUnitModel;
}

//判断定位模式
-(NSString*)returnthestringbytype:(NSString*)type
{
    
    if([type isEqualToString:@"0"])
    {
        return [SwichLanguage getString:@"maptype1"];
    }
    if([type isEqualToString:@"1"])
    {
        return [SwichLanguage getString:@"maptype2"];
    }
    if([type isEqualToString:@"2"])
    {
        return [SwichLanguage getString:@"maptype3"];
    }
     return [SwichLanguage getString:@"maptype4"];
}
@end
