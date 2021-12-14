//
//  UnitModel.h
//  domilink
//
//  Created by 马真红 on 2020/2/16.
//  Copyright © 2020 aika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StsShowModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UnitModel : NSObject
@property (nonatomic, strong) NSString *devImei;
@property (nonatomic, strong) NSString *devName;
@property (nonatomic, strong) NSString *carNumber;
@property (nonatomic, strong) NSString *devType;
@property (nonatomic, strong) NSString *devSts;
@property (nonatomic, strong) NSString *useSts;
@property (nonatomic, strong) NSString *sigTime;
@property (nonatomic, strong) NSString *locTime;
@property (nonatomic, strong) NSString *la;
@property (nonatomic, strong) NSString *lo;
@property (nonatomic, strong) NSString *course;
@property (nonatomic, strong) NSString *logoType;
@property (nonatomic, strong) NSString *isDefense;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) int isActivate;//是否激活
-(NSString*)getShowName;
-(NSString*)getImei;
-(NSString*)getName;
-(NSString*)getCarNumber;
-(NSString*)getsigTime;
-(NSString*)getlocTime;
-(double)getLat;
-(double)getLot;
-(UIImage*)getImage;
-(StsShowModel*)getShowStatu;
@end

NS_ASSUME_NONNULL_END
