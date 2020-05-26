//
//  ExpeirViewController.h
//  domilink
///Users/arialeiju/Desktop/domiink工程/domilink/domilink/ViewControllers/ExpeirViewControllers/ExpeirViewController.h
//  Created by 马真红 on 2020/2/12.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshableTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ExpeirViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet RefreshableTableView *carAlarmTableView;
@property (strong, nonatomic) NSMutableArray * carAlarmInformationArray;
@property (strong, nonatomic) NSMutableDictionary * carAlarmInformationDictionary;

@end

NS_ASSUME_NONNULL_END
