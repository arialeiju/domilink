//
//  HistoryLocationObject.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/15.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "HistoryLocationObject.h"

@implementation HistoryLocationObject

@synthesize course, speed, stsTime, lo, la,deviceSts,locateSts,altitude,accuracyType;


-(NSString*)getaAltitude
{
    if (self.altitude<1) {
        return @"--";
    }else
    {
        return [NSString stringWithFormat:@"%0.2f",self.altitude];
    }
}

-(NSString*)getAccuracyType
{
    switch (accuracyType) {
        case 1:
            return [SwichLanguage getString:@"accuracyType1"];
            break;
        case 2:
            return [SwichLanguage getString:@"accuracyType2"];
            break;
        case 4:
            return [SwichLanguage getString:@"accuracyType4"];
            break;
        case 5:
            return [SwichLanguage getString:@"accuracyType5"];
            break;
        case 6:
            return [SwichLanguage getString:@"accuracyType6"];
            break;
        default:
            return @"--";
            break;
    }
}

-(NSString*)getDescribeBystsTime
{
    if (self.stsTime.length<5) {
        return @"";
    }else
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *data = [format dateFromString:self.stsTime];
        
        NSDateFormatter *rformat = [[NSDateFormatter alloc] init];
        rformat.dateFormat = @"HH:mm:ss";
        NSString *timeStr = [rformat stringFromDate:data];
        return timeStr;
    }
}

-(NSString*)getDescribeBylocateSts
{
    if (self.locateSts==NULL) {
        return @"";
    }
    
    if ([self.locateSts isEqualToString:@"0"]) {
        return [SwichLanguage getString:@"maptype1"];
    }else if ([self.locateSts isEqualToString:@"1"])
    {
        return [SwichLanguage getString:@"maptype2"];
    }else if ([self.locateSts isEqualToString:@"2"])
    {
        return [SwichLanguage getString:@"maptype3"];
    }else
    {
        return [SwichLanguage getString:@"maptype4"];
    }
}

-(NSString*)getDescribeBylalo
{
    if (self.lo==NULL||self.la==NULL) {
        return @"";
    }
    float mla=[self.la floatValue];
    float mlo=[self.lo floatValue];
    NSString* retstr=[NSString stringWithFormat:@"(%@,%@)",[self stringDisposeWithFloat:mlo],[self stringDisposeWithFloat:mla]];

   return retstr;
}

-(NSString *)stringDisposeWithFloat:(float)floatValue
{
    NSString *str = [NSString stringWithFormat:@"%0.5f",floatValue];
    long len = str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        //s.substring(0, len - i - 1);
        return [str substringToIndex:[str length]-1];
    }
    else
    {
        return str;
    }
}
@end
