//
//  UnitModel.m
//  domilink
//
//  Created by 马真红 on 2020/2/16.
//  Copyright © 2020 aika. All rights reserved.
//

#import "UnitModel.h"
@implementation UnitModel
@synthesize devImei,devName,carNumber,devType,devSts,useSts,sigTime,locTime,la,lo,course,speed,logoType;
//获取显示的名字
-(NSString*)getShowName
{
    if(self.devName!=NULL && self.devName.length>0)
    {
        return self.devName;
    }else
    {
        return self.devImei;
    }
}
//获取设备号
-(NSString*)getImei
{
    if(self.devImei!=NULL)
    {
        return self.devImei;
    }
    return @"";
}
//获取别名
-(NSString*)getName
{
    if(self.devName!=NULL)
    {
        return self.devName;
    }
    return @"";
}
//获取车牌号码
-(NSString*)getCarNumber
{
    if(self.carNumber!=NULL)
    {
        return self.carNumber;
    }
    return @"";
}
//获取心跳时间
-(NSString*)getsigTime
{
    if(self.sigTime!=NULL)
    {
        return self.sigTime;
    }
    return @"";
}

//获取定位时间
-(NSString*)getlocTime
{
    if(self.locTime!=NULL)
    {
        return self.locTime;
    }
    return @"";
}
//获取lat
-(double)getLat
{
    if(self.la!=NULL)
    {
        double mr=[self.la doubleValue];
        return mr;
    }
    return 0;
}
//获取lot
-(double)getLot
{
    if(self.lo!=NULL)
    {
        double mr=[self.lo doubleValue];
        return mr;
    }
    return 0;
}

//获取当前状态：过期/静止/行驶中/离线
-(StsShowModel*)getShowStatu
{
    NSString* sts=@"";
    NSString* TimeStr=@"";
    int setid=0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * nowDate = [NSDate date];
    if([self.useSts isEqualToString:@"0"])
    {
        sts=[SwichLanguage getString:@"expire"];
        setid=0;
    }else if([self.devSts isEqualToString:@"1"])
    {
        NSDate * stsTime =[dateFormatter dateFromString:self.locTime];
        NSTimeInterval stsTimenSeconds = [nowDate timeIntervalSinceDate:stsTime];
            if(self.speed<=0.00)
            {
                sts=[SwichLanguage getString:@"quiescent"];
                TimeStr=[self.inAppSetting getTimeDurationWithtimeSpanInSeconds:stsTimenSeconds];
                setid=1;
            }else
            {
                if(stsTimenSeconds>3600)
                {
                    sts=[SwichLanguage getString:@"quiescent"];
                    TimeStr=[self.inAppSetting getTimeDurationWithtimeSpanInSeconds:stsTimenSeconds];
                    setid=1;
                }else
                {
                    sts=[SwichLanguage getString:@"driving"];
                    TimeStr= [NSString stringWithFormat:@"%.2fkm/h",self.speed] ;
                    setid=2;
                }
            }
    }else if([self.devSts isEqualToString:@"0"])
    {
        sts=[SwichLanguage getString:@"offline"];
        setid=3;
        if(self.sigTime!=NULL)
        {
            NSDate *signalTime = [dateFormatter dateFromString:self.sigTime];//信号时间
            NSTimeInterval signalTimenSeconds = [nowDate timeIntervalSinceDate:signalTime];
            TimeStr=[self.inAppSetting getTimeDurationWithtimeSpanInSeconds:signalTimenSeconds];;
        }
    }
    StsShowModel* mStsShowModel=[[StsShowModel alloc]init];
    mStsShowModel.Sts=sts;
    mStsShowModel.TimeStr=TimeStr;
    mStsShowModel.StsId=setid;
    return mStsShowModel;
}
    
@end
