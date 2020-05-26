//
//  AppleAlarmMapViewController.h
//  domilink
//
//  Created by 马真红 on 2020/5/12.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AppleAlarmMapViewController : UIViewController
@property (strong, nonatomic) MKMapView *mapView;
- (id)initWithType:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
