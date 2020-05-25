//
//  NetWorkModel.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/8.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ResponseObject.h"
#import "MUResponseSerializer.h"

@interface NetWorkModel : NSObject

+ (instancetype)netWorkModel;

+ (void)POST:(NSString *)urlString
  parameters:(id)parameters
     success:(void (^)(ResponseObject *responseObject))success
     failure:(void (^)(NSError *error))failure;

@end
