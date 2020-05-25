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

-(NSString*)getDescribeBystsTime;
-(NSString*)getDescribeBylocateSts;
-(NSString*)getDescribeBylalo;
@end
