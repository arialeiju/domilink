//
//  UIButton+FromURL.h
//  Shell
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 21cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FromURL)

- (UIImage *)setImageWithURLString:(NSString *)urlString forState:(UIControlState)state;

@end
