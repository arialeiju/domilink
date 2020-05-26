//
//  CalloutMapAnnotation.h
//  CarConnection
//
//  Created by 马真红 on 15/10/10.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface CalloutMapAnnotation : NSObject<BMKAnnotation>


@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;


@property(retain,nonatomic) NSDictionary *locationInfo;//callout吹出框要显示的各信息



- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon;



@end
