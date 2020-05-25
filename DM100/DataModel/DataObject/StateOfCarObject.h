//
//  StateOfCarObject.h
//  CarConnection
//
//  Created by 林张宇 on 15/5/5.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateOfCarObject : NSObject

@property (strong, nonatomic)NSString * name;
@property (strong, nonatomic)NSString * totalMiles;

@property (strong, nonatomic)NSString * leftFrontDoor;
@property (strong, nonatomic)NSString * leftBackDoor;
@property (strong, nonatomic)NSString * rightFrontDoor;
@property (strong, nonatomic)NSString * rightBackDoor;
@property (strong, nonatomic)NSString * backDoor;
@property (strong, nonatomic)NSString * leftFrontWindow;
@property (strong, nonatomic)NSString * leftBackWindow;
@property (strong, nonatomic)NSString * rightFrontWindow;
@property (strong, nonatomic)NSString * rightBackWindow;
@property (strong, nonatomic)NSString * skyWindow;
@property (strong, nonatomic)NSString * frontLight;
@property (strong, nonatomic)NSString * frogLight;
@property (strong, nonatomic)NSString * backLight;
@property (strong, nonatomic)NSString * warnLight;
@property (strong, nonatomic)NSString * indoorLight;
@property (strong, nonatomic)NSString * activate;
- (BOOL)isLeftFrontDoor;
- (BOOL)isLeftBackDoor;
- (BOOL)isRightFrontDoor;
- (BOOL)isRightBackDoor;

- (BOOL)isBackDoor;

- (BOOL)isLeftFrontWindow;
- (BOOL)isLeftBackWindow;
- (BOOL)isRightFrontWindow;
- (BOOL)isRightBackWindow;

- (BOOL)isSkyWindow;
- (BOOL)isFrontLight;
- (BOOL)isFrogLight;
- (BOOL)isBackLight;
- (BOOL)isWarnLight;
- (BOOL)isIndoorLight;

- (BOOL)isActivate;

@end
