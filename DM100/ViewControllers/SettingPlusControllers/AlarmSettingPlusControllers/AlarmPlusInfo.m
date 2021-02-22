//
//  AlarmPlusInfo.m
//  CarConnection
//
//  Created by 马真红 on 2020/10/26.
//  Copyright © 2020 gemo. All rights reserved.
//

#import "AlarmPlusInfo.h"

@implementation AlarmPlusInfo
@synthesize deviceImei,isWeakSignal,isParkingGuard,isCollisionAlarm,isRolloverAlarm,isSignalRecover,isLightSensitive,isSosAlarm,isPowerFailure,isFlowExpiration,isPlatformExpires,isOutFence,autoDefense,isOverspeed,isOffline,lowElectric,isVibrationAlarm,outFence,overspeed,offlineLong,electricPercent;

-(instancetype)init{
    self = [super init];
    if (self) {
        isWeakSignal=-1;
        isParkingGuard=-1;
        isCollisionAlarm=-1;
        isRolloverAlarm=-1;
        isSignalRecover=-1;
        isLightSensitive=-1;
        isSosAlarm=-1;
        isPowerFailure=-1;
        isFlowExpiration=-1;
        isPlatformExpires=-1;
        isOutFence=-1;
        autoDefense=-1;
        isOverspeed=-1;
        isOffline=-1;
        lowElectric=-1;
        isVibrationAlarm=-1;
        outFence=-1;
        overspeed=-1;
        offlineLong=-1;
        electricPercent=-1;
    }
    return self;
}

//恢复推荐设置，只改动上部分的报警on
-(void)autoDefault
{
    isWeakSignal=1;
    isParkingGuard=1;
    isCollisionAlarm=1;
    isRolloverAlarm=1;
    isSignalRecover=1;
    isLightSensitive=1;
    isSosAlarm=1;
    isPowerFailure=1;
    isFlowExpiration=1;
    isPlatformExpires=1;
    isOutFence=1;
//    autoDefense=1;
//    isOverspeed=1;
//    isOffline=1;
//    lowElectric=1;
//    isVibrationAlarm=1;
//    OutFence=200;
//    overspeed=120;
//    offlineLong=3;
//    electricPercent=10;
}

//全部报警开启on 不设置参数
-(void)AllOn
{
    isWeakSignal=1;
    isParkingGuard=1;
    isCollisionAlarm=1;
    isRolloverAlarm=1;
    isSignalRecover=1;
    isLightSensitive=1;
    isSosAlarm=1;
    isPowerFailure=1;
    isFlowExpiration=1;
    isPlatformExpires=1;
    isOutFence=1;
    autoDefense=1;
    isOverspeed=1;
    isOffline=1;
    lowElectric=1;
    isVibrationAlarm=1;
//    outFence=200;
//    overspeed=120;
//    offlineLong=3;
//    electricPercent=10;
}

//数值的初始化
-(void)setDatainit
{
        outFence=200;
        overspeed=120;
        offlineLong=3;
        electricPercent=10;
}

-(NSDictionary*)getNSDictionary
{
    NSDictionary *bodyData = @{@"deviceImei":deviceImei,
                               @"isWeakSignal":@(isWeakSignal),
                               @"isParkingGuard":@(isParkingGuard),
                               @"isCollisionAlarm":@(isCollisionAlarm),
                               @"isRolloverAlarm":@(isRolloverAlarm),
                               @"isSignalRecover":@(isSignalRecover),
                               @"isLightSensitive":@(isLightSensitive),
                               @"isSosAlarm":@(isSosAlarm),
                               @"isPowerFailure":@(isPowerFailure),
                               @"isFlowExpiration":@(isFlowExpiration),
                               @"isPlatformExpires":@(isPlatformExpires),
                               @"isOutFence":@(isOutFence),
                               
                               @"autoDefense":@(autoDefense),
                               @"isOverspeed":@(isOverspeed),
                               @"isOffline":@(isOffline),
                               @"lowElectric":@(lowElectric),
                               @"isVibrationAlarm":@(isVibrationAlarm),
                               @"outFence":@(outFence),
                               @"overspeed":@(overspeed),
                               @"offlineLong":@(offlineLong),
                               @"electricPercent":@(electricPercent)
                               };
    return bodyData;
}
@end
