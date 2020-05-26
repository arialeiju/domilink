//
//  CallOutAnnotationView.h
//  CarConnection
//
//  Created by 马真红 on 15/10/10.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "BusPointCell.h"

@interface CallOutAnnotationView : BMKAnnotationView


@property(nonatomic,retain) UIView *contentView;

//添加一个UIView
@property(nonatomic,retain) BusPointCell *busInfoView;//在创建calloutView Annotation时，把contentView add的 subview赋值给businfoView
@end
