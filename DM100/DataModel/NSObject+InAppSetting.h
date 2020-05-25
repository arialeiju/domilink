//
//  NSObject+InAppSetting.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/3/31.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InAppSetting.h"
#import "MainDataModel.h"

@interface NSObject (InAppSetting)

@property (nonatomic, readonly) InAppSetting *inAppSetting;
@property (nonatomic, readonly) MainDataModel *dataModel;

@end
