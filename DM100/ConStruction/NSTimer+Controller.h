//
//  NSTimer+Controller.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/20.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Controller)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
