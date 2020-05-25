//
//  CarAlarmService.h
//  CarConnection
//
//  Created by 林张宇 on 15/4/23.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"
#import "CarAlarmObject.h"

@interface CarAlarmService : NSObject

+ (void)CarAlarmWithType:(NSString *)type
                 loginNo:(NSString *)loginNo
                  pageno:(NSString *)pageno
                 succeed:(void(^)(CarAlarmObject * carAlarmObject))succeed
                 failure:(void(^)(NSError * error))failure;

@end
