//
//  AppleAlarmAnnotationView.m
//  domilink
//
//  Created by 马真红 on 2020/5/13.
//  Copyright © 2020 aika. All rights reserved.
//

#import "AppleAlarmAnnotationView.h"

@implementation AppleAlarmAnnotationView

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
  
      
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            
            self.calloutView = [[CarAlarmPaopaoView alloc]init];
            self.calloutView.frame = CGRectMake(0, 0, 277, 135);
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        
        [self addSubview:self.calloutView];
    }
    return self;
  
}
@end
