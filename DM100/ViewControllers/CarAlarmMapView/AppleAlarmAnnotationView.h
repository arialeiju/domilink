//
//  AppleAlarmAnnotationView.h
//  domilink
//
//  Created by 马真红 on 2020/5/13.
//  Copyright © 2020 aika. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CarAlarmPaopaoView.h"
NS_ASSUME_NONNULL_BEGIN

@interface AppleAlarmAnnotationView : MKAnnotationView
@property (nonatomic, retain) CarAlarmPaopaoView *calloutView;
@end

NS_ASSUME_NONNULL_END
