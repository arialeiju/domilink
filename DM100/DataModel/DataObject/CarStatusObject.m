//
//  CarStatusObject.m
//  CarConnection
//
//  Created by 马真红 on 2018/11/14.
//  Copyright © 2018年 gemo. All rights reserved.
//

#import "CarStatusObject.h"
@implementation CarStatusObject
@synthesize imei,alarmWarn,robberDefense,carDoor,carEngine,remoteStart,carWindow,airWindow,trunk,footBrake,autoInspect,suona,lightFlash,autoLock,remoteTime,airCondition,carLight,temperature,brakeTime,engineSpeed,plusSpeed,accSts,powerOn,voltageLevel,gsmStrength,lo,la,online,plateNumber,lastTripStartTime,lastTripEndTime;


-(NSString*)getTitleDescribe
{
    if (self.lastTripStartTime.length<5||self.lastTripEndTime.length<5) {
        return @"";
    }else
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSDateFormatter *rformat = [[NSDateFormatter alloc] init];
        rformat.AMSymbol = @"上午";
        rformat.PMSymbol = @"下午";
        rformat.dateFormat = @"HH:mmaaa";
        
        NSDate *data1 = [format dateFromString:self.lastTripStartTime];
        NSString *timeStr1 = [rformat stringFromDate:data1];
        
        NSDate *data2 = [format dateFromString:self.lastTripEndTime];
        NSString *timeStr2 = [rformat stringFromDate:data2];
        return [NSString stringWithFormat:@"%@-%@",timeStr1,timeStr2];
    }
}

-(NSString*)getFuelViewDescribe
{
    if (self.averageOil<=0) {
        return @"未设置平均油耗,无法统计";
    }
    float allmileage=100*self.oilMass/self.averageOil;
    return [NSString stringWithFormat:@"%@公里",[self stringDisposeWithFloat:allmileage]];
}

-(NSString*)getFuelViewDescribe2
{
    if (self.averageOil<=0) {
        return @"";
    }
    float allmileage=100*self.oilMass/self.averageOil;
    return [NSString stringWithFormat:@"%@公里",[self stringDisposeWithFloat:allmileage]];
}
-(NSString*)getDescribeByaverageOil
{
    if (self.averageOil>0) {
        return [NSString stringWithFormat:@"%@升/100公里",[self stringDisposeWithFloat:self.averageOil]];
    }else
    {
        return @"";
    }
}
/*
 * 使用subString去除float后面无效的0##
 */
-(NSString *)stringDisposeWithFloat:(float)floatValue
{
    NSString *str = [NSString stringWithFormat:@"%0.2f",floatValue];
    long len = str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        //s.substring(0, len - i - 1);
        return [str substringToIndex:[str length]-1];
    }
    else
    {
        return str;
    }
}
-(void)setInitData:(CarStatusObject*) mCarStatusObject
{
    imei=mCarStatusObject.imei;
    alarmWarn=mCarStatusObject.alarmWarn;
    robberDefense=mCarStatusObject.robberDefense;
    carDoor=mCarStatusObject.carDoor;
    carEngine=mCarStatusObject.carEngine;
    remoteStart=mCarStatusObject.remoteStart;
    carWindow=mCarStatusObject.carWindow;
    airWindow=mCarStatusObject.airWindow;
    trunk=mCarStatusObject.trunk;
    footBrake=mCarStatusObject.footBrake;
    autoInspect=mCarStatusObject.autoInspect;
    suona=mCarStatusObject.suona;
    lightFlash=mCarStatusObject.lightFlash;
    autoLock=mCarStatusObject.autoLock;
    remoteTime=mCarStatusObject.remoteTime;
    airCondition=mCarStatusObject.airCondition;
    carLight=mCarStatusObject.carLight;
    temperature=mCarStatusObject.temperature;
    brakeTime=mCarStatusObject.brakeTime;
    engineSpeed=mCarStatusObject.engineSpeed;
    plusSpeed=mCarStatusObject.plusSpeed;
    accSts=mCarStatusObject.accSts;
    powerOn=mCarStatusObject.powerOn;
    voltageLevel=mCarStatusObject.voltageLevel;
    gsmStrength=mCarStatusObject.gsmStrength;
    lo=mCarStatusObject.lo;
    la=mCarStatusObject.la;
    
    _averageOil=mCarStatusObject.averageOil;
    _oilMass=mCarStatusObject.oilMass;
    online=mCarStatusObject.online;
    plateNumber=mCarStatusObject.plateNumber;
    
    lastTripStartTime=mCarStatusObject.lastTripStartTime;
    lastTripEndTime=mCarStatusObject.lastTripEndTime;
    

}

//-(Boolean)checkIsOktoXihuoCMD
//{
//    if (robberDefense==0&&carEngine==1) {
//        [self ShowTheResultDailog:@"车辆已启动，并且解锁中，无法执行熄火指令，请先下发锁车指令再进行此操作" Title:@"注意"];
//        return false;
//    }
//    return true;
//}
//
//-(void)ShowTheResultDailog:(NSString*)content Title:(NSString*)title
//{
//    //设置帐号
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
//                                                         message:content
//                                                        delegate:self
//                                               cancelButtonTitle:@"确认"
//                                               otherButtonTitles:nil, nil
//                               ];
//    alertView.alertViewStyle=UIAlertViewStyleDefault;
//    alertView.tag=10;
//    [alertView show];
//}
@end
