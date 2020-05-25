//
//  DeviceLocationObject.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/13.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceLocationObject : NSObject

@property (nonatomic, strong) NSString *imei;
@property (nonatomic, strong) NSString *deviceSts;
@property (nonatomic, strong) NSString *speed;      
@property (nonatomic, strong) NSString *loEw;       // 东西经
@property (nonatomic, strong) NSString *lo;         // 经度
@property (nonatomic, strong) NSString *laNs;       // 南北纬
@property (nonatomic, strong) NSString *la;         // 纬度
@property (nonatomic, strong) NSString *course;     // 航向
@property (nonatomic, strong) NSString *accSts;     // acc状态
@property (nonatomic, strong) NSString *stsTime;    // 提交时间
@property (nonatomic, strong) NSString *radius;     //电子围栏半径
@property (nonatomic, strong) NSString *defense;     //是否布防
@property (nonatomic, strong) NSString * delon;
@property (nonatomic, strong) NSString * delat;
@property (nonatomic, strong) NSString * addr;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *power;
@property (nonatomic, strong) NSString *valt;
@property (nonatomic, strong) NSString *mode;
@property (nonatomic, strong) NSString *signalTime;


@property (nonatomic, strong) NSString *model1;
@property (nonatomic, strong) NSString *model2;

@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *devicetype;
@end
