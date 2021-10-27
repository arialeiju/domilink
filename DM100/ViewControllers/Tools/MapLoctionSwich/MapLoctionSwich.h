//
//  MapLoctionSwich.h
//  domilink
//
//  Created by 马真红 on 2020/5/13.
//  Copyright © 2020 aika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MapLoctionSwich : NSObject
+(CLLocationCoordinate2D)bd09togcj02:(float)bd_lon and:(float)bd_lat;
+(NSArray *)gcjToWGS:(double)bd_lat and:(double)bd_lon;
+(CLLocationCoordinate2D)wgs84ToGcj02:(double)ggLat bdLon:(double)ggLon;
@end

NS_ASSUME_NONNULL_END
