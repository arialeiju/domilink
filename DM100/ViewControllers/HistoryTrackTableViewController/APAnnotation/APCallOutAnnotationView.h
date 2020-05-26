//
//  APCallOutAnnotationView.h
//  domilink
//
//  Created by 马真红 on 2020/5/14.
//  Copyright © 2020 aika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusPointCell.h"
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface APCallOutAnnotationView : MKAnnotationView
@property(nonatomic,retain) UIView *contentView;

//添加一个UIView
@property(nonatomic,retain) BusPointCell *busInfoView;//在创建calloutView Annotation时，把contentView add的 subview赋值给businfoView
@end

NS_ASSUME_NONNULL_END
