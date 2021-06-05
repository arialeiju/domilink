//
//  AlarmSettingPlusController.m
//  CarConnection
//
//  Created by 马真红 on 2020/10/19.
//  Copyright © 2020 gemo. All rights reserved.
//

#import "AlarmSettingPlusController.h"
#import "DeviceDetailTableViewCell.h"
#import "AlarmSettingPlusCell.h"
#import "AlarmPlusInfo.h"
#import "RightImageCell.h"
#import "AKRadioPopView.h"
#import "OnlineCMDService.h"
@interface AlarmSettingPlusController ()<UITableViewDelegate,UITableViewDataSource,AKRadioPopViewDelegate>
{
    NSMutableArray * _mainlist;
    NSMutableArray * _celllist1;
    NSMutableArray * _celllist2;
    NSMutableArray * _celllist3;
    AlarmPlusInfo* _mAlarmPlusInfo;
    MBProgressHUD * _HUD;
    NSString* _imei;
    NSString *_devicetype;
    NSString *_imeiname;
}
@property (nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation AlarmSettingPlusController
-(id)initWithImei:(NSString *)mimei anddevicetype:(NSString*)mdevicetype andImeiName:(NSString *)mImeiName
{
    self = [super init];
    if (self)
    {
        _imei=mimei;
        _devicetype=mdevicetype;
        _imeiname=mImeiName;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDatalist];
    [self initUIview];
    
    [self send120CMD];
}

-(void)initUIview
{
    [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"setitem9"] withRightButton:nil];
//    if(KIsiPhoneX)
//    {
//        CGRect newfame=_mview.frame;
//        newfame.origin.y=newfame.origin.y+IPXMargin;
//        newfame.size.height=newfame.size.height-IPXMargin*2;
//        [_mview setFrame:newfame];
//    }
    
    
    CGFloat btwith=(VIEWWIDTH-60)/2;
    CGFloat btheight=50;
    CGRect leftfame=CGRectMake(20, KIsiPhoneX?VIEWHEIGHT-btheight-10-IPXMargin*2:VIEWHEIGHT-btheight-10, btwith, btheight);
    [_defaultbutton setFrame:leftfame];
    
    CGRect rightfame=CGRectMake(CGRectGetMaxX(leftfame)+20, leftfame.origin.y, btwith, btheight);
    [_allselectedbutton setFrame:rightfame];
    
    CGFloat tableY=KIsiPhoneX?64+IPXMargin:64;
    CGRect tablefame=CGRectMake(0,tableY, VIEWWIDTH, leftfame.origin.y-tableY-20);
    [_showtableview setFrame:tablefame];
    
    _allselectedbutton.layer.cornerRadius = 5;
    _allselectedbutton.layer.masksToBounds = YES;
    _defaultbutton.layer.cornerRadius = 5;
    _defaultbutton.layer.masksToBounds = YES;
    [_showtableview setTableFooterView:[[UIView alloc] init]];
}

