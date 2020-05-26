//
//  CarListTableCell.m
//  domilink
//
//  Created by 马真红 on 2020/2/16.
//  Copyright © 2020 aika. All rights reserved.
//

#import "CarListTableCell.h"

@implementation CarListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    float theheight=self.bt1.frame.size.height/8;
    [self.bt1.layer setMasksToBounds:YES];
    [self.bt1.layer setCornerRadius:theheight];
    [self.bt2.layer setMasksToBounds:YES];
    [self.bt2.layer setCornerRadius:theheight];
    [self.bt3.layer setMasksToBounds:YES];
    [self.bt3.layer setCornerRadius:theheight];
    self.tvname.adjustsFontSizeToFitWidth=YES;
    [self.bt1 setTitle:[SwichLanguage getString:@"details"] forState:UIControlStateNormal];
    [self.bt2 setTitle:[SwichLanguage getString:@"setting"] forState:UIControlStateNormal];
    [self.bt3 setTitle:[SwichLanguage getString:@"playback"] forState:UIControlStateNormal];
    [self.bt3 setBackgroundColor:[UIColor colorWithHexString:@"434D70"]];
    [self.bt2 setBackgroundColor:[UIColor colorWithHexString:@"434D70"]];
    [self.bt1 setBackgroundColor:[UIColor colorWithHexString:@"434D70"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
