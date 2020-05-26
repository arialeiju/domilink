//
//  ServerInformationViewController.m
//  CarConnection
//
//  Created by 林张宇 on 15/4/21.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "ServerInformationViewController.h"
#import "ProviderMessageService.h"
#import "ServerInformationViewController.h"
@interface ServerInformationViewController ()
{
    NSMutableArray * _serverInformationNameArray;
    MBProgressHUD * _HUD;
    __weak IBOutlet UILabel *label1;
    __weak IBOutlet UILabel *label2;
    __weak IBOutlet UILabel *label3;
    __weak IBOutlet UILabel *label4;
}
@end

@implementation ServerInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getProviderInfo];
    
    [self updateView];
}
-(void)updateView
{
    [label1 setText:[SwichLanguage getString:@"sevicename"]];
    [label2 setText:[SwichLanguage getString:@"seviceaddress"]];
    [label3 setText:[SwichLanguage getString:@"contactNumber"]];
    [label4 setText:[SwichLanguage getString:@"contacts"]];
    
    
    label1.adjustsFontSizeToFitWidth=YES;
    label2.adjustsFontSizeToFitWidth=YES;
    label3.adjustsFontSizeToFitWidth=YES;
    label4.adjustsFontSizeToFitWidth=YES;
    _nameLabel.adjustsFontSizeToFitWidth=YES;
    _linkManLabel.adjustsFontSizeToFitWidth=YES;
    _telLabel.adjustsFontSizeToFitWidth=YES;
    _addressLabel.adjustsFontSizeToFitWidth=YES;
}
- (void)getProviderInfo
{
    _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [ProviderMessageService provideMessageWithUserId:self.inAppSetting.userId
                                             succeed:^(ProviderMessageObject *providerMessageObject) {
                                                 _serverInformationArray = [[NSMutableArray alloc] initWithObjects:
                                                                    providerMessageObject.name==NULL?@"":providerMessageObject.name,
                                                                    providerMessageObject.linkman==NULL?@"":providerMessageObject.linkman,
                                                                    providerMessageObject.tel==NULL?@"":providerMessageObject.tel,
                                                                    providerMessageObject.address==NULL?@"":providerMessageObject.address,
                                                                    nil];
                                                 [self setInformationArray:_serverInformationArray];
                                                 [_HUD hide:YES];
                                                 
                                             }
                                              faiure:^(NSError *error) {
                                                  NSLog(@"9 error = %@",error);
                                                  [MBProgressHUD showQuickTipWIthTitle:@"" withText:[SwichLanguage getString:@"errorA100X"]];
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  [_HUD hide:YES];
                                              }];
}

- (void)setInformationArray:(NSMutableArray *)array
{
    _nameLabel.text = [_serverInformationArray objectAtIndex:0];
    _linkManLabel.text = [_serverInformationArray objectAtIndex:1];
    _telLabel.text = [_serverInformationArray objectAtIndex:2];
    _addressLabel.text = [_serverInformationArray objectAtIndex:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
