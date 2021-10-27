//
//  FenceViewController.h
//  DM100
//
//  Created by 马真红 on 2021/10/11.
//  Copyright © 2021 aika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshableTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface FenceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
-(id)initWithImei:(NSString *)mimei andImeiName:(NSString *)mImeiName;

@property (weak, nonatomic) IBOutlet RefreshableTableView *messageCenterTableView;
@property (strong, nonatomic) NSMutableArray * messageArray;
@end

NS_ASSUME_NONNULL_END
