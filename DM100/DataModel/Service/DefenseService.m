//
//  DefenseService.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/9.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "DefenseService.h"

#define kiMei @"imei"
#define kSts  @"sts"

@implementation DefenseService

+ (void)setDefenseWithImei:(NSString *)imei
           withDefenseType:(DefenseType)defenseType
                   success:(void (^)(ResponseObject *))success
                   failure:(void (^)(NSError *))failure
{
    NSString *defenseCode = nil;
    switch (defenseType)
    {
        case DefenseTypeSet:
            defenseCode = @"1";
            break;
        case DefenseTypeRemove:
            defenseCode = @"0";
            break;
        default:
            break;
    }
    
    NSDictionary *bodyData = @{kiMei:imei,
                               kSts:defenseCode};
    NSDictionary *parameter = [PostXMLDataCreater createXMLDicWithCMD:58
                                                       withParameters:bodyData];
    
    [NetWorkModel POST:ServerURL
            parameters:parameter
               success:^(ResponseObject *responseObject) {
                   NSLog(@"responseObject=%@",responseObject.ret);
//                   if ([(NSString *)responseObject.ret isEqualToString:@"1"])
//                   {
//                       success(YES);
//                   }
//                   else if ([(NSString *)responseObject.ret isEqualToString:@"0"])
//                   {
//                       success(YES);
//                   }
//                   else
//                   {
//                       success(NO);
//                   }
                   success(responseObject);
               }
               failure:^(NSError *error) {
                   failure(error);
               }];
}


@end
