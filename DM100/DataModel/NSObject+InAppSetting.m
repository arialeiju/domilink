//
//  NSObject+InAppSetting.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/3/31.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "NSObject+InAppSetting.h"

@implementation NSObject (InAppSetting)

- (InAppSetting *)inAppSetting
{
    return [InAppSetting instance];
}

- (MainDataModel *)dataModel
{
    return [MainDataModel instance];
}

@end
