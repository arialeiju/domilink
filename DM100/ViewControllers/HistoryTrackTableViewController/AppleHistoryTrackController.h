//
//  AppleHistoryTrackController.h
//  domilink
//
//  Created by 马真红 on 2020/5/14.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "RefreshableTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface AppleHistoryTrackController : UIViewController<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet RefreshableTableView *messageCenterTableView;
@property (strong, nonatomic) NSMutableArray * messageArray;
- (id)initWithImei:(NSString *)imei Withlalo:(CLLocationCoordinate2D)Coor;
- (id)initWithImei:(NSString *)imei Withlalo:(CLLocationCoordinate2D)Coor WithStart:(NSString *)mstartstr WithEnd:(NSString *)mendstr;
@end

NS_ASSUME_NONNULL_END
