//
//  GetDeviceDetailService.h
//  CarConnection
//
//  Created by 林张宇 on 15/4/13.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"
#import "GetDeviceDetailObject.h"

@interface GetDeviceDetailService : NSObject

+ (void)GetDeviceDetailWithImei:(NSString *)imei
                        succeed:(void(^)(GetDeviceDetailObject * getDeviceDetailObject))succeed
                        failure:(void(^)(NSError * error))failure;

@end
