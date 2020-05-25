//
//  UserLoginService.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/8.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "UserLoginService.h"

#define kLoginNo  @"loginNo"
#define kpassword @"password"

@implementation UserLoginService

+ (void)loginWithUserName:(NSString *)username
                 password:(NSString *)password
                  succeed:(void (^)(UserLoginObject *))succeed
                  failure:(void (^)(NSError *))failure
{
    NSDictionary *bodyData = @{kLoginNo:username,
                               kpassword:password};
    
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:100
                                                        withParameters:bodyData];
    
    
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *responseObject)
    {
        
        UserLoginObject *object = [[UserLoginObject alloc] initWithJSON:(NSDictionary *)responseObject.ret];
        NSLog(@"test=%@",responseObject.ret);
        succeed(object);
    }
               failure:^(NSError *error)
    {
        failure(error);
    }];
}



@end
