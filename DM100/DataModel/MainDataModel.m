//
//  MainDataModel.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/3/31.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "MainDataModel.h"

@implementation MainDataModel

+ (instancetype)instance
{
    static dispatch_once_t pred = 0;
    __strong static MainDataModel *s_dataModel = nil;
    dispatch_once(&pred, ^
    {
        s_dataModel = [[MainDataModel alloc] init];
    });
    return s_dataModel;
}

-(NSString *) formatWithSeconds:(int) seconds
{
    int hour = seconds / (60 * 60);
    int minute = seconds / 60;
    int second = seconds % 60;
    
    NSString * sHour = hour > 9 ? [NSString stringWithFormat:@"%d",hour]:[NSString stringWithFormat:@"0%d",hour];
    NSString * sMinute = minute > 9 ? [NSString stringWithFormat:@"%d",minute]:[NSString stringWithFormat:@"0%d",minute];
    NSString * sSecond = second > 9 ? [NSString stringWithFormat:@"%d",second]:[NSString stringWithFormat:@"0%d",second];
    
    NSString * result = [NSString stringWithFormat:@"%@:%@:%@",sHour,sMinute,sSecond];
    return result;
}

-(NSString *) formatTimeSpan:(NSDate *) createdDate
{
    NSString * result;
    
    NSDate * nowDate = [NSDate date];
    NSTimeInterval timeSpanInSeconds = [nowDate timeIntervalSinceDate:createdDate];
    if(timeSpanInSeconds > 60 * 60 * 24 * 30 * 12)
    {
        result = [NSString stringWithFormat:@"%.0f年前",timeSpanInSeconds/(60 * 60 * 24 * 30 * 12)];
    }
    else if(timeSpanInSeconds > 60 * 60 * 24 * 30)
    {
        result = [NSString stringWithFormat:@"%.0f个月前",timeSpanInSeconds/(60 * 60 * 24 * 30)];
    }
    else if(timeSpanInSeconds > 60 * 60 * 24 )
    {
        result = [NSString stringWithFormat:@"%.0f天前",timeSpanInSeconds/(60 * 60 * 24)];
    }
    else if(timeSpanInSeconds > 60 * 60 )
    {
        result = [NSString stringWithFormat:@"%.0f小时前",timeSpanInSeconds/(60.0 * 60 )];
    }
    else if(timeSpanInSeconds > 60)
    {
        result = [NSString stringWithFormat:@"%.0f分钟前",timeSpanInSeconds/60.0];
    }
    else
    {
        result = [NSString stringWithFormat:@"%.0f秒前",timeSpanInSeconds];
    }
    return result;
}

- (NSString *)formatDurationTime:(int)seconds
{
    int tempSecond = seconds;
    NSString *durationStr = @"0秒";
    if (seconds > 0 && seconds < 60)
    {
        durationStr = [NSString stringWithFormat:@"%d秒", tempSecond];
    }
    else if (seconds >= 60 && seconds < 60*60)
    {
        tempSecond /= 60;
        durationStr = [NSString stringWithFormat:@"%d分钟", tempSecond];
    }
    else if (seconds >= 3600 && seconds < 60 * 60 * 24)
    {
        CGFloat hour = (float)tempSecond / 3600.0f;
        durationStr = [NSString stringWithFormat:@"%.1f小时", hour];
    }
    else if (seconds >= 60*60*24)
    {
        CGFloat day = (float)tempSecond / (float)(60*60*24);
        durationStr = [NSString stringWithFormat:@"%.1f天", day];
    }
    
    return durationStr;
}

