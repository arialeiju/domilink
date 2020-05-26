//
//  CheckCMDTableViewCell.h
//  CarConnection
//
//  Created by 马真红 on 17/5/8.
//  Copyright © 2017年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckCMDTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *contentButton;

@property (weak, nonatomic) IBOutlet UILabel *order_name;
@property (weak, nonatomic) IBOutlet UILabel *order_sts;
@property (weak, nonatomic) IBOutlet UILabel *send_time;
@property (weak, nonatomic) IBOutlet UILabel *sts_time;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UILabel *tv1;
@property (weak, nonatomic) IBOutlet UILabel *tv2;
@property (weak, nonatomic) IBOutlet UILabel *tv3;
@property (weak, nonatomic) IBOutlet UILabel *tv4;
@property (weak, nonatomic) IBOutlet UILabel *tv5;
@end
