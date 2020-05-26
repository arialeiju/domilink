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
@end
