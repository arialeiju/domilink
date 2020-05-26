//
//  APCustomPointAnnotation.h
//  domilink
//
//  Created by 马真红 on 2020/5/14.
//  Copyright © 2020 aika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface APCustomPointAnnotation : MKPointAnnotation
@property(retain,nonatomic)NSDictionary * pointCalloutInfo;
@end

NS_ASSUME_NONNULL_END
