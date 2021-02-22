//
//  AlarmSettingPlusCell.h
//  CarConnection
//
//  Created by 马真红 on 2020/10/23.
//  Copyright © 2020 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmSettingPlusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *datalabel;
@property (weak, nonatomic) IBOutlet UISwitch *alarmSwitch;

@end

NS_ASSUME_NONNULL_END
