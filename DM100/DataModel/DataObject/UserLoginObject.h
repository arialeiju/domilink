//
//  UserLoginObject.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/8.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginObject : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray *imeiList;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *loginNo;
@property (nonatomic, strong) NSString *username;
@end
