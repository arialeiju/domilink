//
//  CheckCMDViewController.h
//  CarConnection
//
//  Created by 马真红 on 17/5/8.
//  Copyright © 2017年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshableTableView.h"
@interface CheckCMDViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet RefreshableTableView *messageCenterTableView;
@property (strong, nonatomic) NSString * messagePage;
@property (strong, nonatomic) NSMutableArray * messageArray;
- (id)initWithImei:(NSString *)mimei;

@end
