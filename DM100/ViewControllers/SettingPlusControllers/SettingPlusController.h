//
//  SettingPlusController.h
//  CarConnection
//
//  Created by 马真红 on 2020/10/19.
//  Copyright © 2020 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGJFoldHeaderView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SettingPlusController : UIViewController<UITableViewDelegate,UITableViewDataSource,FoldSectionHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
-(id)initWithImei:(NSString *)mimei anddevicetype:(NSString*)mdevicetype andImeiName:(NSString *)mImeiName;
@end

NS_ASSUME_NONNULL_END
