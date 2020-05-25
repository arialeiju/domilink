//
//  ResponseObject.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/8.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseObject : NSObject

@property (nonatomic, strong) NSString *cmd;
@property (nonatomic, strong) NSDictionary *ret;

@end
