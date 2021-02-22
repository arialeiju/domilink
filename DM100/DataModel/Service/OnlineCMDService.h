//
//  OnlineCMDService.h
//  CarConnection
//
//  Created by 马真红 on 16/5/25.
//  Copyright © 2016年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnlineCMDObject.h"
@interface OnlineCMDService : NSObject
+ (void)setCMDwithImei:(NSString *)imei
            withSmscmd:(NSString *)smscmd
               succeed:(void (^)(OnlineCMDObject *))succeed
               failure:(void (^)(NSError *))failure;
@end
