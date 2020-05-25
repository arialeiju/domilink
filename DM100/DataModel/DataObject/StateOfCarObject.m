//
//  StateOfCarObject.m
//  CarConnection
//
//  Created by 林张宇 on 15/5/5.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "StateOfCarObject.h"

@implementation StateOfCarObject

@synthesize
name,
totalMiles,
leftFrontDoor,
leftBackDoor,
rightFrontDoor,
rightBackDoor,
backDoor,
leftFrontWindow,
leftBackWindow,
rightFrontWindow,
rightBackWindow,
skyWindow,
frontLight,
frogLight,
backLight,
warnLight,
indoorLight;

- (BOOL)isLeftFrontDoor
{
    return [self.leftFrontDoor boolValue];
}

- (BOOL)isLeftBackDoor
{
    return [self.leftBackDoor boolValue];
}

- (BOOL)isRightFrontDoor
{
    return [self.rightFrontDoor boolValue];
}

- (BOOL)isRightBackDoor
{
    return [self.rightBackDoor boolValue];
}

- (BOOL)isBackDoor
{
    return [self.backDoor boolValue];
}

- (BOOL)isLeftFrontWindow
{
    return [self.leftFrontWindow boolValue];
}

- (BOOL)isLeftBackWindow
{
    return [self.leftBackWindow boolValue];
}

- (BOOL)isRightFrontWindow
{
    return [self.rightFrontWindow boolValue];
}

- (BOOL)isRightBackWindow
{
    return [self.rightBackWindow boolValue];
}

- (BOOL)isSkyWindow
{
    return [self.skyWindow boolValue];
}

- (BOOL)isFrontLight
{
    return [self.frontLight boolValue];
}

- (BOOL)isFrogLight
{
    return [self.frogLight boolValue];
}

- (BOOL)isBackLight
{
    return [self.backLight boolValue];
}

- (BOOL)isWarnLight
{
    return [self.warnLight boolValue];
}

- (BOOL)isIndoorLight
{
    return [self.indoorLight boolValue];
}

- (BOOL)isActivate
{
    return [self.activate boolValue];
}
@end