-(void)initDatalist
{
    _mainlist = [[NSMutableArray alloc] initWithObjects: [SwichLanguage getString:@"al01"],[SwichLanguage getString:@"al02"],[SwichLanguage getString:@"al03"], nil];
    
    _celllist1 = [[NSMutableArray alloc] initWithObjects: [SwichLanguage getString:@"al11"],[SwichLanguage getString:@"al12"],[SwichLanguage getString:@"al13"], nil];
    
    _celllist2 = [[NSMutableArray alloc] initWithObjects:
                   [SwichLanguage getString:@"al201"],
                   [SwichLanguage getString:@"al202"],
                   [SwichLanguage getString:@"al203"],
                   [SwichLanguage getString:@"al204"],
                   [SwichLanguage getString:@"al205"],
                   [SwichLanguage getString:@"al206"],
                   [SwichLanguage getString:@"al207"],
                   [SwichLanguage getString:@"al208"],
                   [SwichLanguage getString:@"al209"],
                   [SwichLanguage getString:@"al210"],
                   [SwichLanguage getString:@"al211"],nil];
    
    _celllist3 = [[NSMutableArray alloc] initWithObjects:
                  [SwichLanguage getString:@"al31"],
                  [SwichLanguage getString:@"al32"],
                  [SwichLanguage getString:@"al33"],
                  [SwichLanguage getString:@"al34"],
                  [SwichLanguage getString:@"al35"],
                  [SwichLanguage getString:@"al36"],nil];
    
    _titleArray= [[NSMutableArray alloc] initWithObjects:
                  [SwichLanguage getString:@"al41"],
                  [SwichLanguage getString:@"al42"],
                  [SwichLanguage getString:@"al43"],
                  [SwichLanguage getString:@"al44"],nil];
    
    _mAlarmPlusInfo=[[AlarmPlusInfo alloc]init];
    _mAlarmPlusInfo.outFence=0;
    _mAlarmPlusInfo.overspeed=1;
    _mAlarmPlusInfo.offlineLong=2;
    _mAlarmPlusInfo.electricPercent=3;
    
    [_defaultbutton setTitle:[SwichLanguage getString:@"al51"] forState:UIControlStateNormal];
    _defaultbutton.titleLabel.adjustsFontSizeToFitWidth=YES;
    [_allselectedbutton setTitle:[SwichLanguage getString:@"al52"] forState:UIControlStateNormal];
    UIFont *mfont= _defaultbutton.titleLabel.font;
    _allselectedbutton.titleLabel.font=mfont;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 11;
    } else if (section == 2) {
        return 6;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
    }
    
    NSString* mname= [_mainlist objectAtIndex:section];
    headerView.textLabel.text=mname;
    headerView.textLabel.font=[UIFont systemFontOfSize:17.0f];
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    if (indexPath.section==0) {
        DeviceDetailTableViewCell *pluscell = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailTableViewCell"];
        if (pluscell == nil) {
            pluscell = [[[NSBundle mainBundle]loadNibNamed:@"DeviceDetailTableViewCell" owner:self options:nil] lastObject];
        }
        pluscell.titleLabel.text=[_celllist1 objectAtIndex:indexPath.row];
        if (indexPath.row==0) {
            pluscell.InfoLabel.text=_imeiname ;
        }else if(indexPath.row==1)
        {
            pluscell.InfoLabel.text=_imei;
        }else if(indexPath.row==2)
        {
            pluscell.InfoLabel.text=_devicetype;
        }
        return pluscell;
    }
    
    //震动报警等级特殊处理
    if (indexPath.section==2&&indexPath.row==0) {
        RightImageCell *mRightImageCell = [tableView dequeueReusableCellWithIdentifier:@"RightImageCell"];
        if (mRightImageCell == nil) {
            mRightImageCell = [[[NSBundle mainBundle]loadNibNamed:@"RightImageCell" owner:self options:nil] lastObject];
        }
        mRightImageCell.titlelabel.text=[_celllist3 objectAtIndex:indexPath.row];
        return mRightImageCell;
    }
    
    
    
    
    AlarmSettingPlusCell *alarmpluscell = [tableView dequeueReusableCellWithIdentifier:@"AlarmSettingPlusCell"];
    if (alarmpluscell == nil) {
        alarmpluscell = [[[NSBundle mainBundle]loadNibNamed:@"AlarmSettingPlusCell" owner:self options:nil] lastObject];
    }
    if(indexPath.section==1)
    {
        alarmpluscell.titlelabel.text=[_celllist2 objectAtIndex:indexPath.row];
        Boolean ishid=YES;
        Boolean isOn=NO;//check控件开关
        switch (indexPath.row) {
                case 0:
                    {
                        isOn=_mAlarmPlusInfo.isWeakSignal>0?YES:NO;
                    }
                break;
                case 1:
                    {
                        isOn=_mAlarmPlusInfo.isParkingGuard>0?YES:NO;
                    }
                break;
                case 2:
                    {
                        isOn=_mAlarmPlusInfo.isCollisionAlarm>0?YES:NO;
                    }
                break;
                case 3:
                    {
                        isOn=_mAlarmPlusInfo.isRolloverAlarm>0?YES:NO;
                    }
                break;
                case 4:
                    {
                        isOn=_mAlarmPlusInfo.isSignalRecover>0?YES:NO;
                    }
                break;
                case 5:
                    {
                        isOn=_mAlarmPlusInfo.isLightSensitive>0?YES:NO;
                    }
                break;
                case 6:
                    {
                        isOn=_mAlarmPlusInfo.isSosAlarm>0?YES:NO;
                    }
                break;
                case 7:
                    {
                        isOn=_mAlarmPlusInfo.isPowerFailure>0?YES:NO;
                    }
                break;
                case 8:
                    {
                        isOn=_mAlarmPlusInfo.isFlowExpiration>0?YES:NO;
                    }
                break;
                case 9:
                    {
                        isOn=_mAlarmPlusInfo.isPlatformExpires>0?YES:NO;
                    }
                break;
                case 10:
                    {
                        isOn=_mAlarmPlusInfo.isOutFence>0?YES:NO;
                        alarmpluscell.datalabel.text=[NSString stringWithFormat:@"%dm",_mAlarmPlusInfo.outFence];
                        ishid=NO;
                    }
                    break;
            default:
                break;
        }
        [alarmpluscell.alarmSwitch setOn:isOn];
        [alarmpluscell.datalabel setHidden:ishid];
    }else if(indexPath.section==2)
    {
        alarmpluscell.titlelabel.text=[_celllist3 objectAtIndex:indexPath.row];
        Boolean ishid2=YES;
        Boolean isOn=NO;//check控件开关
        switch (indexPath.row) {
            case 1:
                {
                    isOn=_mAlarmPlusInfo.autoDefense>0?YES:NO;
                }
                break;
            case 2:
                {
                    isOn=_mAlarmPlusInfo.isOverspeed>0?YES:NO;
                    alarmpluscell.datalabel.text=[NSString stringWithFormat:@"%dkm/h",_mAlarmPlusInfo.overspeed];
                        ishid2=NO;
                }
                break;
            case 3:
                {
                    isOn=_mAlarmPlusInfo.isOffline>0?YES:NO;
                    alarmpluscell.datalabel.text=[NSString stringWithFormat:@"%dh",_mAlarmPlusInfo.offlineLong];
                        ishid2=NO;
                }
                break;
            case 4:
                {
                    isOn=_mAlarmPlusInfo.lowElectric>0?YES:NO;
                    alarmpluscell.datalabel.text=[NSString stringWithFormat:@"%d%%",_mAlarmPlusInfo.electricPercent];
                        ishid2=NO;
                }
                break;
            case 5:
                {
                    isOn=_mAlarmPlusInfo.isVibrationAlarm>0?YES:NO;
                }
                break;
            default:
                break;
        }
        [alarmpluscell.alarmSwitch setOn:isOn];
        [alarmpluscell.datalabel setHidden:ishid2];
    }
    
    return alarmpluscell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

