//
//  ReportFormObject.h
//  CarConnection
//
//  Created by 马真红 on 17/8/9.
//  Copyright © 2017年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportFormObject : NSObject
@property(nonatomic,assign)NSInteger timeDiffer;//时间间隔，有 日／周／月 三种
@property(nonatomic,assign)int mileage;//里程，（公里）
@property(nonatomic,assign)int speedtime;//超速次数
@property(nonatomic,assign)int stoptime;//停留次数
@end
