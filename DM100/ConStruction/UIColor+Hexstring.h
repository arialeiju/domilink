//
//  UIColor+Hexstring.h
//  VideoOnline
//
//  Created by Goman on 14-12-16.
//  Copyright (c) 2014年 Goman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hexstring)
+ (UIColor *) colorWithHexString: (NSString *)color;

+(UIImage*) createImageWithColor:(UIColor*) color;

@end
