//
//  ElectronicFenceService.h
//  CarConnection
//
//  Created by 林张宇 on 15/4/10.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElectronicFenceObject.h"
#import "BaseService.h"

@interface ElectronicFenceService : NSObject

+ (void)electronicFenceServiceWithImei:(NSString *)imei
                                radius:(NSString *)radius
                               succeed:(void(^)(ElectronicFenceObject * electronicFenceObject))succeed
                               failure:(void(^)(NSError * error))failure;

@end
