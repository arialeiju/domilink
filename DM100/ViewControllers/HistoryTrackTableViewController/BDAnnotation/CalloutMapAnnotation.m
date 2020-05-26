//
//  CalloutMapAnnotation.m
//  CarConnection
//
//  Created by 马真红 on 15/10/10.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "CalloutMapAnnotation.h"

@implementation CalloutMapAnnotation


@synthesize latitude;
@synthesize longitude;
@synthesize locationInfo;

- (id)initWithLatitude:(CLLocationDegrees)lat
          andLongitude:(CLLocationDegrees)lon {
    if (self = [super init]) {
        self.latitude = lat;
        self.longitude = lon;
    }
    return self;
}


-(CLLocationCoordinate2D)coordinate{
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    
    return coordinate;
    
    
}
@end