#pragma mark - TableView点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击section=%ld row=%ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.section==2&&indexPath.row==0) {
        [self showLevelSettingDailog];
    }else if(indexPath.section==2&&indexPath.row>0)
    {
        AlarmSettingPlusCell *cell = (AlarmSettingPlusCell *)[tableView cellForRowAtIndexPath:indexPath];
        Boolean isOn=!cell.alarmSwitch.on;//触发开还是关
        [cell.alarmSwitch setOn:isOn animated:YES];
        AlarmPlusInfo* minfo=[[AlarmPlusInfo alloc]init];
        minfo.deviceImei=_imei;
        Boolean hadsendCMD=false;//避免重复发送协议
        switch (indexPath.row) {
                case 1:
                    minfo.autoDefense=isOn?1:0;
                    break;
                case 2:
                {
                    minfo.isOverspeed=isOn?1:0;
                    if (isOn) {
                        hadsendCMD=true;
                        [self ShowOverspeedDailog:minfo];
                    }
                }
                    break;
                case 3:
                {
                    minfo.isOffline=isOn?1:0;
                    if (isOn) {
                        hadsendCMD=true;
                        [self ShowofflineLongDailog:minfo];
                    }
                }
                    break;
                case 4:
                {
                    minfo.lowElectric=isOn?1:0;
                    if (isOn) {
                        hadsendCMD=true;
                        [self ShowlowElectricDailog:minfo];
                    }
                }
                    break;
                case 5:
                    minfo.isVibrationAlarm=isOn?1:0;
                    break;
            default:
                break;
        }
        if (!hadsendCMD) {
            [self send121CMD:minfo];
        }
    }else if(indexPath.section==1)
    {
        AlarmSettingPlusCell *cell = (AlarmSettingPlusCell *)[tableView cellForRowAtIndexPath:indexPath];
        Boolean isOn=!cell.alarmSwitch.on;//触发开还是关
        [cell.alarmSwitch setOn:isOn animated:YES];
        AlarmPlusInfo* minfo=[[AlarmPlusInfo alloc]init];
        minfo.deviceImei=_imei;
        Boolean hadsendCMD=false;//避免重复发送协议
        switch (indexPath.row) {
                case 0:
                    minfo.isWeakSignal=isOn?1:0;
                    break;
                case 1:
                    minfo.isParkingGuard=isOn?1:0;
                    break;
                case 2:
                    minfo.isCollisionAlarm=isOn?1:0;
                    break;
                case 3:
                    minfo.isRolloverAlarm=isOn?1:0;
                    break;
                case 4:
                    minfo.isSignalRecover=isOn?1:0;
                    break;
                case 5:
                    minfo.isLightSensitive=isOn?1:0;
                    break;
                case 6:
                    minfo.isSosAlarm=isOn?1:0;
                    break;
                case 7:
                    minfo.isPowerFailure=isOn?1:0;
                    break;
                case 8:
                    minfo.isFlowExpiration=isOn?1:0;
                    break;
                case 9:
                    minfo.isPlatformExpires=isOn?1:0;
                    break;
                case 10:
                {
                    minfo.isOutFence=isOn?1:0;
                    if (isOn) {
                        hadsendCMD=true;
                        [self ShowoutFenceDailog:minfo];
                    }
                }
                   break;
                default:
                    break;
        }
        if (!hadsendCMD) {
            [self send121CMD:minfo];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)ShowDefaultSetDailog
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"tips"]
                                                                    message:[SwichLanguage getString:@"aldailogD1"]
                                                             preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* okAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"sure"] style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
         AlarmPlusInfo* minfo=[[AlarmPlusInfo alloc]init];
         minfo.deviceImei=_imei;
         [minfo autoDefault];
         [self send121CMD:minfo];
                                                           }];
     UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                          }];
     [alert addAction:okAction];
     [alert addAction:cancelAction];
     [self presentViewController:alert animated:YES completion:nil];
}

