//
//  HistoryScrollCell.h
//  DM100
//
//  Created by 马真红 on 2021/5/26.
//  Copyright © 2021 aika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SS_Model.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^TapCellClick)(NSIndexPath *indexPath);
static NSString *tapCellScrollNotification = @"tapCellScrollNotification";

@interface HistoryScrollCell : UITableViewCell<UIScrollViewDelegate>

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIScrollView *rightScrollView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isNotification;
@property (nonatomic, copy) TapCellClick tapCellClick;
-(void)initWithCellModel:(SS_Model *)model andArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
