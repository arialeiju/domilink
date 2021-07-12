//
//  InAppSetting.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/3/31.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnitModel.h"
@interface InAppSetting : NSObject

+(instancetype) instance;

/**
 * 登陆后运行期间持久化的参数
 */
@property (strong, retain) NSMutableArray *user_itemList;//车辆参数列表
@property(nonatomic,assign)int selectid;//user_itemList选中当前显示设备  0为默认第一位
@property(nonatomic,readwrite)BOOL isPushOk;//是否网易云推送初始化成功
@property(nonatomic,assign)int mapType;//地图版本 默认0  0苹果地图 1百度地图
@property (nonatomic, strong) NSString * type;//记录登录类型
@property (nonatomic, strong) NSString *loginNo;//登录帐号
@property (nonatomic, strong) NSString * userId;//用户ID
@property (nonatomic, strong) NSString * username;//登陆账号名字
@property (nonatomic, strong) NSString * password;// 登录密码

//选中的账号 ID 名称，主要用于多级账号切换使用
@property (nonatomic, strong) NSString * curloginNo;//登录帐号
@property (nonatomic, strong) NSString * curuserId;//用户ID
@property (nonatomic, strong) NSString *curusername;//登陆账号名字

//缓存默认设置参数
@property (nonatomic,readwrite) BOOL rememberPasswordState;//是否记住密码
@property (nonatomic,readwrite) BOOL autoLoginState;//是否自动登录
@property (nonatomic,readwrite) BOOL HadLogin;//是否成功登陆
@property (nonatomic, strong) NSArray  * usernameList;//历史登陆账号列表

//持久用户子列表
@property (strong, retain) NSMutableArray *dict;
@property (strong, retain) NSMutableArray *_dataSource;
@property (strong, retain) NSIndexPath *indexPath;

// user data
/*--------------------------------------------------*/

- (void)loginOut;
/*--------------------------------------------------*/
- (NSString *)getTimeDurationWithtimeSpanInSeconds:(NSTimeInterval )timeSpanInSeconds;

-(Boolean)checkhaddata;
-(UnitModel*)getSelectUnit;
-(NSString*)returnthestringbytype:(NSString*)type;

- (void)getInstalledMapAppWithEndLocation:(NSString*)la with:(NSString*)lo andtpye:(int)thetype;
-(Boolean)CkeckAppIsInstall:(int)thetype;
@end
