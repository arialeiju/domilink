//
//  ChangePasswordViewController.m
//  CarConnection
//
//  Created by 马真红 on 17/4/27.
//  Copyright © 2017年 gemo. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "LoginViewController.h"
@interface ChangePasswordViewController ()
{
     MBProgressHUD * _HUD;
    __weak IBOutlet UILabel *tv1;
    __weak IBOutlet UILabel *tv2;
    __weak IBOutlet UILabel *tv3;
    NSString* mloginNo;
    NSString* mtype;
    int showtype;
}
@end

@implementation ChangePasswordViewController
- (id)initWithImei:(NSString *)mlog WithDeviceType:(NSString *)ttype AndShowType:(int)mid
{
    self = [super init];
    if (self)
    {
        mloginNo = mlog;
        NSLog(@"mloginNo=%@",mloginNo);
        mtype=ttype;
        showtype=mid;
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(10, IOS7DELTA,
                                         80, 44)];
        [rightButton setTitle:[SwichLanguage getString:@"submit"] forState:UIControlStateNormal];
        [rightButton sizeToFit];
        [rightButton addTarget:self action:@selector(submitButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
        [rightButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        if (showtype==0) {
           [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"page4item2"] withRightButton:rightButton];
        }else
        {
            [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"page4item7"] withRightButton:rightButton];
        }
        [self updateview];
        if(KIsiPhoneX)
        {
            CGRect newfame=_kContentView.frame;
            newfame.origin.y=newfame.origin.y+IPXMargin;
            newfame.size.height=newfame.size.height-IPXMargin;
            [_kContentView setFrame:newfame];
        }
        
        _surenewpassword_label.secureTextEntry=YES;
        _oldpassword_label.secureTextEntry=YES;
        _newpassword_label.secureTextEntry=YES;
        tv1.adjustsFontSizeToFitWidth=YES;
        tv2.adjustsFontSizeToFitWidth=YES;
        tv3.adjustsFontSizeToFitWidth=YES;
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
    [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"page4item2"] withRightButton:rightButton];
    [self updateview];
    if(KIsiPhoneX)
    {
        CGRect newfame=_kContentView.frame;
        newfame.origin.y=newfame.origin.y+IPXMargin;
        newfame.size.height=newfame.size.height-IPXMargin;
        [_kContentView setFrame:newfame];
    }
    
    _surenewpassword_label.secureTextEntry=YES;
    _oldpassword_label.secureTextEntry=YES;
    _newpassword_label.secureTextEntry=YES;
    tv1.adjustsFontSizeToFitWidth=YES;
    tv2.adjustsFontSizeToFitWidth=YES;
    tv3.adjustsFontSizeToFitWidth=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateview{
    [tv1 setText:[SwichLanguage getString:@"cptv1"]];
    [tv2 setText:[SwichLanguage getString:@"cptv2"]];
    [tv3 setText:[SwichLanguage getString:@"cptv3"]];
}

- (void)submitButtonDidPush
{
    if (_oldpassword_label.text.length==0) {
        [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"cper1"] withText:nil];
        return;
    }
    if (_newpassword_label.text.length==0) {
        [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"cper2"] withText:nil];
        return;
    }
    if (_surenewpassword_label.text.length==0) {
        [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"cper3"] withText:nil];
        return;
    }
    if (![_oldpassword_label.text isEqualToString:self.inAppSetting.password]) {
        [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"cper4"] withText:nil];
        return;
    }
    if (![_surenewpassword_label.text isEqualToString:_newpassword_label.text]) {
        [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"cper5"] withText:nil];
        return;
    }
    
    [self startToChangePassword];
}
- (void)startToChangePassword
{
    
    typeof(self) __weak weakSelf = self;
    _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSDictionary *bodyData = @{@"loginNo":mloginNo,
                               @"type":mtype,
                               @"oldpassword":weakSelf.oldpassword_label.text,
                               @"newpassword":weakSelf.newpassword_label.text};
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:51
                                                        withParameters:bodyData];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *messageCenterObject)
     {
         [_HUD hide:YES];
         NSDictionary *ret = messageCenterObject.ret;
        NSLog(@"ret=%@",ret);
         if ([[ret objectForKey:@"ret" ] isEqualToString:@"1"]) {
             
             [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"okS1013"] withText:nil];
             
             //退出流程
             [self.inAppSetting loginOut];
             self.inAppSetting.password=nil;
             LoginViewController *loginVC = [[LoginViewController alloc] init];
             [self presentViewController:loginVC animated:YES completion:^{
                 [self.navigationController popViewControllerAnimated:NO];
                 //[self.tabBarController setSelectedIndex:0];
             }];
             
         }else
         {
             NSString* msgstr=(NSString *)[messageCenterObject.ret objectForKey:@"msg"];
             if (msgstr.length==0) {
                 [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA107X"] withText:nil];
             }else
             {
                 [MBProgressHUD showQuickTipWIthTitle:msgstr withText:nil];
             }
         }
     }
               failure:^(NSError *error)
     {
         [_HUD hide:YES];
         [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA107X"] withText:nil];
     }];
    
    //收起软键盘
    [self.view endEditing:YES];
}

@end
