//
//  DeviceDetailViewController.h
//  CarConnection
//
//  Created by 林张宇 on 15/4/13.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceDetailTableViewCell.h"

@protocol UIViewPassValueDelegate

- (void)setCarname:(NSString *)carname AndCarnumber:(NSString*)carnumber;

@end

@interface DeviceDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
}


@property (weak, nonatomic) IBOutlet UITableView *deviceDetailTableView;

@property (strong,nonatomic) NSMutableArray * detailArray;

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
- (IBAction)update_car_name_and_carnumber:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *kContentView;
@property (weak, nonatomic) IBOutlet UILabel *tv1;
@property (weak, nonatomic) IBOutlet UILabel *tv2;

- (id)initWithImei:(NSString *)mimei andName:(NSString*)mname andplateNumber:(NSString*)mplateNumber;
@end
