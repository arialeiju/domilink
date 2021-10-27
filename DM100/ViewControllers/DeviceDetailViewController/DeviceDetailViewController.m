//
//  DeviceDetailViewController.m
//  CarConnection
//
//  Created by 林张宇 on 15/4/13.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "DeviceDetailViewController.h"
#import "UpdateCarNameAndNumberViewController.h"
#import "GetDeviceDetailService.h"
@interface DeviceDetailViewController ()
{
    NSArray * _detailNameArray;
    DeviceDetailTableViewCell * cell;
    MBProgressHUD * _HUD;
    NSString *_imei;
    NSString *_name;
    NSString *_plateNumber;
}
@end

@implementation DeviceDetailViewController
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
    // Do any additional setup after loading the view from its nib.
    
    [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"details"]];
    
    _detailNameArray = [[NSArray alloc] initWithObjects:[SwichLanguage getString:@"detailitem1"],
                        [SwichLanguage getString:@"detailitem2"],
                        [SwichLanguage getString:@"detailitem3"],
                        [SwichLanguage getString:@"detailitem4"],
                        [SwichLanguage getString:@"detailitem5"],
                        [SwichLanguage getString:@"detailitem6"],
                        [SwichLanguage getString:@"detailitem7"],
                        [SwichLanguage getString:@"detailitem8"],nil];
    self.deviceDetailTableView.delegate = self;
    self.deviceDetailTableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.deviceDetailTableView registerNib:[UINib nibWithNibName:@"DeviceDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"DeviceDetailTableViewCell"];
    [self.deviceDetailTableView setTableFooterView:[[UIView alloc] init]];
    //[self getDeviceDetail];
    
    self.tv1.text=[SwichLanguage getString:@"unitno"];
    self.tv2.text=[SwichLanguage getString:@"unitname"];
    self.tv1.adjustsFontSizeToFitWidth=YES;
    self.tv2.adjustsFontSizeToFitWidth=YES;
    if(KIsiPhoneX)
    {
        CGRect newfame=_kContentView.frame;
        newfame.origin.y=newfame.origin.y+IPXMargin;
        [_kContentView setFrame:newfame];
        
        CGRect newfame1=_deviceDetailTableView.frame;
        newfame1.origin.y=newfame1.origin.y+IPXMargin;
        newfame1.size.height=newfame1.size.height-IPXMargin;
        [_deviceDetailTableView setFrame:newfame1];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.deviceNameLabel.text=_imei;
    self.carNumberLabel.text=_name;
    [self getDeviceDetail];
    //[self getDeviceLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self getDeviceLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)getDeviceDetail
{
    _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *imeiStr;
    if (_imei)
    {
        imeiStr = _imei;
    }
    [GetDeviceDetailService GetDeviceDetailWithImei:imeiStr
                                            succeed:^(GetDeviceDetailObject * getDeviceDetail){
                                                // car detail
                                                _deviceNameLabel.text = getDeviceDetail.imei;
                                                _carNumberLabel.text = getDeviceDetail.name;
                                                
                                                // table data
//                                                NSString * date = getDeviceDetail.enableDate==nil? [@"":getDeviceDetail.enableDate;
                                                
                                                NSLog(@"getDeviceDetail=%@",getDeviceDetail);
                                                
                                                _detailArray = [[NSMutableArray alloc] initWithObjects:
                                                                getDeviceDetail.enableDate==nil?@"":getDeviceDetail.enableDate,
                                                                getDeviceDetail.platformExpire==nil?@"":getDeviceDetail.platformExpire,
                                                                getDeviceDetail.userExpire==nil?@"":getDeviceDetail.userExpire,
                                                                getDeviceDetail.imei==nil?@"":getDeviceDetail.imei,
                                                                getDeviceDetail.deviceSim==nil?@"":getDeviceDetail.deviceSim,
                                                                getDeviceDetail.ICCID==nil?@"":getDeviceDetail.ICCID,
                                                                getDeviceDetail.overSpeed==nil?@"":[NSString stringWithFormat:@"%@km/s",getDeviceDetail.overSpeed],
                                                                 getDeviceDetail.model==nil?@"":getDeviceDetail.model,
                                                                nil];
                                                [self.deviceDetailTableView reloadData];
                                                [_HUD hide:YES];
                                                //[self getDeviceLocation];
                                                
                                            }
                                            failure:^(NSError * error){
                                                [_HUD hide:YES];
                                                [MBProgressHUD showQuickTipWIthTitle:@"提示" withText:@"数据获取失败"];
                                                [self.navigationController popViewControllerAnimated:YES];
                                                NSLog(@"10 error = %@",error);
                                            }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 8;
    return [_detailNameArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"DeviceDetailTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.titleLabel.text = [_detailNameArray objectAtIndex:indexPath.row];
    cell.InfoLabel.text = [_detailArray objectAtIndex:indexPath.row];
    if (indexPath.row == 6||indexPath.row == 7) {
        cell.accessoryType = YES;
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==3)
    {
        return YES;
    }else
    {
        return NO;
    }
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
    return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{

    if (action == @selector(copy:)) {
    //根据自己需求，修改需要复制cell中的文字
        DeviceDetailTableViewCell *cell = (DeviceDetailTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; // 黏贴板
        [pasteBoard setString:cell.InfoLabel.text];
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 6) {
//
////        PayViewController * payViewController = [[PayViewController alloc] initWithType:false];
////        payViewController.name=_deviceNameLabel.text;
////        payViewController.platformExpire=time;
////        [self.navigationController pushViewController:payViewController animated:YES];
//
//            WebCMDViewController * OnlineCMDControllerViewController = [[WebCMDViewController alloc] init];
//            [OnlineCMDControllerViewController SetType:2];
//            [self.navigationController pushViewController:OnlineCMDControllerViewController animated:YES];
//
//    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)update_car_name_and_carnumber:(id)sender {
    UpdateCarNameAndNumberViewController * updateCarNameAndNumberViewController = [[UpdateCarNameAndNumberViewController alloc] initWithImei:_imei andName:_name andplateNumber:_plateNumber];
    NSLog(@"%@ , %@",_deviceNameLabel.text,_carNumberLabel.text);
    updateCarNameAndNumberViewController.delegate=self;
    //[updateCarNameAndNumberViewController setCarname:_deviceNameLabel.text AndCarnumber:_carNumberLabel.text];
            [self.navigationController pushViewController:updateCarNameAndNumberViewController animated:YES];
    
}

#pragma mark -委托处理
- (void)setCarname:(NSString *)carname AndCarnumber:(NSString*)carnumber
{
    //_deviceNameLabel.text=carname;
    _carNumberLabel.text=carname;
    _name=carname;
    [MBProgressHUD showQuickTipWIthTitle:nil withText:[SwichLanguage getString:@"okS1011"]];
}
@end

