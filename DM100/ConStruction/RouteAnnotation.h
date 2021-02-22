//
//  RouteAnnotation.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/6/2.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}
@property (nonatomic) int type;
@property (nonatomic) int degree;
@end
