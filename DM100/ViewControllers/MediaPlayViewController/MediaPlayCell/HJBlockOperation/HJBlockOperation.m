//
//  HJBlockOperation.m
//  CarConnection
//
//  Created by 马真红 on 2018/9/4.
//  Copyright © 2018年 gemo. All rights reserved.
//

#import "HJBlockOperation.h"

@implementation HJBlockOperation
-(void)main
{
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        
        _hjConcurrent =YES;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.myBlock(self);
        }];
        
    }
}

-(void)continueWithBlock:(continueBlock)blk
{
    if (blk) {
        self.myBlock = blk;
    }
}

- (void)setHjFinished:(BOOL)hjFinished
{
    [self willChangeValueForKey:@"isFinished"];
    _hjFinished = hjFinished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setHjExecuting:(BOOL)hjExecuting
{
    [self willChangeValueForKey:@"isExecuting"];
    _hjExecuting = hjExecuting;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setHjConcurrent:(BOOL)hjConcurrent
{
    _hjConcurrent = hjConcurrent;
}

@end