-(void)ShowAllOnDailog
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"tips"]
                                                                    message:[SwichLanguage getString:@"aldailogE1"]
                                                             preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* okAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"sure"] style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               //响应事件
         AlarmPlusInfo* minfo=[[AlarmPlusInfo alloc]init];
         minfo.deviceImei=_imei;
         [minfo AllOn];
         [self send121CMD:minfo];
                                                           }];
     UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                          }];
     [alert addAction:okAction];
     [alert addAction:cancelAction];
     [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)clickdefalutbutton:(id)sender {
    [self ShowDefaultSetDailog];
}

- (IBAction)clickAllbutton:(id)sender {
    [self ShowAllOnDailog];
}


//打开设置定位类型弹出框
- (void)showLevelSettingDailog{
    //初始化
    AKRadioPopView *_mAKRadioPopView = [[AKRadioPopView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)];
    //遵守协议
    _mAKRadioPopView.QCPopViewDelegate = self;
    //传递数据
    [_mAKRadioPopView showThePopViewWithArray:self.titleArray AndTitle:[SwichLanguage getString:@"setitem5"]];
}
#pragma mark - QCPopViewDelegate
-(void)getTheButtonTitleWithIndexPath:(int)indexPath{
    //设置震动报警等级
    NSString* mcmd;
    switch (indexPath) {
            case 0:
                mcmd=@"BF,30,7,300";
                break;
            case 1:
                mcmd=@"BF,30,12,300";
                break;
            case 2:
                mcmd=@"BF,30,20,300";
                break;
            case 3:
                mcmd=@"CF";
                break;
            default:
                break;
    }
    [self SendTheCMDToDeviceby:mcmd];
}

