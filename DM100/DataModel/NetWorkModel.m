//
//  NetWorkModel.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/8.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "NetWorkModel.h"

@implementation NetWorkModel

+ (instancetype)netWorkModel
{
    static dispatch_once_t pred = 0;
    __strong static NetWorkModel *netWorkModel = nil;
    dispatch_once(&pred, ^
    {
        netWorkModel = [[NetWorkModel alloc] init];
    });
    return netWorkModel;
}

+ (void)POST:(NSString *)urlString
  parameters:(id)parameters
     success:(void (^)(ResponseObject *))success
     failure:(void (^)(NSError *))failure
{
    // manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Serializers
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    AFJSONResponseSerializer *responseSerializer = [[MUResponseSerializer alloc] initWithResponseClass:[ResponseObject class]];
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain", nil]];
     //[responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    //[responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
   // manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    // set Serializers
    [manager setRequestSerializer:requestSerializer];
    [manager setResponseSerializer:responseSerializer];
    
    [manager POST:urlString
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        success(responseObject);
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        failure(error);
    }];
}

@end
