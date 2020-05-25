//
//  StateOfDeviceObject.h
//  CarConnection
//
//  Created by 林张宇 on 15/4/8.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateOfDeviceObject : NSObject
// 当天里程数
@property (nonatomic,strong)NSString * mileage;
// 1代表布防、0代表撤防
@property (nonatomic,strong)NSString * status;
// 设备电量
@property (nonatomic,strong)NSString * power;

@property (nonatomic,strong)NSString * online;
@property (nonatomic,strong)NSString * platformexpire;
@property (nonatomic,strong)NSString * flowexpire;

@property(nonatomic,assign)double la;//里程，（公里）
@property(nonatomic,assign)double lo;//超速次数
@property(nonatomic,assign)int course;//

@end
