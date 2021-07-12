//
//  SwichLanguage.m
//  domilink
//
//  Created by 马真红 on 2020/2/14.
//  Copyright © 2020 aika. All rights reserved.
//

#import "SwichLanguage.h"
static NSString*LocalLanguageKey = @"SwitchLanguage";
@implementation SwichLanguage
static NSBundle *bundle = nil;



+ ( NSBundle * )bundle{
    return bundle;
}

//首次加载的时候先检测语言是否存在
+(void)initUserLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [def valueForKey:LocalLanguageKey];
    if(!currLanguage){
        NSArray *preferredLanguages = [NSLocale preferredLanguages];
        currLanguage = preferredLanguages[0];
        if ([currLanguage hasPrefix:@"en"]) {
            currLanguage = @"en";
        }else if ([currLanguage hasPrefix:@"zh"]) {
            currLanguage = @"zh-Hans";
        }else currLanguage = @"en";
        [def setValue:currLanguage forKey:LocalLanguageKey];
        [def synchronize];
    }
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:currLanguage ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

//获取当前语言
//@"zh-Hans"  中文
//@"en" 英文
+(NSString *)userLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:LocalLanguageKey];
    return language;
}

//获取当前语言代号
//-1未设置  0中文 1英文
+(int)userLanguageType{
    int mtype;
    mtype=1;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:LocalLanguageKey];
    if ([language hasPrefix:@"en"]) {
        mtype=1;
    }else if ([language hasPrefix:@"zh"]) {
        mtype=0;
    }
    return mtype;
}

//设置语言
+(void)setUserlanguage:(NSString *)language{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [userDefaults valueForKey:LocalLanguageKey];
    if ([currLanguage isEqualToString:language]) {
        return;
    }
    [userDefaults setValue:language forKey:LocalLanguageKey];
    [userDefaults synchronize];
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
}

+(NSString*)getString:(NSString*)mkey
{
    NSString *str = [bundle localizedStringForKey:mkey value:nil table:@"appString"];
    return str;
}
@end
