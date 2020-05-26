//
//  CustomPointAnnotation.h
//  CarConnection
//
//  Created by 马真红 on 15/10/9.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface CustomPointAnnotation : BMKPointAnnotation
@property(retain,nonatomic)NSDictionary * pointCalloutInfo;
@end
