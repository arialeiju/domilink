//
//  DeviceDetailObject.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/9.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceDetailObject : NSObject

@property (nonatomic, strong) NSString *devImei;
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, strong) NSString *devSts;
@property (nonatomic, strong) NSString *devName;
@property (nonatomic, strong) NSString *devType;
@property (nonatomic, strong) NSString *useSts;
@property (nonatomic, strong) NSString *sigTime;
@property (nonatomic, strong) NSString *speed;
@property (nonatomic, strong) NSString *locTime;
@property (nonatomic, strong) NSString *logoType;
@property (nonatomic, strong) NSString *la;
@property (nonatomic, strong) NSString *lo;
@property (nonatomic, strong) NSString *course;
@property (nonatomic, strong) NSString *sts;//描述状态  静止/行驶中/过期
@property (nonatomic, strong) NSString *timests;//时间描述 距离还有多久
@end
