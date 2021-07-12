//
//  SwichLanguage.h
//  domilink
//
//  Created by 马真红 on 2020/2/14.
//  Copyright © 2020 aika. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwichLanguage : NSObject
+(NSBundle *)bundle;//获取当前资源文件
+(void)initUserLanguage;//初始化语言文件 一定需要先运行
+(NSString *)userLanguage;//获取应用当前语言
+(void)setUserlanguage:(NSString *)language;//设置当前语言
+(NSString*)getString:(NSString*)mkey;//获取当前语言设置的字符串
+(int)userLanguageType;
@end

NS_ASSUME_NONNULL_END
