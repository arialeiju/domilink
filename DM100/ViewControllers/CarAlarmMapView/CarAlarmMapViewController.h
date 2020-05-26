//
//  CarAlarmMapViewController.h
//  CarConnection
//
//  Created by 林张宇 on 15/5/21.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

@interface CarAlarmMapViewController : UIViewController
@property (nonatomic, strong) BMKMapView *mapView;

- (id)initWithType:(NSDictionary *)dictionary;

@end
