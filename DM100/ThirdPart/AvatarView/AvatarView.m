//
//  AvatarView.m
//  头版
//
//  Created by YunInfo on 14-3-25.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import "AvatarView.h"

@implementation AvatarView

- (id)initWithFrame:(CGRect)frame withUrl:(NSString*)iconUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (iconUrl) {
            [self setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:nil];
        }

        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib {
	self.layer.cornerRadius = self.frame.size.width/2;
	self.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
