//
//  NSDictionary+ContainsKey.m
//  Flinja
//
//  Created by Jack Wang on 12/17/13.
//  Copyright (c) 2013 Omniquest. All rights reserved.
//

#import "NSDictionary+ContainsKey.h"

@implementation NSDictionary (ContainsKey)

- (BOOL)containsKey: (NSString *)key {
    BOOL retVal = 0;
    NSArray *allKeys = [self allKeys];
    retVal = [allKeys containsObject:key];
    return retVal;
}

@end