//
//  APCalloutMapAnnotation.m
//  domilink
//
//  Created by 马真红 on 2020/5/14.
//  Copyright © 2020 aika. All rights reserved.
//

#import "APCalloutMapAnnotation.h"

@implementation APCalloutMapAnnotation
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
