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
@end