//协议121设置
-(void)send121CMD:(AlarmPlusInfo*)mInfo
{
    //typeof(self) __weak weakSelf = self;
    NSLog(@"ssend121CMD");
     _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
     NSDictionary *bodyData =[mInfo getNSDictionary];
     NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:121
                                                         withParameters:bodyData];
     [NetWorkModel POST:ServerURL
             parameters:parameters
                success:^(ResponseObject *messageCenterObject)
      {
          [_HUD hide:YES];
          NSDictionary *ret = messageCenterObject.ret;
          NSLog(@"send121CMD ret=%@",ret);
          int mretcode=[[ret objectForKey:@"result" ] intValue];
          if (mretcode==1) {
             // appDelegate.mYCKCSetModel = [[YCKCSetModel alloc] initWithJSON:messageCenterObject.ret];
              [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"setok"] withText:nil];
              //刷新数据
              [self send120CMD];
          }else
          {
              NSString* msgstr=(NSString *)[messageCenterObject.ret objectForKey:@"retMsg"];
              if (msgstr.length==0) {
                  [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"setfail"] withText:nil];
              }else
              {
                  [MBProgressHUD showLogTipWIthTitle:msgstr withText:nil];
              }
          }
      }
                failure:^(NSError *error)
      {
          [_HUD hide:YES];
          [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"tips"] withText:[SwichLanguage getString:@"setfail"]];
      }];
}

//判断是否是数字
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];

    if(string.length > 0)
    {

         return NO;

    }
    return YES;

}

-(void)ShowoutFenceDailog:(AlarmPlusInfo*)mInfo
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"tips"]
                                                                    message:[SwichLanguage getString:@"fancedailogM1"]
                                                             preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* okAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"sure"] style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
         UITextField * tf1 = alert.textFields[0];
         if (tf1.text.length<1) {
             [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"fancedailogM1"]];
             [self cancenlAction:0];
         }else
         {
             NSString *smscmd=[ [NSString alloc] initWithFormat:@"%@",tf1.text ];
             if ([self isPureNumandCharacters:smscmd]) {
                 //全数字
                 float mset= [smscmd floatValue];
                 if (mset>=200) {
                     mInfo.outFence=mset;
                     [self send121CMD:mInfo];
                 }else
                 {
                     [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"errorA112X"]];
                     [self cancenlAction:0];
                 }
             }else
             {
                 [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"errorA112X"]];
                 [self cancenlAction:0];
             }
         }
                                                           }];
     UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
         [self cancenlAction:0];
                                                          }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text=[NSString stringWithFormat:@"%d",_mAlarmPlusInfo.outFence];
    }];
     [alert addAction:okAction];
     [alert addAction:cancelAction];
     [self presentViewController:alert animated:YES completion:nil];
}

-(void)ShowOverspeedDailog:(AlarmPlusInfo*)mInfo
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"tips"]
                                                                    message:[SwichLanguage getString:@"aldailogA1"]
                                                             preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* okAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"sure"] style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
         UITextField * tf1 = alert.textFields[0];
         if (tf1.text.length<1) {
             [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"aldailogA2"]];
             [self cancenlAction:1];
         }else
         {
             NSString *smscmd=[ [NSString alloc] initWithFormat:@"%@",tf1.text ];
             if ([self isPureNumandCharacters:smscmd]) {
                 //全数字
                 float mset= [smscmd floatValue];
                 if (mset>0) {
                     NSLog(@"开发上传设置");
                     mInfo.overspeed=mset;
                     [self send121CMD:mInfo];
                 }else
                 {
                     [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"aldailogA3"]];
                     [self cancenlAction:1];
                 }
             }else
             {
                 [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"aldailogA3"]];
                 [self cancenlAction:1];
             }
         }
                                                           }];
     UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
         [self cancenlAction:1];
                                                          }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text=[NSString stringWithFormat:@"%d",_mAlarmPlusInfo.overspeed];
    }];
     [alert addAction:okAction];
     [alert addAction:cancelAction];
     [self presentViewController:alert animated:YES completion:nil];
}

