//
//  MapLoctionSwich.m
//  domilink
//
//  Created by 马真红 on 2020/5/13.
//  Copyright © 2020 aika. All rights reserved.
//

#import "MapLoctionSwich.h"
#define x_PI  (3.14159265358979324 * 3000.0 / 180.0)
#define PI  3.1415926535897932384626
#define a  6378245.0
#define ee 0.00669342162296594323
@implementation MapLoctionSwich
/**
 * 百度坐标系 (BD-09) 与 火星坐标系 (GCJ-02)的转换
 * 即 百度 转 谷歌、高德
 * @param bd_lon
 * @param bd_lat
 * @returns {*[]}
 */
+(CLLocationCoordinate2D)bd09togcj02:(float)bd_lon and:(float)bd_lat
{
    
  //中国的经纬度范围是，东经七十三度，到东经一百三十五度，北纬四度，到北纬五十三度。
  if(bd_lon>72&&bd_lon<136&&bd_lat>3&&bd_lat<54)
  {
      float x_pi = 3.14159265358979324 * 3000.0 / 180.0;
      float x = bd_lon - 0.0065;
      float y = bd_lat - 0.006;
      float z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
      float theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
      float gg_lng = z * cos(theta);
      float gg_lat = z * sin(theta);
       CLLocationCoordinate2D reCoor=CLLocationCoordinate2DMake(gg_lat, gg_lng);
        return reCoor;
  }else
  {
      CLLocationCoordinate2D reCoor=CLLocationCoordinate2DMake(bd_lat, bd_lon);
      return reCoor;
  }
}

/**
 高德坐标转系统自带坐标

 @return 数组【转换后的纬度，转换后的经度】
 */
+ (NSArray *)gcjToWGS:(double)bd_lat and:(double)bd_lon{
    double lat = bd_lat;
    double lon = bd_lon;
    if ([self outOfChinalat:lat lon:lon]){
        return @[[NSNumber numberWithDouble:lat],[NSNumber numberWithDouble:lon]];
    }
    NSArray *latlon = [self deltalat:lat lon:lon];
    return latlon;
}

+ (BOOL)outOfChinalat:(double)lat lon:(double)lon {
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

+ (NSArray *)deltalat:(double)wgLat lon:(double)wgLon {
    double OFFSET = 0.00669342162296594323;
    double AXIS = 6378245.0;
    
    double dLat = [self transformLatx:(wgLon - 105.0) lon:(wgLat - 35.0)];
    double dLon = [self transformLonx:(wgLon - 105.0) lon:(wgLat - 35.0)];
    double radLat = wgLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - OFFSET * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((AXIS * (1 - OFFSET)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (AXIS / sqrtMagic * cos(radLat) * M_PI);
    return @[[NSNumber numberWithDouble:(wgLat - dLat)],[NSNumber numberWithDouble:(wgLon - dLon)]];
}

+ (double)transformLatx:(double)x lon:(double)y {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

+ (double)transformLonx:(double)x lon:(double)y {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

+ (CLLocationCoordinate2D)wgs84ToGcj02:(double)ggLat bdLon:(double)ggLon
{
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    if ([self outOfChinalat:ggLat lon:ggLon]) {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }
    double dLat = [self transformLatx:(ggLon - 105.0)lon:(ggLat - 35.0)];
    double dLon = [self transformLonx:(ggLon - 105.0) lon:(ggLat - 35.0)];
    double radLat = ggLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    mgLat = ggLat + dLat;
    mgLon = ggLon + dLon;
    
    resPoint.latitude = mgLat;
    resPoint.longitude = mgLon;
    return resPoint;
}
@end
