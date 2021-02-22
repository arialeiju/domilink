//
//  SettingViewController.m
//  domilink
//
//  Created by 马真红 on 2020/2/16.
//  Copyright © 2020 aika. All rights reserved.
//

#import "SettingViewController.h"
#import "WebCMDViewController.h"
#import "CheckCMDViewController.h"
#import "ElectronicFenceService.h"
@interface SettingViewController ()
{
    NSString *_imei;
    NSString *_devicetype;
}
@end

@implementation SettingViewController
-(id)initWithImei:(NSString *)mimei anddevicetype:(NSString*)mdevicetype
{
    self = [super init];
    if (self)
    {
        _imei=mimei;
        _devicetype=mdevicetype;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"setting"]];
    if(KIsiPhoneX)
    {
        CGRect newfame=_kContentView.frame;
        newfame.origin.y=newfame.origin.y+IPXMargin;
        newfame.size.height=newfame.size.height-IPXMargin;
        [_kContentView setFrame:newfame];
    }
    [self.bt1 setTitle:[SwichLanguage getString:@"setitem2"] forState:UIControlStateNormal];
    [self.bt2 setTitle:[SwichLanguage getString:@"setitem3"] forState:UIControlStateNormal];
    [self.bt3 setTitle:[SwichLanguage getString:@"setitem4"] forState:UIControlStateNormal];
    [self.bt4 setTitle:[SwichLanguage getString:@"setitem7"] forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickbt1:(id)sender {
    [self showFanceDailog];
}

- (IBAction)clickbt2:(id)sender {
    WebCMDViewController * OnlineCMDControllerViewController = [[WebCMDViewController alloc] init];
    [OnlineCMDControllerViewController SetType:1 andImei:_imei];
    [self.navigationController pushViewController:OnlineCMDControllerViewController animated:YES];
}

- (IBAction)clickbt3:(id)sender {
    WebCMDViewController * OfflineCMDViewController = [[WebCMDViewController alloc] init];
    [OfflineCMDViewController SetType:4 andImei:_imei];
    [self.navigationController pushViewController:OfflineCMDViewController animated:YES];
}

- (IBAction)clickbt4:(id)sender {
    CheckCMDViewController* mCheckCMDViewController = [[CheckCMDViewController alloc]initWithImei:_imei];
    [self.navigationController pushViewController:mCheckCMDViewController animated:YES];
}

-(void)showFanceDailog
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"fancedailogM1"] message:nil preferredStyle:
    UIAlertControllerStyleAlert];
        // 添加输入框 (注意:在UIAlertControllerStyleActionSheet样式下是不能添加下面这行代码的)
        [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = @"200";
            textField.keyboardType = UIKeyboardTypeNumberPad; 
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"sure"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    // 通过数组拿到textTF的值
            //NSLog(@"ok, %@", [[alertVc textFields] objectAtIndex:0].text);
            UITextField *tf = [[alertVc textFields] objectAtIndex:0];
            if (tf.text.length<1) {
                [MBProgressHUD showLogTipWIthTitle:@"" withText:[SwichLanguage getString:@"errorA111X"]];
            }else
            {
                
                int intString = [tf.text intValue];
               // NSLog(@"banjin=%d",intString);
                if (intString<200) {
                    [MBProgressHUD showLogTipWIthTitle:@"" withText:[SwichLanguage getString:@"errorA112X"]];
                }else
                {
                    
                    UnitModel *detail = [self.inAppSetting getSelectUnit];
            //若围栏范围不变，则return
            [ElectronicFenceService
             electronicFenceServiceWithImei:[detail getImei]
             radius:tf.text
             succeed:^(ElectronicFenceObject * electronicFenceObject)
             {
                 if ([electronicFenceObject.succeedOrNot isEqualToString:@"1"])
                 {
                     [MBProgressHUD showLogTipWIthTitle:@"" withText:[SwichLanguage getString:@"okS1014"]];
                 }
                 else
                 {
                     [MBProgressHUD showLogTipWIthTitle:@"" withText:[SwichLanguage getString:@"errorA113X"]];
                 }
                 
             }
             failure:^(NSError * error){
                 
                 
             }];
                }
            }
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel handler:nil];
    // 添加行为
        [alertVc addAction:action2];
        [alertVc addAction:action1];
        [self presentViewController:alertVc animated:YES completion:nil];

}

@end
