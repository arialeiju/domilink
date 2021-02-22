//
//  AlarmSettingPlusController.h
//  CarConnection
//
//  Created by 马真红 on 2020/10/19.
//  Copyright © 2020 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmSettingPlusController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *showtableview;
@property (weak, nonatomic) IBOutlet UIButton *defaultbutton;
@property (weak, nonatomic) IBOutlet UIButton *allselectedbutton;
- (IBAction)clickAllbutton:(id)sender;
- (IBAction)clickdefalutbutton:(id)sender;
-(id)initWithImei:(NSString *)mimei anddevicetype:(NSString*)mdevicetype andImeiName:(NSString *)mImeiName;
@end

NS_ASSUME_NONNULL_END
