//
//  ElectronicFenceService.m
//  CarConnection
//
//  Created by 林张宇 on 15/4/10.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "ElectronicFenceService.h"
#define IMEI @"imei"
#define RADIUS @"radius"

@implementation ElectronicFenceService

+ (void)electronicFenceServiceWithImei:(NSString *)imei radius:(NSString *)radius succeed:(void (^)(ElectronicFenceObject *))succeed failure:(void (^)(NSError *))failure
{
    NSDictionary * data = @{
                            IMEI:imei,
                            RADIUS:radius
                            };
    NSDictionary * parameters = [PostXMLDataCreater createXMLDicWithCMD:11 withParameters:data];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject * responseobject){
                   ElectronicFenceObject * electronicFenceObject = [[ElectronicFenceObject alloc] init];
                   electronicFenceObject.succeedOrNot = (NSString *)responseobject.ret;
                   succeed(electronicFenceObject);
               }
               failure:^(NSError * error){
                   failure(error);
               }];
}

@end
