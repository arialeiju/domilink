//
//  SelectableButton.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/5/22.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "SelectableButton.h"

@implementation SelectableButton

- (id)initWithTitle:(NSString *)title
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SelectableButton"
                                          owner:self
                                        options:nil] firstObject];
    if (self)
    {
        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

@end
