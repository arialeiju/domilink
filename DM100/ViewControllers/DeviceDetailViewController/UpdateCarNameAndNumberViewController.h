//
//  UpdateCarNameAndNumberViewController.h
//  CarConnection
//
//  Created by 马真红 on 16/11/17.
//  Copyright © 2016年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceDetailViewController.h"
@interface UpdateCarNameAndNumberViewController : UIViewController<UIAlertViewDelegate>
{
     NSObject<UIViewPassValueDelegate> * delegate;
}
@property (weak, nonatomic) IBOutlet UITextField *Carname_UIText;
@property (weak, nonatomic) IBOutlet UITextField *Carnumber_UIText;
@property(nonatomic, retain) NSObject<UIViewPassValueDelegate> * delegate;

@property (weak, nonatomic) IBOutlet UITextField *contacts_UIText;

@property (weak, nonatomic) IBOutlet UITextField *contactsphone_UIText;
@property (weak, nonatomic) IBOutlet UILabel *outspeed_UIText;
@property (weak, nonatomic) IBOutlet UISwitch *outspeed_ob;
@property (weak, nonatomic) IBOutlet UISwitch *outlinealarm_ob;
@property (weak, nonatomic) IBOutlet UIView *kContentView;
- (id)initWithImei:(NSString *)mimei andName:(NSString*)mname andplateNumber:(NSString*)mplateNumber;
@end
