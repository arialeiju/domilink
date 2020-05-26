//
//  HistoryTrackViewController.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/16.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RefreshableTableView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@interface HistoryTrackViewController : UIViewController<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet RefreshableTableView *messageCenterTableView;
@property (strong, nonatomic) NSMutableArray * messageArray;
- (id)initWithImei:(NSString *)imei Withlalo:(CLLocationCoordinate2D)Coor;
- (id)initWithImei:(NSString *)imei Withlalo:(CLLocationCoordinate2D)Coor WithStart:(NSString *)mstartstr WithEnd:(NSString *)mendstr;
@end
