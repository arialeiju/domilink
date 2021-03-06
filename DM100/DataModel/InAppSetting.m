//
//  InAppSetting.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/3/31.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "InAppSetting.h"
#import "AppDelegate.h"
#import <CloudPushSDK/CloudPushSDK.h>
//#import <CloudPushSDK/CloudPushSDK.h>//by aika test
@implementation InAppSetting

@synthesize user_itemList;
@synthesize selectid;
@synthesize isPushOk;//是否网易云推送初始化成功
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
                      s_inAppSetting.isPushOk=false;
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
    //self.inAppSetting.loginNo = nil;
    self.inAppSetting.autoLoginState=false;
    self.inAppSetting.userId = nil;
    self.inAppSetting.username=nil;
    self.inAppSetting.type= nil;
    //elf.inAppSetting.password=nil;
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
    
    [self delectPushId];
}

//注销当前绑定的推送id
-(void)delectPushId
{
    if (self.inAppSetting.isPushOk) {
        
        NSDictionary *bodyData = @{@"pushId":[CloudPushSDK getDeviceId] };
        NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:801
                                                            withParameters:bodyData];
        [NetWorkModel POST:ServerURL
                parameters:parameters
                   success:^(ResponseObject *messageCenterObject)
         {
             NSDictionary *ret = messageCenterObject.ret;
           // NSLog(@"801返回=%@",ret);
            int mretcode=[[ret objectForKey:@"retCode" ] intValue];
             if (mretcode==1) {

                 NSLog(@"解除绑定成功");
             }else
             {
                 NSString* msgstr=(NSString *)[messageCenterObject.ret objectForKey:@"retMsg"];
                 if (msgstr.length==0) {
                     [MBProgressHUD showQuickTipWIthTitle:@"解除绑定推送服务失败" withText:nil];
                 }else
                 {
                     [MBProgressHUD showQuickTipWIthTitle:msgstr withText:nil];
                 }
             }
         }
                   failure:^(NSError *error)
         {
            //[MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"绑定推送服务失败2"] withText:nil];
         }];
    }
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

#pragma mark ----导航方法-----------

- (void)getInstalledMapAppWithEndLocation:(NSString*)la with:(NSString*)lo andtpye:(int)thetype
{
    switch (thetype) {
        case 1:
            //百度地图
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
                NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
                baiduMapDic[@"title"] = [SwichLanguage getString:@"bdmap"];
                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/navi?location=%@,%@type=DIS&src=com.gemo.outsource.carconnection",la,lo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
            break;
            
        case 2:
            //高德地图
        {
            NSString *urlString2 = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%@&lon=%@&dev=0&style=2",la,lo] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString2]];
        }
            break;
        default:
            NSLog(@"未知参数thetype");
            break;
    }
    
}

//检查特定app是否安装
-(Boolean)CkeckAppIsInstall:(int)thetype
{
    
    Boolean HasBaidumap=false;
    switch (thetype) {
        case 1:
            HasBaidumap=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
            break;
        case 2:
            HasBaidumap=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
            break;
        default:
            break;
    }
    if (HasBaidumap) {
        return true;
    }else
    {
        NSLog(@"未安装的地图");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            switch (thetype) {
                case 1:
                    [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"errorMapT1"] withText:[SwichLanguage getString:@"errorMapC1"]];
                    break;
                case 2:
                    [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"errorMapT2"] withText:[SwichLanguage getString:@"errorMapC2"]];
                    break;
                default:
                    break;
            }
            
        });
        return false;
    }
}
@end
