//
//  CheckCMDTableViewCell.m
//  CarConnection
//
//  Created by 马真红 on 17/5/8.
//  Copyright © 2017年 gemo. All rights reserved.
//

#import "CheckCMDTableViewCell.h"

@implementation CheckCMDTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[SwichLanguage getString:@"cmdtv6"] ];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [_contentButton setAttributedTitle:title
                          forState:UIControlStateNormal];
    [_contentButton setEnabled:NO];
    self.tv1.adjustsFontSizeToFitWidth=YES;
    self.tv2.adjustsFontSizeToFitWidth=YES;
    self.tv3.adjustsFontSizeToFitWidth=YES;
    self.tv4.adjustsFontSizeToFitWidth=YES;
    self.tv5.adjustsFontSizeToFitWidth=YES;
    self.tv1.text=[SwichLanguage getString:@"cmdtv1"];
    self.tv2.text=[SwichLanguage getString:@"cmdtv2"];
    self.tv3.text=[SwichLanguage getString:@"cmdtv3"];
    self.tv4.text=[SwichLanguage getString:@"cmdtv4"];
    self.tv5.text=[SwichLanguage getString:@"cmdtv5"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
