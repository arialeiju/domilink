//
//  SettingPlusCell.m
//  CarConnection
//
//  Created by 马真红 on 2020/10/19.
//  Copyright © 2020 gemo. All rights reserved.
//

#import "SettingPlusCell.h"

@implementation SettingPlusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.plabel.textColor=[UIColor colorWithHexString:@"#333333"];
    [self.topline setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];
    if ([SwichLanguage userLanguageType]==1) {
        self.plabel.adjustsFontSizeToFitWidth=YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
