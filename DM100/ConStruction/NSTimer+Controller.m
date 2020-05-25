//
//  NSTimer+Controller.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/20.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "NSTimer+Controller.h"

@implementation NSTimer (Controller)

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}

-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
