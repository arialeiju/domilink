//
//  HistoryTrackService.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/15.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"
#import "HistoryLocationObject.h"

@interface HistoryTrackService : NSObject

+ (void)getHistoryTrackWithImei:(NSString *)imei
                  withStartTime:(NSString *)startTime
                    withEndTime:(NSString *)endTime
                    withSpe:(NSString *)spe
                   withJZStatus:(BOOL)isGuolvJZ
                    withWifiStatus:(BOOL)isGuolvWifi
                        success:(void(^)(NSArray *array))success
                        failure:(void(^)(NSError *error))failure;
+(double)getAngleLat1:(double)lat1 withLng1:(double)lng1 withLat2:(double)lat2 withLng2:(double)lng2;

@end
