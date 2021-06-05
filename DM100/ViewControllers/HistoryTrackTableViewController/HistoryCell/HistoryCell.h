//
//  HistoryCell.h
//  CarConnection
//
//  Created by 马真红 on 2019/5/13.
//  Copyright © 2019 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryScrollCell.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^TapCellClick)(NSIndexPath *indexPath);
//static NSString *tapCellScrollNotification = @"tapCellScrollNotification";

@interface HistoryCell : UITableViewCell<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isNotification;
@property (nonatomic, copy) TapCellClick tapCellClick;

@end

NS_ASSUME_NONNULL_END
