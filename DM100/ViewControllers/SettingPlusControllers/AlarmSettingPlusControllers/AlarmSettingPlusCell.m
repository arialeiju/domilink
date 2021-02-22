//
//  AlarmSettingPlusCell.m
//  CarConnection
//
//  Created by 马真红 on 2020/10/23.
//  Copyright © 2020 gemo. All rights reserved.
//

#import "AlarmSettingPlusCell.h"

@implementation AlarmSettingPlusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.alarmSwitch.transform=CGAffineTransformMakeScale(1,0.8);
    //self.alarmSwitch.layer.anchorPoint=CGPointMake(0,0.75);
    
    //禁止点击事件
    [self.alarmSwitch setEnabled:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
