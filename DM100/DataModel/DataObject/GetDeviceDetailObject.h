//
//  GetDeviceDetailObject.h
//  CarConnection
//
//  Created by 林张宇 on 15/4/13.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetDeviceDetailObject : NSObject

@property (nonatomic,strong) NSString * imei;
@property (nonatomic,strong) NSString * enableDate;
@property (nonatomic,strong) NSString * platformExpire;
@property (nonatomic,strong) NSString * userExpire;
@property (nonatomic,strong) NSString * deviceSim;
@property (nonatomic,strong) NSString * model;
@property (nonatomic,strong) NSString * version;
@property (nonatomic,strong) NSString * carNumber;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * overSpeed;
@property (nonatomic,strong) NSString * ICCID;
@end
