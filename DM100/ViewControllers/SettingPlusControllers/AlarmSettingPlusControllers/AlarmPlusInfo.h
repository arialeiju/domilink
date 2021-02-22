//
//  AlarmPlusInfo.h
//  CarConnection
//
//  Created by 马真红 on 2020/10/26.
//  Copyright © 2020 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmPlusInfo : NSObject
@property (nonatomic, strong) NSString *deviceImei;

@property (nonatomic, assign) int isWeakSignal;//弱信号报警
@property (nonatomic, assign) int isParkingGuard;//停车守卫报警
@property (nonatomic, assign) int isCollisionAlarm;//碰撞报警
@property (nonatomic, assign) int isRolloverAlarm;//侧翻报警
@property (nonatomic, assign) int isSignalRecover;//信号恢复报警
@property (nonatomic, assign) int isLightSensitive;//感光报警
@property (nonatomic, assign) int isSosAlarm;//SOS报警
@property (nonatomic, assign) int isPowerFailure;//断电报警
@property (nonatomic, assign) int isFlowExpiration;//流量到期报警
@property (nonatomic, assign) int isPlatformExpires;//平台到期
@property (nonatomic, assign) int isOutFence;//出围栏报警

@property (nonatomic, assign) int autoDefense;//确认是否自动布防 开关
@property (nonatomic, assign) int isOverspeed;//超速报警
@property (nonatomic, assign) int isOffline;//离线报警:
@property (nonatomic, assign) int lowElectric;//低电压报警
@property (nonatomic, assign) int isVibrationAlarm;//震动报警

@property (nonatomic, assign) int outFence;//出围栏距离参数
@property (nonatomic, assign) int overspeed;//超速报警速度参数
@property (nonatomic, assign) int offlineLong;//离线报警时长参数
@property (nonatomic, assign) int electricPercent;//低电百分比参数
-(void)autoDefault;
-(void)setDatainit;
-(void)AllOn;
-(NSDictionary*)getNSDictionary;
//_celllist2 = [[NSMutableArray alloc] initWithObjects: @"弱信号报警:",@"停车守卫报警:",@"碰撞报警:",
//                                                    @"侧翻报警:",@"信号恢复报警:",@"感光报警:",
//                                                    @"SOS报警:",@"断电报警:",@"流量到期报警:",
//                                                    @"平台到期:",@"出围栏报警:",nil];
//
//_celllist3 = [[NSMutableArray alloc] initWithObjects: @"自带布防:",@"超速报警:",
//                                                    @"离线报警:",@"低电报警:",@"震动报警:",nil];
@end

NS_ASSUME_NONNULL_END
