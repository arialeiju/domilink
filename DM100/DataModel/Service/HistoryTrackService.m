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
        
        //基站过滤
        if (isGuolvJZ) {
            for (NSDictionary *dic in responseArray)
            {
                HistoryLocationObject *histroyPoint = [[HistoryLocationObject alloc] initWithJSON:dic];
                if (! [histroyPoint.locateSts isEqualToString:@"1"]) {
                     [newArray addObject:histroyPoint];
                }
            }
        }else
        {
          for (NSDictionary *dic in responseArray)
          {
              HistoryLocationObject *histroyPoint = [[HistoryLocationObject alloc] initWithJSON:dic];
              [newArray addObject:histroyPoint];
          }
        }
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

@end
