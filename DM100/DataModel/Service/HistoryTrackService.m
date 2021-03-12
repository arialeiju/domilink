//
//  HistoryTrackService.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/15.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "HistoryTrackService.h"

#define kImei       @"imei"
#define kStartTime  @"starttime"
#define kEndTime    @"endtime"
#define kSpe        @"pageno"//@"spe"
@implementation HistoryTrackService

+ (void)getHistoryTrackWithImei:(NSString *)imei
                  withStartTime:(NSString *)startTime
                    withEndTime:(NSString *)endTime
                        withSpe:(NSString *)spe
                        withJZStatus:(BOOL)isGuolvJZ
                        success:(void (^)(NSArray *))success
                        failure:(void (^)(NSError *))failure
{
//#ifdef DEBUG
//    imei = @"684611121300020";
//#endif
    
    NSDictionary *bodyData = @{kImei:imei,
                               kStartTime:startTime,
                               kEndTime:endTime,
                               kSpe:spe};
    
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:34
                                                        withParameters:bodyData];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *responseObject)
    {
        //NSLog(@"%@", responseObject.ret);
        NSDictionary *ret = responseObject.ret;
        NSArray *responseArray = (NSArray *)[ret objectForKey:@"msg" ];
        NSMutableArray *newArray = [NSMutableArray array];
        
        CGFloat mcount=responseArray.count;
        NSString* mcourse=@"90";//最后一次的方向
        if (isGuolvJZ) {//为什么不写在for循环里面是为了优化减少判断
            for (int i=0; i<mcount; i++) {
                HistoryLocationObject *histroyPoint = [[HistoryLocationObject alloc] initWithJSON:[responseArray objectAtIndex:i]];
                
                //判断是不是最后一个点
                if ((i+1)<mcount) {
                    HistoryLocationObject *hnext = [[HistoryLocationObject alloc] initWithJSON:[responseArray objectAtIndex:i+1]];
                    
                    float ila1= [histroyPoint.la floatValue];
                    float ilo1= [histroyPoint.lo floatValue];
                    float ila2= [hnext.la floatValue];
                    float ilo2= [hnext.lo floatValue];
                    double a1=[HistoryTrackService getAngleLat1:ila1 withLng1:ilo1 withLat2:ila2 withLng2:ilo2];
                    if (a1<0) {//相同点
                        histroyPoint.course=mcourse;
                    }else
                    {
                        mcourse=[NSString stringWithFormat:@"%0.2f",a1];
                        histroyPoint.course=[NSString stringWithFormat:@"%0.2f",a1];
                    }
                }
                
                if (! [histroyPoint.locateSts isEqualToString:@"1"]) {
                                     [newArray addObject:histroyPoint];
                }
            }
        }else
        {
            for (int i=0; i<mcount; i++) {
                HistoryLocationObject *histroyPoint = [[HistoryLocationObject alloc] initWithJSON:[responseArray objectAtIndex:i]];
                
                //判断是不是最后一个点
                if ((i+1)<mcount) {
                    HistoryLocationObject *hnext = [[HistoryLocationObject alloc] initWithJSON:[responseArray objectAtIndex:i+1]];
                    
                    float ila1= [histroyPoint.la floatValue];
                    float ilo1= [histroyPoint.lo floatValue];
                    float ila2= [hnext.la floatValue];
                    float ilo2= [hnext.lo floatValue];
                    double a1=[HistoryTrackService getAngleLat1:ila1 withLng1:ilo1 withLat2:ila2 withLng2:ilo2];
                    if (a1<0) {//相同点
                        histroyPoint.course=mcourse;
                    }else
                    {
                        mcourse=[NSString stringWithFormat:@"%0.2f",a1];
                        histroyPoint.course=[NSString stringWithFormat:@"%0.2f",a1];
                    }
                }
                
                [newArray addObject:histroyPoint];
            }
        }

        //基站过滤
//        if (isGuolvJZ) {
//            for (NSDictionary *dic in responseArray)
//            {
//                HistoryLocationObject *histroyPoint = [[HistoryLocationObject alloc] initWithJSON:dic];
//                if (! [histroyPoint.locateSts isEqualToString:@"1"]) {
//                     [newArray addObject:histroyPoint];
//                }
//            }
//        }else
//        {
//          for (NSDictionary *dic in responseArray)
//          {
//              HistoryLocationObject *histroyPoint = [[HistoryLocationObject alloc] initWithJSON:dic];
//              [newArray addObject:histroyPoint];
//          }
//        }
        
//        double a1=[HistoryTrackService getAngleLat1:0 withLng1:0 withLat2:0 withLng2:0];
//        double a2=[HistoryTrackService getAngleLat1:0 withLng1:0 withLat2:-10 withLng2:10];
//        double a3=[HistoryTrackService getAngleLat1:0 withLng1:0 withLat2:10 withLng2:10];
//        double a4=[HistoryTrackService getAngleLat1:0 withLng1:0 withLat2:10 withLng2:-10];
//        NSLog(@"a1=%f",a1);
//        NSLog(@"a2=%f",a2);
//        NSLog(@"a3=%f",a3);
//        NSLog(@"a4=%f",a4);
        //当数据只有一个的时候。复制多一个。用于播放用
        if (newArray.count==1) {
            HistoryLocationObject *onebgject=[newArray objectAtIndex:0];
            [newArray addObject:onebgject];
        }
        success(newArray);
    }
               failure:^(NSError *error)
    {
        failure(error);
    }];
}

/*
 *通过两个经纬度算出方位
 */
+(double)getAngleLat1:(double)lat1 withLng1:(double)lng1 withLat2:(double)lat2 withLng2:(double)lng2
{
    double x1 = lng1;
    double y1 = lat1;
    double x2 = lng2;
    double y2 = lat2;
    double pi = M_PI;
    double w1 = y1 / 180 * pi;
    double j1 = x1 / 180 * pi;
    double w2 = y2 / 180 * pi;
    double j2 = x2 / 180 * pi;
    double ret;
    if (j1 == j2) {
        if (w1 > w2)
            return 270; // 北半球的情况，南半球忽略
        else if (w1 < w2)
            return 90;
        else
            return -1;// 位置完全相同
    }
    ret = 4* pow(sin((w1 - w2) / 2), 2)- pow(sin((j1 - j2) / 2) * (cos(w1) - cos(w2)),2);
    ret = sqrt(ret);
    double temp = (sin(fabs(j1 - j2) / 2) * (cos(w1) + cos(w2)));
    ret = ret / temp;
    ret = atan(ret) / pi * 180;
    if (j1 > j2){ // 1为参考点坐标
        if (w1 > w2)
            ret += 180;
        else
            ret = 180 - ret;
    } else if (w1 > w2)
        ret = 360 - ret;
    return ret;
}
@end
