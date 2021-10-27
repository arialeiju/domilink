//
//  CarAlarmService.m
//  CarConnection
//
//  Created by 林张宇 on 15/4/23.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "CarAlarmService.h"
#define TYPE @"type"
#define LOGINNO @"loginNo"
#define PAGENO @"pageno"
#define LANG @"language"
@implementation CarAlarmService

+ (void)CarAlarmWithType:(NSString *)type loginNo:(NSString *)loginNo pageno:(NSString *)pageno succeed:(void (^)(CarAlarmObject *))succeed failure:(void (^)(NSError *))failure
{
    NSDictionary * data = @{
                            TYPE:type,
                            LOGINNO:loginNo,
                            PAGENO:pageno
                            };
    NSDictionary * parameters = [PostXMLDataCreater createXMLDicWithCMD:23 withParameters:data];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *responseObject) {
                   CarAlarmObject * carAlarmObject = [[CarAlarmObject alloc] initWithJSON:responseObject.ret];
                   succeed(carAlarmObject);
               }
               failure:^(NSError *error) {
                   failure(error);
               }];
}

+ (void)CarAlarmWithType:(NSString *)type loginNo:(NSString *)loginNo language:(NSString*)language pageno:(NSString *)pageno succeed:(void (^)(CarAlarmObject *))succeed failure:(void (^)(NSError *))failure
{
    NSDictionary * data = @{
                            TYPE:type,
                            LOGINNO:loginNo,
                            LANG:language,
                            PAGENO:pageno
                            };
    NSDictionary * parameters = [PostXMLDataCreater createXMLDicWithCMD:23 withParameters:data];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *responseObject) {
                   CarAlarmObject * carAlarmObject = [[CarAlarmObject alloc] initWithJSON:responseObject.ret];
                   succeed(carAlarmObject);
               }
               failure:^(NSError *error) {
                   failure(error);
               }];
}

@end