-(void)ShowofflineLongDailog:(AlarmPlusInfo*)mInfo
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"tips"]
                                                                    message:[SwichLanguage getString:@"aldailogB1"]
                                                             preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* okAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"sure"] style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
         UITextField * tf1 = alert.textFields[0];
         if (tf1.text.length<1) {
             [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"aldailogB1"]];
             [self cancenlAction:2];
         }else
         {
             NSString *smscmd=[ [NSString alloc] initWithFormat:@"%@",tf1.text ];
             if ([self isPureNumandCharacters:smscmd]) {
                 //全数字
                 float mset= [smscmd floatValue];
                 if (mset>=3) {
                     mInfo.offlineLong=mset;
                     [self send121CMD:mInfo];
                 }else
                 {
                     [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"aldailogB1"]];
                     [self cancenlAction:2];
                 }
             }else
             {
                 [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"aldailogB1"]];
                 [self cancenlAction:2];
             }
         }
                                                           }];
     UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
         [self cancenlAction:2];
                                                          }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text=[NSString stringWithFormat:@"%d",_mAlarmPlusInfo.offlineLong];
    }];
     [alert addAction:okAction];
     [alert addAction:cancelAction];
     [self presentViewController:alert animated:YES completion:nil];
}

-(void)ShowlowElectricDailog:(AlarmPlusInfo*)mInfo
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"tips"]
                                                                    message:[SwichLanguage getString:@"aldailogC1"]
                                                             preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* okAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"sure"] style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
         UITextField * tf1 = alert.textFields[0];
         if (tf1.text.length<1) {
             [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"aldailogC1"]];
             [self cancenlAction:3];
         }else
         {
             NSString *smscmd=[ [NSString alloc] initWithFormat:@"%@",tf1.text ];
             if ([self isPureNumandCharacters:smscmd]) {
                 //全数字
                 float mset= [smscmd floatValue];
                 if (mset>=10) {
                     mInfo.electricPercent=mset;
                     [self send121CMD:mInfo];
                 }else
                 {
                     [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"aldailogC1"]];
                     [self cancenlAction:3];
                 }
             }else
             {
                 [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"aldailogC1"]];
                 [self cancenlAction:3];
             }
         }
                                                           }];
     UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
         [self cancenlAction:3];
                                                          }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text=[NSString stringWithFormat:@"%d",_mAlarmPlusInfo.electricPercent];
    }];
     [alert addAction:okAction];
     [alert addAction:cancelAction];
     [self presentViewController:alert animated:YES completion:nil];
}

