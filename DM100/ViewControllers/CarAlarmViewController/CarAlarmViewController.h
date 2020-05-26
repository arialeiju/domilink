//
//  CarAlarmViewController.h
//  CarConnection
//
//  Created by 林张宇 on 15/4/22.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshableTableView.h"

@interface CarAlarmViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet RefreshableTableView *carAlarmTableView;
@property (strong, nonatomic) NSMutableArray * carAlarmInformationArray;
@property (strong, nonatomic) NSMutableDictionary * carAlarmInformationDictionary;


- (id)initWithImei:(NSString *)mimei anddevicetype:(NSString*)mdevicetype;
@end
