//
//  APCalloutMapAnnotation.h
//  domilink
//
//  Created by 马真红 on 2020/5/14.
//  Copyright © 2020 aika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface APCalloutMapAnnotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;


@property(retain,nonatomic) NSDictionary *locationInfo;//callout吹出框要显示的各信息



- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon;
@end

NS_ASSUME_NONNULL_END
