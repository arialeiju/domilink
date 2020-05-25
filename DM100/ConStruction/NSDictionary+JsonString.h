//
//  NSDictionary+JsonString.h
//  VideoOnline
//
//  Created by Goman on 14-12-25.
//  Copyright (c) 2014年 Goman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonString)
-(NSString *) toJsonString;

-(NSString *) toJsonStringWithNoonPrint;
@end
