//
//  CarStatusObject.h
//  CarConnection
//
//  Created by 马真红 on 2018/11/14.
//  Copyright © 2018年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarStatusObject : NSObject
@property (strong, nonatomic)NSString * imei;
@property(nonatomic,assign)int alarmWarn;
@property(nonatomic,assign)int robberDefense;
@property(nonatomic,assign)int carDoor;
@property(nonatomic,assign)int carEngine;
@property(nonatomic,assign)int remoteStart;
@property(nonatomic,assign)int carWindow;
@property(nonatomic,assign)int airWindow;
@property(nonatomic,assign)int trunk;
@property(nonatomic,assign)int footBrake;
@property(nonatomic,assign)int autoInspect;
@property(nonatomic,assign)int suona;
@property(nonatomic,assign)int lightFlash;
@property(nonatomic,assign)int autoLock;
@property(nonatomic,assign)int remoteTime;
@property(nonatomic,assign)int airCondition;
@property(nonatomic,assign)int carLight;
@property(nonatomic,assign)int temperature;
@property(nonatomic,assign)int brakeTime;
@property(nonatomic,assign)int engineSpeed;
@property(nonatomic,assign)int plusSpeed;
@property(nonatomic,assign)int accSts;
@property(nonatomic,assign)int powerOn;
@property(nonatomic,assign)int voltageLevel;
@property(nonatomic,assign)int gsmStrength;
@property(nonatomic,assign)float lo;
@property(nonatomic,assign)float la;

@property(nonatomic,assign)float averageOil;
@property(nonatomic,assign)float oilMass;
@property (strong, nonatomic)NSString * online;
@property (strong, nonatomic)NSString * plateNumber;

@property (strong, nonatomic)NSString * lastTripStartTime;
@property (strong, nonatomic)NSString * lastTripEndTime;

-(NSString*)getTitleDescribe;
-(NSString*)getFuelViewDescribe;
-(NSString*)getDescribeByaverageOil;
-(NSString*)getFuelViewDescribe2;
-(void)setInitData:(CarStatusObject*) mCarStatusObject;
//-(Boolean)checkIsOktoXihuoCMD;
@end

NS_ASSUME_NONNULL_END
