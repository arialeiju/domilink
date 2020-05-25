//
//  PostXMLDataCreater.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/8.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "PostXMLDataCreater.h"
#import<CommonCrypto/CommonDigest.h>
#import "AESCrypt.h"
@implementation PostXMLDataCreater

#define XMLDataFormatWithTwoParameters @"<sunstar><header><cmd>%@</cmd><jtime>%@</jtime><MD5>%@</MD5><phone>I</phone><version>V1.0</version></header><body>%@</body></sunstar>"
#define isMD5 true//是否用加密
#define seckey  @"!@#_user_$%^^&)(_password__~=?><,./"
+ (NSDictionary *)createXMLDicWithCMD:(NSInteger)cmd


                       withParameters:(NSDictionary *)paramers
{
    NSString *bodyXMLData = @"";
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];//获取时间戳
    
    for (NSString *keyName in [paramers allKeys])
    {
        NSString* paramerstr=[paramers objectForKey:keyName];
        
        if ([keyName isEqualToString:@"password"]||[keyName isEqualToString:@"oldpassword"]||[keyName isEqualToString:@"newpassword"]) {
            paramerstr= [AESCrypt encryptAES:paramerstr key:timeString];
        }
        
        NSString *paramXMLData = [NSString stringWithFormat:@"<%@>%@</%@>",
                                  keyName,
                                  paramerstr,//[paramers objectForKey:keyName],
                                  keyName];
        bodyXMLData = [bodyXMLData stringByAppendingString:paramXMLData];
    }
    

    
    NSString *cmdString = [NSString stringWithFormat:@"%ld", (long)cmd];
    
    
    NSString *md5String= [PostXMLDataCreater md5:bodyXMLData];
    
    NSString *xmlData = [NSString stringWithFormat:XMLDataFormatWithTwoParameters, cmdString,timeString,md5String, bodyXMLData];
    
    return @{@"context" : xmlData};
}


+(NSString *) md5:(NSString *) input {
    if (!isMD5) {
        return input;
    }
    NSString* minput=[input stringByAppendingString:seckey];
    const char *cStr = [minput UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+(NSString *) md5ForBLE:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
@end
