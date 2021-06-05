//
//  HistoryLocationObject.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/15.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryLocationObject : NSObject

@property (nonatomic, strong) NSString *course;
@property (nonatomic, strong) NSString *lo;
@property (nonatomic, strong) NSString *la;
@property (nonatomic, strong) NSString *speed;
@property (nonatomic, strong) NSString *stsTime;
@property (nonatomic, strong) NSString *deviceSts;
@property (nonatomic, strong) NSString *locateSts;
@property(nonatomic,assign)float altitude;
@property(nonatomic,assign)int accuracyType;//（0 无 1普通定位、 2差分定位、 4固定解定位、 5浮点定位、 6推算定位）
-(NSString*)getDescribeBystsTime;
-(NSString*)getDescribeBylocateSts;
-(NSString*)getDescribeBylalo;
-(NSString*)getAccuracyType;
-(NSString*)getaAltitude;
@end
