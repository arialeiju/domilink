//
//  UIButton+FromURL.m
//  Shell
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 21cn. All rights reserved.
//

#import "UIButton+FromURL.h"
#import "UIButton+WebCache.h"


@implementation UIButton (FromURL)

- (UIImage *)setImageWithURLString:(NSString *)urlString forState:(UIControlState)state
{
    NSArray *parts = [urlString componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    
    NSString *imageFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
    
    UIImage *localImage = [UIImage imageWithContentsOfFile:imageFilePath];
    
    if (!localImage) {
//        urlString =  [NewsListJSDataPaser convertScaleWith:@"/s320x267/" in:urlString];
        [self setImageWithURL:[NSURL URLWithString:urlString] forState:state];
        
    } else {
        [self setImage:localImage forState:state];
    }
    

    return localImage;
}

@end
