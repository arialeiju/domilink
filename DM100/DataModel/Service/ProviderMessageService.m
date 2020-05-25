//
//  ProviderMessageService.m
//  domilink
//
//  Created by 马真红 on 2020/2/14.
//  Copyright © 2020 aika. All rights reserved.
//

#import "ProviderMessageService.h"
#define USERID @"userId"
@implementation ProviderMessageService
+ (void)provideMessageWithUserId:(NSString *)userId succeed:(void (^)(ProviderMessageObject *))succeed faiure:(void (^)(NSError *))failure
{
    NSDictionary * data = @{USERID:userId};
    NSDictionary * parameters = [PostXMLDataCreater createXMLDicWithCMD:9 withParameters:data];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject * responseObject)
     {
         ProviderMessageObject * object = [[ProviderMessageObject alloc]initWithJSON:responseObject.ret];
         succeed(object);
     }
               failure:^(NSError * error)
     {
         NSLog(@"getProvideMessageFail");
         failure(error);
     }];
}
@end
