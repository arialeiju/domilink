//
//  GetDeviceDetailService.m
//  CarConnection
//
//  Created by 林张宇 on 15/4/13.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "GetDeviceDetailService.h"
#define IMEI @"imei"

@implementation GetDeviceDetailService

+ (void)GetDeviceDetailWithImei:(NSString *)imei succeed:(void (^)(GetDeviceDetailObject *))succeed failure:(void (^)(NSError *))failure
{
    NSDictionary * data = @{IMEI:imei};
    NSDictionary * parameters = [PostXMLDataCreater createXMLDicWithCMD:10 withParameters:data];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject * responseObject){
                   if(responseObject == nil || responseObject.ret == nil)
                   {
                       failure(nil);
                       return;
                   }
                   GetDeviceDetailObject * getDeviceDetailObject = [[GetDeviceDetailObject alloc] initWithJSON:responseObject.ret];
                   succeed(getDeviceDetailObject);
               }
               failure:^(NSError * error){
                   failure(error);
               }];
}

@end
