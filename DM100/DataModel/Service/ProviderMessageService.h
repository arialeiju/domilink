//
//  ProviderMessageService.h
//  domilink
//
//  Created by 马真红 on 2020/2/14.
//  Copyright © 2020 aika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"
#import "ProviderMessageObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProviderMessageService : NSObject
+ (void)provideMessageWithUserId:(NSString *)userId andloginType:(NSString *)loginType andloginNo:(NSString *)loginNo succeed:(void (^)(ProviderMessageObject *))succeed faiure:(void (^)(NSError *))failure;
@end

NS_ASSUME_NONNULL_END
