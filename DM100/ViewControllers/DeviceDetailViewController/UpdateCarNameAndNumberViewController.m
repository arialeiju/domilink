//
//  UpdateCarNameAndNumberViewController.m
//  CarConnection
//
//  Created by 马真红 on 16/11/17.
//  Copyright © 2016年 gemo. All rights reserved.
//

#import "UpdateCarNameAndNumberViewController.h"

@interface UpdateCarNameAndNumberViewController ()
{
     MBProgressHUD * _HUD;
    NSString* speedstr;
    
    NSString *_imei;
    NSString *_name;
    NSString *_plateNumber;
    __weak IBOutlet UILabel *tv1;
    __weak IBOutlet UILabel *tv2;
    __weak IBOutlet UILabel *tv3;
    __weak IBOutlet UILabel *tv4;
    __weak IBOutlet UILabel *tv5;
    __weak IBOutlet UILabel *tv6;
}

@end

@implementation UpdateCarNameAndNumberViewController

@synthesize delegate;
- (id)initWithImei:(NSString *)mimei andName:(NSString*)mname andplateNumber:(NSString*)mplateNumber
{
    self = [super init];
    if (self)
    {
        _imei=mimei;
        _name=mname;
        _plateNumber=mplateNumber;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(10, IOS7DELTA,
                                     80, 44)];
    [rightButton setTitle:[SwichLanguage getString:@"submit"] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(submitButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"Deviceinfo"] withRightButton:rightButton];
    
    self.Carname_UIText.text=_name;
    self.Carnumber_UIText.text=_plateNumber;
    speedstr=@"0";
    [self.outspeed_UIText setHidden:YES];
    
    [self.outspeed_ob addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    if(KIsiPhoneX)
    {
        CGRect newfame=_kContentView.frame;
        newfame.origin.y=newfame.origin.y+IPXMargin;
        newfame.size.height=newfame.size.height-IPXMargin;
        [_kContentView setFrame:newfame];
    }
    [self updateView];
    [self get114cmddata];
}
-(void)updateView{
    tv1.adjustsFontSizeToFitWidth=YES;
    tv2.adjustsFontSizeToFitWidth=YES;
    tv3.adjustsFontSizeToFitWidth=YES;
    tv4.adjustsFontSizeToFitWidth=YES;
    tv5.adjustsFontSizeToFitWidth=YES;
    tv6.adjustsFontSizeToFitWidth=YES;
    tv1.text=[SwichLanguage getString:@"unitname"];
    tv2.text=[SwichLanguage getString:@"carNumber"];
    tv3.text=[SwichLanguage getString:@"contactNumber"];
    tv4.text=[SwichLanguage getString:@"contacts"];
    tv5.text=[SwichLanguage getString:@"speedalarm"];
    tv6.text=[SwichLanguage getString:@"offlinealarm"];
}
-(void)get114cmddata
{
    typeof(self) __weak weakSelf = self;
    NSDictionary *bodyData = @{@"imei":_imei};
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:114
                                                        withParameters:bodyData];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *messageCenterObject)
     {
         NSDictionary *ret = messageCenterObject.ret;
         
         
         if ([[ret objectForKey:@"ret" ] isEqualToString:@"1"]) {
             weakSelf.contactsphone_UIText.text=[ret objectForKey:@"contactsphone"]==nil?@"":[ret objectForKey:@"contactsphone"];
             weakSelf.contacts_UIText.text=[ret objectForKey:@"contacts"]==nil?@"":[ret objectForKey:@"contacts"];
             speedstr=[ret objectForKey:@"outspeed"]==nil?@"0":[ret objectForKey:@"outspeed"];
             weakSelf.outspeed_UIText.text=[NSString stringWithFormat:@"%@km/h",[ret objectForKey:@"outspeed"]];
             
             if ([[ret objectForKey:@"outspeedalarm" ] isEqualToString:@"1"]) {
                 weakSelf.outspeed_ob.on=YES;
                 [weakSelf.outspeed_UIText setHidden:NO];
             }else
             {
                 weakSelf.outspeed_ob.on=NO;
                 [weakSelf.outspeed_UIText setHidden:YES];
             }
             
             if ([[ret objectForKey:@"outlinealarm" ] isEqualToString:@"1"]) {
                 weakSelf.outlinealarm_ob.on=YES;
             }else
             {
                 weakSelf.outlinealarm_ob.on=NO;
             }
             
         }else
         {
             [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA102X"] withText:nil];
         }
     }
               failure:^(NSError *error)
     {
        [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA102X"] withText:nil];
     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)submitButtonDidPush
{
    
    typeof(self) __weak weakSelf = self;
    _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    NSDictionary *bodyData = @{@"imei":_imei,
                               //@"type":@"2",
                               @"name":weakSelf.Carname_UIText.text,
                               @"plateNumber":weakSelf.Carnumber_UIText.text,
                               @"contactsphone":weakSelf.contactsphone_UIText.text,
                               @"contacts":weakSelf.contacts_UIText.text,
                               @"outspeed":speedstr,
                               @"outlinealarm":weakSelf.outlinealarm_ob.on==true?@"1":@"0",
                               @"outspeedalarm":weakSelf.outspeed_ob.on==true?@"1":@"0"};
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:113 
                                                        withParameters:bodyData];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *messageCenterObject)
     {
          [_HUD hide:YES];
         NSDictionary *ret = messageCenterObject.ret;
         if ([[ret objectForKey:@"ret" ] isEqualToString:@"1"]) {
             
             [delegate setCarname:weakSelf.Carname_UIText.text AndCarnumber:weakSelf.Carnumber_UIText.text];
             
             [self.navigationController popViewControllerAnimated:YES];
         }else
         {
             [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA101X"] withText:nil];
         }
     }
               failure:^(NSError *error)
     {
          [_HUD hide:YES];
         [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA101X"] withText:nil];
     }];
    
    //收起软键盘
    [self.view endEditing:YES];
}


-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [self.outspeed_UIText setHidden:NO];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[SwichLanguage getString:@"dailog1T"]
                                                             message:[SwichLanguage getString:@"dailog1M"]
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:[SwichLanguage getString:@"cancel"],[SwichLanguage getString:@"sure"], nil
                                   ];
        alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
        alertView.tag=0;
        UITextField *tf = [alertView textFieldAtIndex:0];
        // 设置textfield 的键盘类型。
        tf.keyboardType = UIKeyboardTypeDecimalPad;
        NSLog(@"speedstr=%@",speedstr);
        tf.text=[NSString stringWithFormat:@"%@",speedstr];
        [alertView show];
    }else
    {
        [self.outspeed_UIText setHidden:YES];
    }
}

#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag==0) {
        
        UITextField *tf = [alertView textFieldAtIndex:0];
        speedstr=tf.text;
        self.outspeed_UIText.text=[NSString stringWithFormat:@"%@km/h",speedstr];
    }
}
@end
