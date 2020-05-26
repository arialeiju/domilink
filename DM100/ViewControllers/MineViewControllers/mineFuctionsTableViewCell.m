//
//  mineFuctionsTableViewCell.m
//  CarConnection
//
//  Created by 林张宇 on 15/5/22.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "mineFuctionsTableViewCell.h"

@implementation mineFuctionsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    _titleImageView.frame = CGRectMake(
                                       15,
                                       (self.bounds.size.height - 26)*0.5,
                                       26,
                                       26);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
