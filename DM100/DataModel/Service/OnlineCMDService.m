//
//  OnlineCMDService.m
//  CarConnection
//
//  Created by 马真红 on 16/5/25.
//  Copyright © 2016年 gemo. All rights reserved.
//

#import "OnlineCMDService.h"
@implementation OnlineCMDService


#define kImei    @"imei"
#define kSmscmd  @"smscmd"
#define kuserid  @"userid"
+ (void)setCMDwithImei:(NSString *)imei
                        withSmscmd:(NSString *)smscmd
                         succeed:(void (^)(OnlineCMDObject *))succeed
                        failure:(void (^)(NSError *))failure
{
    NSDictionary *dataBody = @{kImei:imei,
                               kSmscmd:smscmd};
    
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:106
                                                       withParameters:dataBody];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *responseObject) {
                   OnlineCMDObject * messageCenterObject = [[OnlineCMDObject alloc] initWithJSON:responseObject.ret];
                   succeed(messageCenterObject);
               }
               failure:^(NSError *error) {
                   failure(error);
               }];
}

+ (void)setCMDwithImei:(NSString *)imei
                        withSmscmd:(NSString *)smscmd
                        withUserid:(NSString *)userid
                         succeed:(void (^)(OnlineCMDObject *))succeed
                        failure:(void (^)(NSError *))failure
{
    NSDictionary *dataBody = @{kImei:imei,
                               kSmscmd:smscmd,
                               kuserid:userid};
    
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:106
                                                       withParameters:dataBody];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *responseObject) {
                   OnlineCMDObject * messageCenterObject = [[OnlineCMDObject alloc] initWithJSON:responseObject.ret];
                   succeed(messageCenterObject);
               }
               failure:^(NSError *error) {
                   failure(error);
               }];
}
@end