//各种设置然后出错或者取消，需要把 sw 关闭
-(void)cancenlAction:(int)mid
{
    NSIndexPath *indexPath;
    switch (mid) {
        case 0:
            indexPath=[NSIndexPath indexPathForRow:10 inSection:1];
            break;
        case 1:
            indexPath=[NSIndexPath indexPathForRow:2 inSection:2];
            break;
        case 2:
            indexPath=[NSIndexPath indexPathForRow:3 inSection:2];
            break;
        case 3:
            indexPath=[NSIndexPath indexPathForRow:4 inSection:2];
            break;
        default:
            break;
    }
    AlarmSettingPlusCell *cell = (AlarmSettingPlusCell *)[self.showtableview cellForRowAtIndexPath:indexPath];
    [cell.alarmSwitch setOn:NO];
    [self.showtableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

//协议120获取状态
-(void)send120CMD
{
    //typeof(self) __weak weakSelf = self;
    NSLog(@"ssend120CMD");
     NSDictionary *bodyData = @{@"imei":_imei,
                                   };
     NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:120
                                                         withParameters:bodyData];
     [NetWorkModel POST:ServerURL
             parameters:parameters
                success:^(ResponseObject *messageCenterObject)
      {
          [_HUD hide:YES];
          NSDictionary *rets = messageCenterObject.ret;
          NSDictionary *ret=[rets objectForKey:@"deviceWarnPush"];
          //NSLog(@"ret=%@",rets);
          int mretcode=[[rets objectForKey:@"result"] intValue];
          if (mretcode==1) {
              _mAlarmPlusInfo.isWeakSignal=[[ret objectForKey:@"isWeakSignal"] intValue];
              _mAlarmPlusInfo.isParkingGuard=[[ret objectForKey:@"isParkingGuard"] intValue];
              _mAlarmPlusInfo.isCollisionAlarm=[[ret objectForKey:@"isCollisionAlarm"] intValue];
              _mAlarmPlusInfo.isRolloverAlarm=[[ret objectForKey:@"isRolloverAlarm"] intValue];
              _mAlarmPlusInfo.isSignalRecover=[[ret objectForKey:@"isSignalRecover"] intValue];
              _mAlarmPlusInfo.isLightSensitive=[[ret objectForKey:@"isLightSensitive"] intValue];
              _mAlarmPlusInfo.isSosAlarm=[[ret objectForKey:@"isSosAlarm"] intValue];
              _mAlarmPlusInfo.isPowerFailure=[[ret objectForKey:@"isPowerFailure"] intValue];
              _mAlarmPlusInfo.isFlowExpiration=[[ret objectForKey:@"isFlowExpiration"] intValue];
              _mAlarmPlusInfo.isPlatformExpires=[[ret objectForKey:@"isPlatformExpires"] intValue];
              _mAlarmPlusInfo.isOutFence=[[ret objectForKey:@"isOutFence"] intValue];
              _mAlarmPlusInfo.autoDefense=[[ret objectForKey:@"autoDefense"] intValue];
              _mAlarmPlusInfo.isOverspeed=[[ret objectForKey:@"isOverspeed"] intValue];
              _mAlarmPlusInfo.isOffline=[[ret objectForKey:@"isOffline"] intValue];
              _mAlarmPlusInfo.lowElectric=[[ret objectForKey:@"lowElectric"] intValue];
              _mAlarmPlusInfo.isVibrationAlarm=[[ret objectForKey:@"isVibrationAlarm"] intValue];
              _mAlarmPlusInfo.outFence=[[ret objectForKey:@"outFence"] intValue];
              _mAlarmPlusInfo.overspeed=[[ret objectForKey:@"overspeed"] intValue];
              _mAlarmPlusInfo.offlineLong=[[ret objectForKey:@"offlineLong"] intValue];
              _mAlarmPlusInfo.electricPercent=[[ret objectForKey:@"electricPercent"] intValue];
              [self.showtableview reloadData];
          }else
          {
              [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"tips"] withText:[SwichLanguage getString:@"errorA100X"]];
          }
      }
                failure:^(NSError *error)
      {
          [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"tips"] withText:[SwichLanguage getString:@"errorA100X"]];
      }];
}


