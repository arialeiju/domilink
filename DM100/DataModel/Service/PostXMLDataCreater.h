//
//  PostXMLDataCreater.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/8.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostXMLDataCreater : NSObject

+ (NSDictionary *)createXMLDicWithCMD:(NSInteger)cmd
                       withParameters:(NSDictionary *)paramers;

+(NSString *) md5:(NSString *) input;

+(NSString *) md5ForBLE:(NSString *) input ;
@end
