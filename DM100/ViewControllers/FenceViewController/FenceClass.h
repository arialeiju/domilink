//
//  FenceClass.h
//  DM100
//
//  Created by 马真红 on 2021/10/12.
//  Copyright © 2021 aika. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FenceClass : NSObject
@property(nonatomic,assign)int fenceId;
@property (nonatomic,strong)NSString * fenceName;

@property(nonatomic,assign)double latitude;
@property(nonatomic,assign)double longitude;
@property(nonatomic,assign)int radius;
@property(nonatomic,assign)int isEnterAlarm;
@property(nonatomic,assign)int isLeaveAlarm;
@end

NS_ASSUME_NONNULL_END