//自定义指令
-(void) SendTheCMDToDeviceby:(NSString*)cmd
{
    NSLog(@"SendTheCMDToDeviceby mcmd=%@",cmd);
    _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [OnlineCMDService
     setCMDwithImei:_imei withSmscmd:cmd  withUserid:self.inAppSetting.userId succeed:^(OnlineCMDObject *onlineCMDObject) {
        [_HUD hide:YES];
         //[MBProgressHUD showQuickTipWithText:onlineCMDObject.smscmd];
         int resultCode= [onlineCMDObject.result intValue];
         NSLog(@"onlineCMDObject.result=%@",onlineCMDObject.result);
         NSLog(@"onlineCMDObject.content=%@",onlineCMDObject.content);

         switch (resultCode) {
             case 0:
                 [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror0"] Title:nil];
                 break;
             case 1:
                 if (onlineCMDObject.content.length>0) {
                     if([onlineCMDObject.smscmd isEqualToString:@"VERSION"])
                     {
                         NSString * newstr=[onlineCMDObject.content stringByReplacingOccurrencesOfString:@";" withString:@"\r\n"];
                         [self ShowTheResultDailog:newstr Title:[SwichLanguage getString:@"detailitem8"]];
                     }else if([onlineCMDObject.smscmd isEqualToString:@"PARAM"])
                     {
                         if([onlineCMDObject.content  rangeOfString:@"success:"].location !=NSNotFound)//_roaldSearchText
                         {
                             onlineCMDObject.content=[onlineCMDObject.content substringFromIndex:8];
                         }
                         //onlineCMDObject.content=[onlineCMDObject.content stringByReplacingOccurrencesOfString:@"success" withString:@""];
                         NSArray *array= [onlineCMDObject.content componentsSeparatedByString:@";"];
                         //NSLog(@"onlineCMDObject.content=%@",onlineCMDObject.content);
                         if (array.count>0) {
                             NSString* content=@"";
                             for (NSString *dic in array)
                             {
                                 //NSLog(@"dic=%@",dic);
                                 content=[content stringByAppendingString:[NSString stringWithFormat:@"%@\r\n",dic]];
                                 //NSLog(@"content=%@",content);
                             }
                             [self ShowTheResultDailog:content Title:[SwichLanguage getString:@"online2"]];
                         }else
                         {
                            [self ShowTheResultDailog:onlineCMDObject.content Title:[SwichLanguage getString:@"online2"]];
                         }
                     }else if([onlineCMDObject.smscmd isEqualToString:@"STATUS"])
                     {
                         if([onlineCMDObject.content  rangeOfString:@"success:"].location !=NSNotFound)//_roaldSearchText
                         {
                             onlineCMDObject.content=[onlineCMDObject.content substringFromIndex:8];
                         }
                         NSArray *array= [onlineCMDObject.content componentsSeparatedByString:@";"];
                         //NSLog(@"onlineCMDObject.content=%@",onlineCMDObject.content);
                         if (array.count>0) {
                             NSString* content=@"";
                             for (NSString *dic in array)
                             {
                                 //NSLog(@"dic=%@",dic);
                                 content=[content stringByAppendingString:[NSString stringWithFormat:@"%@\r\n",dic]];
                                 //NSLog(@"content=%@",content);
                             }
                             [self ShowTheResultDailog:content Title:[SwichLanguage getString:@"online3"]];
                         }else
                         {
                             [self ShowTheResultDailog:onlineCMDObject.content Title:[SwichLanguage getString:@"online3"]];
                         }
                     }else if([onlineCMDObject.smscmd isEqualToString:@"123"])
                     {
                         [self ShowTheResultDailog:onlineCMDObject.content Title:[SwichLanguage getString:@"online4"]];
                     }else if([onlineCMDObject.smscmd rangeOfString:@"CENTER"].location!=NSNotFound)
                     {
                         [self ShowTheResultDailog:onlineCMDObject.content Title:nil];
                     }else
                     {
                         [self ShowTheResultDailog:onlineCMDObject.content Title:nil];
                     }
                 }else
                 {
                     [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror1"] Title:nil];
                 }
                 break;
             case 2:
                   [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror2"] Title:nil];
                 break;
             case 3:
                  [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror3"] Title:nil];
                 break;
             case 4:
                 [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror4"] Title:nil];
                 break;
             case 5:
                 [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror5"] Title:nil];
                 break;
             case 6:
                 [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror6"] Title:nil];
                 break;
             default:
                 [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror7"] Title:nil];
                 break;
         }
         
     }
     failure:^(NSError *error) {
         [_HUD hide:YES];
         [MBProgressHUD showQuickTipWithText:[SwichLanguage getString:@"networkerror"]];
     }];
}
#pragma mark - show the result dailog
-(void)ShowTheResultDailog:(NSString*)content Title:(NSString*)title
{
    //设置帐号
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:content
                                                        delegate:self
                                               cancelButtonTitle:[SwichLanguage getString:@"sure"]
                                               otherButtonTitles:nil, nil
                               ];
    alertView.alertViewStyle=UIAlertViewStyleDefault;
    alertView.tag=10;
    [alertView show];
}
@end
