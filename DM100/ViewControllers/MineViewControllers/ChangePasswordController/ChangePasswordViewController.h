//
//  ChangePasswordViewController.h
//  CarConnection
//
//  Created by 马真红 on 17/4/27.
//  Copyright © 2017年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldpassword_label;
@property (weak, nonatomic) IBOutlet UITextField *newpassword_label;
@property (weak, nonatomic) IBOutlet UITextField *surenewpassword_label;
@property (weak, nonatomic) IBOutlet UIView *kContentView;
- (id)initWithImei:(NSString *)mlog WithDeviceType:(NSString *)ttype AndShowType:(int)mid;
@end
