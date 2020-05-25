//
//  UserLoginService.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/8.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLoginObject.h"
#import "BaseService.h"

@interface UserLoginService : NSObject

+ (void)loginWithUserName:(NSString *)username
                 password:(NSString *)password
                  succeed:(void (^)(UserLoginObject * loginObject))succeed
                  failure:(void (^)(NSError *error))failure;


@end