- (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    // trim off whitespace
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

-(UIImage *) scaleImage:(UIImage *) sourceImage width:(double) width
{
//    NSData * data = UIImagePNGRepresentation(sourceImage);
//    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef) data, NULL);
//
//    CFDictionaryRef options = (CFDictionaryRef)CFBridgingRetain([[NSDictionary alloc] initWithObjectsAndKeys:(id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailWithTransform, (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageAlways, (id)[NSNumber numberWithDouble:width], (id)kCGImageSourceThumbnailMaxPixelSize, nil]);
//
//    CGImageRef scaledImageRef = CGImageSourceCreateThumbnailAtIndex(src, 0, options);
//
//    UIImage * imageScaled = [UIImage imageWithCGImage:scaledImageRef];
//    CFRelease(options);
//    CFRelease(src);
//    CFRelease(scaledImageRef);
//    return imageScaled;
    UIGraphicsBeginImageContext(CGSizeMake(sourceImage.size.width * width, sourceImage.size.height * width));
                                [sourceImage drawInRect:CGRectMake(0, 0, sourceImage.size.width * width, sourceImage.size.height * width)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                return scaledImage;
}

- (char)pinyinFirstLetter:(NSUInteger)hanzi
{
    return pinyinFirstLetter(hanzi);
}

- (NSString *)formatDistance:(CGFloat)distance
{
    CGFloat distanceFloat = distance;
    NSString *distanceStr = @"";
    if (distanceFloat < 1000)
    {
        distanceStr = [NSString stringWithFormat:@"%.0fm", distanceFloat];
    }
    else
    {
        distanceFloat /= 1000;
        distanceStr = [NSString stringWithFormat:@"%.1fkm", distanceFloat];
    }
    return distanceStr;
}

- (CGFloat)heightForText:(NSString *)text
               withWidth:(CGFloat)width
              withHeight:(CGFloat)height
      withTextAttributes:(NSDictionary *)attributes
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width,
                                                        height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return ceilf(rect.size.height)+3;
}


-(UIImage*)getImageWithLogoType:(NSString*)mlogoType AndStatus:(NSString*)deviceSts
{
    NSString *imagename=@"offline_car.png";
    
    if ([mlogoType isEqualToString:@"23"]) {//摩托车的
        if([deviceSts isEqualToString:@"1"]){
            imagename=@"dy_panel_offline.png";
        }else if([deviceSts isEqualToString:@"2"])
        {
            imagename=@"dy_panel_offline.png";
        }else if([deviceSts isEqualToString:@"3"])
        {
            imagename=@"dy_panel_online.png";
            //mdevSts=2;
        }else if([deviceSts isEqualToString:@"0"])
        {
            imagename=@"dy_panel_online.png";
        }else
        {//未知，默认过期
            imagename=@"dy_panel_offline.png";
        }
    }else
    {
        if([deviceSts isEqualToString:@"1"]){
            imagename=@"offline_car.png";
        }else if([deviceSts isEqualToString:@"2"])
        {
            imagename=@"offline_car.png";
        }else if([deviceSts isEqualToString:@"3"])
        {
            imagename=@"online_car.png";
            //mdevSts=2;
        }else if([deviceSts isEqualToString:@"0"])
        {
            imagename=@"online_car.png";
        }else
        {//未知，默认过期
            imagename=@"offline_car.png";
        }
    }
    return  [UIImage imageNamed:imagename];
}

-(UIImage*)getMapImageWithStatus:(NSString*)mstatus AndCouser:(int)mcouse AndLogoType:(NSString*)mlogoType
{
    if ([mlogoType isEqualToString:@"23"]) {//摩托车
        return [self getMotoImageWithStatus:mstatus AndCouser:mcouse];
    }else
    {
        return [self getImageWithStatus:mstatus AndCouser:mcouse];
    }
}

//摩托车图标
-(UIImage*)getMotoImageWithStatus:(NSString*)mstatus AndCouser:(int)mcouse
{
    NSString *imagename=@"dy_map_offline1.png";
    if ([mstatus isEqualToString:@"1"]) {//离线
        imagename=@"dy_map_offline1.png";
    }else if([mstatus isEqualToString:@"0"])//在线 静止
    {
        imagename=@"dy_map_static1.png";
    }else if([mstatus isEqualToString:@"3"])//在线 行驶中
    {
        imagename=@"dy_map_move1.png";
    }else if([mstatus isEqualToString:@"2"])//过期
    {
        imagename=@"dy_map_offline1.png";
    }
    if(KIsiPhoneX)
    {
        //return  [UIImage imageNamed:imagename];
        UIImage *oldimgae=[UIImage imageNamed:imagename];
        //return [self scaleImages:oldimgae toScale:0.75];
        return [self.dataModel scaleImage:oldimgae width:0.75];
    }else
    {
        //低于iphonex的调整图片大小
        UIImage *oldimgae=[UIImage imageNamed:imagename];
        //return [self scaleImages:oldimgae toScale:0.75];
        return [self.dataModel scaleImage:oldimgae width:0.5];
    }
}

//转化方向  0代表静止 ，1代表离线 ，2代表过期 ，3代表行驶中；
-(UIImage*)getImageWithStatus:(NSString*)mstatus AndCouser:(int)mcouse
{
    NSLog(@"getImageWithStatus:mcouse=%d",mcouse);
    NSString *imagename=@"灰色-0.png";
    if ([mstatus isEqualToString:@"1"]) {//离线
        //imagename=@"car_green2.png";
        
        if (mcouse>=15&&mcouse<45) {//30度
            imagename=@"灰色-30.png";
        }else if (mcouse>=45&&mcouse<75)//60度
        {
            imagename=@"灰色-60.png";
        }else if (mcouse>=75&&mcouse<105)//90度 正东
        {
            imagename=@"灰色-90.png";
        }else if (mcouse>=105&&mcouse<135)//120度
        {
            imagename=@"灰色-120.png";
        }else if (mcouse>=135&&mcouse<165)//150度
        {
            imagename=@"灰色-150.png";
        }else if (mcouse>=165&&mcouse<195)//180度 正南
        {
            imagename=@"灰色-180.png";
        }else if (mcouse>=195&&mcouse<225)//210度
        {
            imagename=@"灰色-210.png";
        }else if (mcouse>=225&&mcouse<255)//240度
        {
            imagename=@"灰色-240.png";
        }else if (mcouse>=255&&mcouse<285)//270度 正西
        {
            imagename=@"灰色-270.png";
        }else if (mcouse>=285&&mcouse<315)//300度
        {
            imagename=@"灰色-300.png";
        }else if (mcouse>=315&&mcouse<345)//330度
        {
            imagename=@"灰色-330.png";
        }else if (mcouse>=345||mcouse<15)//0度 正北 或者 未知方向
        {
            imagename=@"灰色-0.png";
        }
    }else if([mstatus isEqualToString:@"0"])//在线 静止
    {
        if (mcouse>=15&&mcouse<45) {//30度
            imagename=@"蓝色-30.png";
        }else if (mcouse>=45&&mcouse<75)//60度
        {
            imagename=@"蓝色-60.png";
        }else if (mcouse>=75&&mcouse<105)//90度 正东
        {
            imagename=@"蓝色-90.png";
        }else if (mcouse>=105&&mcouse<135)//120度
        {
            imagename=@"蓝色-120.png";
        }else if (mcouse>=135&&mcouse<165)//150度
        {
            imagename=@"蓝色-150.png";
        }else if (mcouse>=165&&mcouse<195)//180度 正南
        {
            imagename=@"蓝色-180.png";
        }else if (mcouse>=195&&mcouse<225)//210度
        {
            imagename=@"蓝色-210.png";
        }else if (mcouse>=225&&mcouse<255)//240度
        {
            imagename=@"蓝色-240.png";
        }else if (mcouse>=255&&mcouse<285)//270度 正西
        {
            imagename=@"蓝色-270.png";
        }else if (mcouse>=285&&mcouse<315)//300度
        {
            imagename=@"蓝色-300.png";
        }else if (mcouse>=315&&mcouse<345)//330度
        {
            imagename=@"蓝色-330.png";
        }else if (mcouse>=345||mcouse<15)//0度 正北 或者 未知方向
        {
            imagename=@"蓝色-0.png";
        };
    }else if([mstatus isEqualToString:@"3"])//在线 行驶中
    {
        if (mcouse>=15&&mcouse<45) {//30度
            imagename=@"绿色-30.png";
        }else if (mcouse>=45&&mcouse<75)//60度
        {
            imagename=@"绿色-60.png";
        }else if (mcouse>=75&&mcouse<105)//90度 正东
        {
            imagename=@"绿色-90.png";
        }else if (mcouse>=105&&mcouse<135)//120度
        {
            imagename=@"绿色-120.png";
        }else if (mcouse>=135&&mcouse<165)//150度
        {
            imagename=@"绿色-150.png";
        }else if (mcouse>=165&&mcouse<195)//180度 正南
        {
            imagename=@"绿色-180.png";
        }else if (mcouse>=195&&mcouse<225)//210度
        {
            imagename=@"绿色-210.png";
        }else if (mcouse>=225&&mcouse<255)//240度
        {
            imagename=@"绿色-240.png";
        }else if (mcouse>=255&&mcouse<285)//270度 正西
        {
            imagename=@"绿色-270.png";
        }else if (mcouse>=285&&mcouse<315)//300度
        {
            imagename=@"绿色-300.png";
        }else if (mcouse>=315&&mcouse<345)//330度
        {
            imagename=@"绿色-330.png";
        }else if (mcouse>=345||mcouse<15)//0度 正北 或者 未知方向
        {
            imagename=@"绿色-0.png";
        };
    }else if([mstatus isEqualToString:@"2"])//过期
    {
        if (mcouse>=15&&mcouse<45) {//30度
            imagename=@"黄色-30.png";
        }else if (mcouse>=45&&mcouse<75)//60度
        {
            imagename=@"黄色-60.png";
        }else if (mcouse>=75&&mcouse<105)//90度 正东
        {
            imagename=@"黄色-90.png";
        }else if (mcouse>=105&&mcouse<135)//120度
        {
            imagename=@"黄色-120.png";
        }else if (mcouse>=135&&mcouse<165)//150度
        {
            imagename=@"黄色-150.png";
        }else if (mcouse>=165&&mcouse<195)//180度 正南
        {
            imagename=@"黄色-180.png";
        }else if (mcouse>=195&&mcouse<225)//210度
        {
            imagename=@"黄色-210.png";
        }else if (mcouse>=225&&mcouse<255)//240度
        {
            imagename=@"黄色-240.png";
        }else if (mcouse>=255&&mcouse<285)//270度 正西
        {
            imagename=@"黄色-270.png";
        }else if (mcouse>=285&&mcouse<315)//300度
        {
            imagename=@"黄色-300.png";
        }else if (mcouse>=315&&mcouse<345)//330度
        {
            imagename=@"黄色-330.png";
        }else if (mcouse>=345||mcouse<15)//0度 正北 或者 未知方向
        {
            imagename=@"黄色-0.png";
        };
    }
    if(KIsiPhoneX)
    {
        return  [UIImage imageNamed:imagename];
    }else
    {
        //低于iphonex的调整图片大小
        UIImage *oldimgae=[UIImage imageNamed:imagename];
        //return [self scaleImages:oldimgae toScale:0.75];
        return [self.dataModel scaleImage:oldimgae width:0.75];
    }
}

@end
