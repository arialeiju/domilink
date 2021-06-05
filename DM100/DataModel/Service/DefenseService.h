//
//  DefenseService.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/9.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

typedef enum : NSUInteger {
    DefenseTypeSet,
    DefenseTypeRemove
} DefenseType;

@interface DefenseService : NSObject

+ (void)setDefenseWithImei:(NSString *)imei
           withDefenseType:(DefenseType)defenseType
                   success:(void(^)(ResponseObject *))success
                   failure:(void(^)(NSError *error))failure;

+ (void)setDefenseWithImei:(NSString *)imei
           withDefenseType:(DefenseType)defenseType
           withUserid:(NSString *)userid
                   success:(void (^)(ResponseObject *))success
                   failure:(void (^)(NSError *))failure;
@end
