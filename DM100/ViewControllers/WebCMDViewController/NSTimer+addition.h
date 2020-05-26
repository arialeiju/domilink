//
//  UIView+Frame.h
//  CarConnection
//
//  Created by 马真红 on 17/11/21.
//  Copyright © 2017年 gemo. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSTimer (addition)

- (void)pause;
- (void)resume;
- (void)resumeWithTimeInterval:(NSTimeInterval)time;

+ (NSTimer *)wy_scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void(^)(NSTimer *timer))block;

@end
