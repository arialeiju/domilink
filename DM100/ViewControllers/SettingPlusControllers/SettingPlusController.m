//
//  SettingPlusController.m
//  CarConnection
//
//  Created by 马真红 on 2020/10/19.
//  Copyright © 2020 gemo. All rights reserved.
//

#import "SettingPlusController.h"
#import "SettingPlusCell.h"
#import "AlarmSettingPlusController.h"
#import "CheckCMDViewController.h"
#import "MediaPlayViewController.h"
#import "OnlineCMDService.h"
#import "ZhouQiDailog.h"
#import "AKRadioPopView.h"
#import "DingShiDailog.h"
#import "ChangePasswordViewController.h"
@interface SettingPlusController ()<AKRadioPopViewDelegate,ZhouQiDailogDelegate,DingShiDailogDelegate>
{
    NSMutableArray * _namearr;
    NSMutableArray * _iconarr;
    NSMutableArray * _iscanFold;
    
    NSMutableArray * _onlinelist;
    NSMutableArray * _onlineIconlist;
    NSMutableArray * _offlinelist;
    NSMutableArray * _offlineIconlist;
    
    NSString * _cmdremeber;
    MBProgressHUD * _HUD;
    
    NSString *_imei;
    NSString *_devicetype;
    NSString *_imeiname;
    NSString *_Model;
    int basetype;//有线和无线
    int productType;
    int ProgressGetData;//获取设备配置参数进度 0未获取 1获取中 2获取成功
}
@property(nonatomic, strong) NSDictionary* foldInfoDic;/**< 存储开关字典 */
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) AKRadioPopView *mAKRadioPopView;
@end

@implementation SettingPlusController
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
    _cmdremeber=@"";
    ProgressGetData=0;
    // Do any additional setup after loading the view from its nib.
    [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"setting"]];
    if(KIsiPhoneX)
    {
        CGRect newfame=_settingTableView.frame;
        newfame.origin.y=newfame.origin.y+IPXMargin;
        newfame.size.height=newfame.size.height-IPXMargin;
        [_settingTableView setFrame:newfame];
    }
    [_settingTableView setTableFooterView:[[UIView alloc] init]];
    [self creatArr];
    [self SendCMD64ToGetData];
}

- (void)creatArr {
    
    //设置0默认不展开。设置1默认展开
    _foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                   @"0":@"0",
                                                                   @"1":@"0",
                                                                   @"2":@"0",
                                                                   @"3":@"0",
                                                                   @"4":@"0"
                                                                   }];

    
    //一级列表名
    _namearr =[[NSMutableArray alloc]init];
    //[_namearr addObject:[SwichLanguage getString:@"setitem9"]];
    //[_namearr addObject:[SwichLanguage getString:@"page4item7"]];
    
    [_namearr addObject:[SwichLanguage getString:@"setitem4"]];
    [_namearr addObject:[SwichLanguage getString:@"setitem3"]];
    [_namearr addObject:[SwichLanguage getString:@"setitem9"]];
    [_namearr addObject:[SwichLanguage getString:@"setitem7"]];
    [_namearr addObject:[SwichLanguage getString:@"page4item7"]];
    

    //一级列表图标名 匹配
    _iconarr = [[NSMutableArray alloc] initWithObjects:
                @"set3",
                @"set48",
                @"set1",
                @"set7",
                @"set2",
                                    nil];
    
    //在线列表名（工程指令）
    _onlinelist = [[NSMutableArray alloc] initWithObjects:
                                    [SwichLanguage getString:@"online1"],//软件版本
                                    [SwichLanguage getString:@"online2"],//参数查询
                                    [SwichLanguage getString:@"online3"],//状态查询
                                    [SwichLanguage getString:@"online4"],//位置查询
                                    [SwichLanguage getString:@"setitem8"],//自定义指令
                                    //[SwichLanguage getString:@"online5"],//油电控制（防盗锁车）
                                    //[SwichLanguage getString:@"online6"],//重启设备
                                    nil];
    
    //在线列表图标名（工程指令）
    _onlineIconlist = [[NSMutableArray alloc] initWithObjects:
                                    @"set31",//软件版本
                                    @"set32",//参数查询
                                    @"set33",//状态查询
                                    @"set34",//位置查询
                                    @"set6",//自定义指令
                                    //@"set35",//油电控制（防盗锁车）
                                    //@"set36",//重启设备
                                    nil];
    

    //离线列表名(用户指令)
    _offlinelist =[[NSMutableArray alloc]init];
    //离线列表图标名//离线列表图标名
    _offlineIconlist =[[NSMutableArray alloc]init];

    
    //设置定位类型单选项目
    _titleArray= [[NSMutableArray alloc] initWithObjects:
                  [SwichLanguage getString:@"loctype1"],
                  [SwichLanguage getString:@"loctype2"],
                  [SwichLanguage getString:@"loctype3"],
                  [SwichLanguage getString:@"loctype4"],nil];
}

-(void)initUserCMDView
{
    //位置类型
    [_offlinelist addObject:[SwichLanguage getString:@"offline1"]];
    [_offlineIconlist addObject:[SwichLanguage getString:@"set41"]];
    

    //运动上报模式
    [_offlinelist addObject:[SwichLanguage getString:@"offline2"]];
    [_offlineIconlist addObject:[SwichLanguage getString:@"set43"]];
    //实时在线模式
    [_offlinelist addObject:[SwichLanguage getString:@"offline4"]];
    [_offlineIconlist addObject:[SwichLanguage getString:@"set44"]];

    if(basetype==1)
    {
        //周期上报模式
        [_offlinelist addObject:[SwichLanguage getString:@"offline3"]];
        [_offlineIconlist addObject:[SwichLanguage getString:@"set43"]];
        //闹铃上报模式
        [_offlinelist addObject:[SwichLanguage getString:@"offline5"]];
        [_offlineIconlist addObject:[SwichLanguage getString:@"set42"]];
    }
    
    
    if(productType==1)//蓝牙设备
    {
        //查询蓝牙名称
        [_offlinelist addObject:[SwichLanguage getString:@"online8"]];
        [_offlineIconlist addObject:[SwichLanguage getString:@"set45"]];
        if(basetype==0)
        {
        //修改蓝牙名称
        [_offlinelist addObject:[SwichLanguage getString:@"online9"]];
        [_offlineIconlist addObject:[SwichLanguage getString:@"set46"]];
        }else
        {
        //蓝牙连接失败次数上报
        [_offlinelist addObject:[SwichLanguage getString:@"online10"]];
        [_offlineIconlist addObject:[SwichLanguage getString:@"set47"]];
        }
    }
    
    //重启设备
    [_offlinelist addObject:[SwichLanguage getString:@"online6"]];
    [_offlineIconlist addObject:[SwichLanguage getString:@"set36"]];
    
    if([self IsNeedAntiReCording])
    {
        //语音监听
        [_offlinelist addObject:[SwichLanguage getString:@"setitem6"]];
        [_offlineIconlist addObject:[SwichLanguage getString:@"set5"]];
    }
    
    if([self IsNeedAntiLock])
    {
        //防盗锁车
        [_offlinelist addObject:[SwichLanguage getString:@"online5"]];
        [_offlineIconlist addObject:[SwichLanguage getString:@"set49"]];
        
        //远程解锁
        [_offlinelist addObject:[SwichLanguage getString:@"online7"]];
        [_offlineIconlist addObject:[SwichLanguage getString:@"set410"]];
    }
    [_settingTableView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];
    BOOL folded = [[_foldInfoDic objectForKey:key] boolValue];
    
    NSString* clickname=[_namearr objectAtIndex:section];
    if ([clickname isEqualToString:[SwichLanguage getString:@"setitem4"]]) {
        return folded?_offlineIconlist.count:0;
    }else if ([clickname isEqualToString:[SwichLanguage getString:@"setitem3"]]) {
        return folded?_onlinelist.count:0;
    } else {
        return 0;
    }
    
//    if (section == 3) {
//        return folded?_offlineIconlist.count:0;
//    } else if (section == 2) {
//        return folded?_onlinelist.count:0;
//    } else {
//        return 0;
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _namearr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LGJFoldHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[LGJFoldHeaderView alloc] initWithReuseIdentifier:@"header"];
    }
    
    NSString* mname= [_namearr objectAtIndex:section];
    NSString* micon= [_iconarr objectAtIndex:section];
    BOOL mcanFold=NO;
    
    NSString* clickname=[_namearr objectAtIndex:section];
    if ([clickname isEqualToString:[SwichLanguage getString:@"setitem4"]]) {
        mcanFold=YES;
    }else if ([clickname isEqualToString:[SwichLanguage getString:@"setitem3"]]) {
        mcanFold=YES;
    }
    
//    if (section==2 ){
//        mcanFold=YES;
//    }else if(section==3)
//    {
//        mcanFold=YES;
//    }
    [headerView setFoldSectionHeaderViewWithTitle:mname imaganame:micon type: HerderStyleNone section:section canFold:mcanFold];
    
    headerView.delegate = self;
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];
    BOOL folded = [[_foldInfoDic valueForKey:key] boolValue];
    headerView.fold = folded;
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingPlusCell *pluscell = [tableView dequeueReusableCellWithIdentifier:@"SettingPlusCell"];
    if (pluscell == nil) {
        pluscell = [[[NSBundle mainBundle]loadNibNamed:@"SettingPlusCell" owner:self options:nil] lastObject];
    }
    
    //给顶部补足分割线
    if (indexPath.row==0) {
        [pluscell.topline setHidden:NO];
    }else
    {
        [pluscell.topline setHidden:YES];
    }
    
    NSString* clickname=[_namearr objectAtIndex:indexPath.section];
    if ([clickname isEqualToString:[SwichLanguage getString:@"setitem3"]]) {
        pluscell.plabel.text = [_onlinelist objectAtIndex:indexPath.row];
        NSString* mimagename= [_onlineIconlist objectAtIndex:indexPath.row];
        pluscell.pimageview.image= [UIImage imageNamed:mimagename];
    }else if ([clickname isEqualToString:[SwichLanguage getString:@"setitem4"]]) {
        pluscell.plabel.text = [_offlinelist objectAtIndex:indexPath.row];
        NSString* mimagename= [_offlineIconlist objectAtIndex:indexPath.row];
        pluscell.pimageview.image= [UIImage imageNamed:mimagename];
    }
    
//    if (indexPath.section==2) {
//
//        pluscell.plabel.text = [_onlinelist objectAtIndex:indexPath.row];
//        NSString* mimagename= [_onlineIconlist objectAtIndex:indexPath.row];
//        pluscell.pimageview.image= [UIImage imageNamed:mimagename];
//    }else if(indexPath.section==3)
//    {
//        pluscell.plabel.text = [_offlinelist objectAtIndex:indexPath.row];
//        NSString* mimagename= [_offlineIconlist objectAtIndex:indexPath.row];
//        pluscell.pimageview.image= [UIImage imageNamed:mimagename];
//    }
    
    return pluscell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (void)foldHeaderInSection:(NSInteger)SectionHeader {
    NSString* clickname=[_namearr objectAtIndex:SectionHeader];
//    if ([clickname isEqualToString:[SwichLanguage getString:@"setitem4"]]&&[_devicetype rangeOfString:@"LX_"].location==NSNotFound) {
//        [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"tips"] withText:[SwichLanguage getString:@"cmderror8"]];
//        return;
//    }
    if ([clickname isEqualToString:[SwichLanguage getString:@"setitem4"]]) {
        if (ProgressGetData!=2) {
            [self SendCMD64ToGetData];
            return;
        }
    }
    NSString *key = [NSString stringWithFormat:@"%d",(int)SectionHeader];
    BOOL folded = [[_foldInfoDic objectForKey:key] boolValue];
    NSString *fold = folded ? @"0" : @"1";
    [_foldInfoDic setValue:fold forKey:key];
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:SectionHeader];
    [_settingTableView reloadSections:set withRowAnimation:UITableViewRowAnimationRight];
    
}

-(void)clicktheHeaderInSection:(NSInteger)SectionHeader
{
    NSLog(@"点击section=%ld",(long)SectionHeader);
    
    //                                    [SwichLanguage getString:@"setitem9"],
    //                                    [SwichLanguage getString:@"page4item7"],
    //                                    [SwichLanguage getString:@"setitem3"],
    //                                    [SwichLanguage getString:@"setitem4"],
    //                                    [SwichLanguage getString:@"setitem6"],
    //                                    [SwichLanguage getString:@"setitem8"],
    //                                    [SwichLanguage getString:@"setitem7"],
    NSString* clickname=[_namearr objectAtIndex:SectionHeader];
    
    //报警设置
    if ([clickname isEqualToString:[SwichLanguage getString:@"setitem9"]]) {
        AlarmSettingPlusController *mAlarmSettingPlusController = [[AlarmSettingPlusController alloc]initWithImei:_imei anddevicetype:_devicetype andImeiName:_imeiname];
        [self.navigationController pushViewController:mAlarmSettingPlusController animated:YES];
        return;
    }
    
    //修改密码
    if ([clickname isEqualToString:[SwichLanguage getString:@"page4item7"]]) {
        ChangePasswordViewController * changePasswordViewController = [[ChangePasswordViewController alloc] initWithImei:_imei WithDeviceType:@"1" AndShowType:1];
        [self.navigationController pushViewController:changePasswordViewController animated:YES];
        return;
    }
    
//    //语音对讲
//    if ([clickname isEqualToString:[SwichLanguage getString:@"setitem6"]]) {
//        [self openMediaPlayView];
//        return;
//    }
//
//    //自定义指令
//    if ([clickname isEqualToString:[SwichLanguage getString:@"setitem8"]]) {
//        [self clickCMD];
//        return;
//    }
    
    
    ////指令历史记录
    if ([clickname isEqualToString:[SwichLanguage getString:@"setitem7"]]) {
        [self openCheckCMDView];
        return;
    }
    
}

#pragma mark - TableView点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击section=%ld row=%ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.section==1) {
        switch (indexPath.row) {
             case 0:
               [self SendTheCMDToDeviceby:@"VERSION"];
                break;
            case 1:
                [self SendTheCMDToDeviceby:@"PARAM"];
                break;
            case 2:
                [self SendTheCMDToDeviceby:@"STATUS"];
                break;
            case 3:
                [self SendTheCMDToDeviceby:@"123"];
                break;
            case 4:
                [self clickCMD];
                break;
            default:
                break;
        }
    }else if(indexPath.section==0)
    {
        NSString* clickname=[_offlinelist objectAtIndex:indexPath.row];
        
        //报警设置
        if ([clickname isEqualToString:[SwichLanguage getString:@"offline1"]]) {
            [self showLoctionTypeSettingDailog];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"offline2"]]) {
            [self clickDingShiDailog:0];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"offline5"]]) {
            [self clickDingShiDailog:1];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"offline3"]]) {
            [self clickZhouQiDailog];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"offline4"]]) {
            [self showUpateTimeDailog];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"online6"]]) {
            [self SendTheCMDToDeviceby:@"RESET"];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"setitem6"]]) {
            [self openMediaPlayView];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"online5"]]) {
            //[self showOilOnOrOffDailog];
            [self checkPassWordCMD:1];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"online7"]]) {
            //[self showOilOnOrOffDailog];
            [self checkPassWordCMD:0];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"online8"]]) {
            [self SendTheCMDToDeviceby:@"blename"];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"online9"]]) {
            [self showModifyBLENameDailog];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"online10"]]) {
            [self showBLEConnectionFailTimeDailog];
        }
//        switch (indexPath.row) {
//            case 3:
//                [self showUpateTimeDailog];
//                break;
//            case 2:
//                [self clickZhouQiDailog];
//                break;
//            case 0:
//                [self showLoctionTypeSettingDailog];
//                break;
//            case 1:
//                [self clickDingShiDailog];
//                break;
//
//            default:
//                break;
//        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)openCheckCMDView
{
    CheckCMDViewController* mCheckCMDViewController = [[CheckCMDViewController alloc]initWithImei:_imei];
    [self.navigationController pushViewController:mCheckCMDViewController animated:YES];
}
-(void)openMediaPlayView
{
    MediaPlayViewController * mediaPlayViewController = [[MediaPlayViewController alloc] initWithImei:_imei anddevicetype:_devicetype andImeiName:_imeiname];
    [self.navigationController pushViewController:mediaPlayViewController animated:YES];
    //[MBProgressHUD showLogTipWIthTitle:@"提示" withText:@"该设备不支持语音监听功能"];
}

//自定义指令
-(void)clickCMD{
    //提示框添加文本输入框
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"setitem8"]
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"send"] style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              //得到文本信息
                                                            UITextField * tf1 = alert.textFields[0];
                                                            if (tf1.text.length<1) {
                                                                [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"cmdtip"]];
                                                            }else
                                                            {
                                                                NSString *smscmd=[ [NSString alloc] initWithFormat:@"%@",tf1.text ];
                                                                //NSLog(@"%@",smscmd);
                                                                self->_cmdremeber=smscmd;
                                                                NSLog(@"_cmdremeberself->2=%@",self->_cmdremeber);
                                                                [self SendTheCMDToDeviceby:smscmd];
                                                            }
                                                            
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             //NSLog(@"action = %@", alert.textFields);
                                                         }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder =[SwichLanguage getString:@"cmdtip"];
        textField.text=self->_cmdremeber;
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

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
#pragma mark -ZhouQiDailogDelegate
- (void)SureButtonAction:(NSString*)mcmd
{
    //NSLog(@"SureButtonAction=%@",mcmd);
    [self SendTheCMDToDeviceby:mcmd];
}

#pragma mark -DingShiDailogDelegate
- (void)SureButtonDingShiAction:(NSString*)mcmd
{
    //NSLog(@"SureButtonDingShiAction=%@",mcmd);
    [self SendTheCMDToDeviceby:mcmd];
}

//油电控制
-(void)showOilOnOrOffDailog
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"online5"] message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"oilon"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //响应回调
        [self checkPassWordCMD:0];
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"oiloff"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //响应回调
        [self checkPassWordCMD:1];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//密码验证
-(void)checkPassWordCMD:(int)mtype
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"checkpw"]
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* okAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"check"] style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               //响应事件
                                                               //得到文本信息
                                                             UITextField * tf1 = alert.textFields[0];
                                                             if (tf1.text.length<1) {
                                                                 [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"hit2"]];
                                                             }else
                                                             {
                                                                 NSString *smscmd=[ [NSString alloc] initWithFormat:@"%@",tf1.text ];
                                                                 NSLog(@"smscmd2 = %@",smscmd);
                                                                 [self checkPasswordValueByImei:self->_imei andPassWord:smscmd andType:mtype];
                                                                 
                                                                 //验证协议操作
                                                             }
                                                             
                                                           }];
     UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              //NSLog(@"action = %@", alert.textFields);
                                                          }];
     [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
         textField.keyboardType = UIKeyboardTypeNumberPad;
         textField.placeholder = [SwichLanguage getString:@"hit2"];
     }];
     
     [alert addAction:okAction];
     [alert addAction:cancelAction];
     [self presentViewController:alert animated:YES completion:nil];
}

//密码验证
-(void)showUpateTimeDailog
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"dingshit1"]
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* okAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"setting"] style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               //响应事件
                                                               //得到文本信息
                                                             UITextField * tf1 = alert.textFields[0];
                                                             if (tf1.text.length<1) {
                                                                 [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"dingshit1"]];
                                                             }else
                                                             {
                                                                 NSString *smscmd=[ [NSString alloc] initWithFormat:@"%@",tf1.text ];
                                                                 if ([self isPureNumandCharacters:smscmd]) {
                                                                     //全数字
                                                                     float mset= [smscmd floatValue];
                                                                     if (mset>=10&&mset<=999) {
                                                                         NSLog(@"开发上传设置");
                                                                         NSString* mcmd=[NSString stringWithFormat:@"MODE,2,%@",smscmd];
                                                                         [self SendTheCMDToDeviceby:mcmd];
                                                                     }else
                                                                     {
                                                                         [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"error"] withText:[SwichLanguage getString:@"dingshierror1"]];
                                                                     }
                                                                 }
                                                                 
                                                                 //验证协议操作
                                                             }
                                                             
                                                           }];
     UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              //NSLog(@"action = %@", alert.textFields);
                                                          }];
     [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
         textField.placeholder = [SwichLanguage getString:@"dingshiph"];
         textField.keyboardType = UIKeyboardTypeNumberPad;
     }];
     
     [alert addAction:okAction];
     [alert addAction:cancelAction];
     [self presentViewController:alert animated:YES completion:nil];
}

//蓝牙连接失败次数上报
-(void)showBLEConnectionFailTimeDailog
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"online10"]
                                                                    message:[SwichLanguage getString:@"blenote3"]
                                                             preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* okAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"setting"] style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               //响应事件
                                                               //得到文本信息
                                                             UITextField * tf1 = alert.textFields[0];
                                                             if (tf1.text.length<1) {
                                                                 [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"online10"] withText:[SwichLanguage getString:@"blenote2"]];
                                                             }else
                                                             {
                                                                 NSString *smscmd=[ [NSString alloc] initWithFormat:@"%@",tf1.text ];
                                                                 if ([self isPureNumandCharacters:smscmd]) {
                                                                     //全数字
                                                                     float mset= [smscmd floatValue];
                                                                     if (mset>=1&&mset<=255) {
                                                                         NSString* mcmd=[NSString stringWithFormat:@"blelinkfail,%@",smscmd];
                                                                         [self SendTheCMDToDeviceby:mcmd];
                                                                     }else
                                                                     {
                                                                         [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"online10"] withText:[SwichLanguage getString:@"blenote2"]];
                                                                     }
                                                                 }
                                                                 
                                                                 //验证协议操作
                                                             }
                                                             
                                                           }];
     UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              //NSLog(@"action = %@", alert.textFields);
                                                          }];
     [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
         textField.placeholder = [SwichLanguage getString:@"blenote2"];
         textField.keyboardType = UIKeyboardTypeNumberPad;
     }];
     
     [alert addAction:okAction];
     [alert addAction:cancelAction];
     [self presentViewController:alert animated:YES completion:nil];
}

//修改蓝牙名称
-(void)showModifyBLENameDailog
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[SwichLanguage getString:@"online9"]
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* okAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"setting"] style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               //响应事件
                                                               //得到文本信息
                                                             UITextField * tf1 = alert.textFields[0];
                                                             if (tf1.text.length<1) {
                                                                 [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"online9"] withText:[SwichLanguage getString:@"blenote1"]];
                                                             }else
                                                             {
                                                                 NSString *smscmd=[ [NSString alloc] initWithFormat:@"%@",tf1.text ];
                                                                 
                                                                     if (smscmd.length>0&&smscmd.length<14) {
                                                                         NSString* mcmd=[NSString stringWithFormat:@"blename,%@",smscmd];
                                                                         [self SendTheCMDToDeviceby:mcmd];
                                                                     }else
                                                                     {
                                                                         [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"online9"] withText:[SwichLanguage getString:@"blenote1"]];
                                                                     }
                                                                 
                                                                 
                                                                 //验证协议操作
                                                             }
                                                             
                                                           }];
     UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[SwichLanguage getString:@"cancel"] style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              //NSLog(@"action = %@", alert.textFields);
                                                          }];
     [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
         textField.placeholder = [SwichLanguage getString:@"blenote1"];
         textField.keyboardType = UIKeyboardTypeDefault;
     }];
     
     [alert addAction:okAction];
     [alert addAction:cancelAction];
     [self presentViewController:alert animated:YES completion:nil];
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

//周期上报
-(void)clickZhouQiDailog
{
    ZhouQiDailog* _ZhouQiDailog = [[ZhouQiDailog alloc] init];
    _ZhouQiDailog.delegate=self;
    [_ZhouQiDailog showInView:[UIApplication sharedApplication].keyWindow andIMEI:_imei];
}

//定时上报 mshowtype：1-闹铃上报模式  0-运动上报模式
-(void)clickDingShiDailog:(int)mshowtype
{
    DingShiDailog* _DingShiDailog = [[DingShiDailog alloc] init];
    _DingShiDailog.delegate=self;
    [_DingShiDailog showInView:[UIApplication sharedApplication].keyWindow andIMEI:_imei andShowType:mshowtype];
}

//打开设置定位类型弹出框
- (void)showLoctionTypeSettingDailog{
    //初始化
    _mAKRadioPopView = [[AKRadioPopView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)];
    //遵守协议
    _mAKRadioPopView.QCPopViewDelegate = self;
    //传递数据
    [_mAKRadioPopView showThePopViewWithArray:self.titleArray AndTitle:[SwichLanguage getString:@"offline1"]];
}
#pragma mark - QCPopViewDelegate
-(void)getTheButtonTitleWithIndexPath:(int)indexPath{
    
        //设置震动报警等级
    NSString* mcmd;
    switch (indexPath) {
            case 0:
                mcmd=@"POITYPE,0";
                break;
            case 1:
                mcmd=@"OITYPE,1";
                break;
            case 2:
                mcmd=@"POITYPE,1";
                break;
            case 3:
                mcmd=@"POITYPE,auto";
                break;
            default:
                break;
    }
    [self SendTheCMDToDeviceby:mcmd];
}

//验证密码
-(void)checkPasswordValueByImei:(NSString*)mtimei andPassWord:(NSString*)mpassword andType:(int)mtype
{
    _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    NSDictionary *bodyData =@{@"deviceImei":mtimei,
                              @"password":mpassword
                                };
     NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:407
                                                         withParameters:bodyData];
     [NetWorkModel POST:ServerURL
             parameters:parameters
                success:^(ResponseObject *messageCenterObject)
      {
         [self->_HUD hide:YES];
          NSDictionary *ret = messageCenterObject.ret;
          NSLog(@"send121CMD ret=%@",ret);
          int mretcode=[[ret objectForKey:@"result" ] intValue];
          if (mretcode==1) {
             // appDelegate.mYCKCSetModel = [[YCKCSetModel alloc] initWithJSON:messageCenterObject.ret];
              //刷新数据
              NSString* mscmd=[NSString stringWithFormat:@"RELAY,%d",mtype];
              //NSLog(@"SendTheCMDToDeviceby mcmd=%@",mscmd);
              [self SendTheCMDToDeviceby:mscmd];
          }else
          {
              NSString* msgstr=(NSString *)[messageCenterObject.ret objectForKey:@"msg"];
              if (msgstr.length==0) {
                  [MBProgressHUD showLogTipWIthTitle:nil withText:[SwichLanguage getString:@"passworderror"]];
              }else
              {
                  [MBProgressHUD showLogTipWIthTitle:nil withText:msgstr];
              }
          }
      }
                failure:^(NSError *error)
      {
         [self->_HUD hide:YES];
         [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"tips"] withText:[SwichLanguage getString:@"passworderror"]];
      }];
}

//获取设备配置参数
/**
 *64  获取设备基本信息
 请求命令字：64
 传入参数：imei
 返回内容：｛"retCode":"操作状态码(1-成功; 0失败)","retMsg":"操作状态说明","imei":"设备IMEI",
 “baseType”: “基本类型（0 有线，1：无线）”,“refillType”: “充值类型（0 标准，1 风控，2 蓝牙，3 手持 ，4  k8系列）”,“productType”: “产品类型（ 0 车载，1 蓝牙，2 手持, 3 远程控车， 4风控）”,“model”: “设备型号”｝
 */
-(void)SendCMD64ToGetData
{
    NSLog(@"SendCMD64ToGetData");
    //ProgressGetData 获取设备配置参数进度 0未获取 1获取中 2获取成功
    if(ProgressGetData==2||ProgressGetData==1)//已经有数据，直接跳出
    {
        return;
    }
    ProgressGetData=1;
    NSDictionary *bodyData =@{@"imei":_imei,
                                };
     NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:64
                                                         withParameters:bodyData];
     [NetWorkModel POST:ServerURL
             parameters:parameters
                success:^(ResponseObject *messageCenterObject)
      {
          NSDictionary *ret = messageCenterObject.ret;
          NSLog(@"send52CMD ret=%@",ret);
          int mretcode=[[ret objectForKey:@"retCode" ] intValue];
          if (mretcode==1) {
              self->ProgressGetData=2;
              self->basetype=[[ret objectForKey:@"baseType" ] intValue];
              self->_Model=[ret objectForKey:@"model"];
              self->productType=[[ret objectForKey:@"productType"]intValue];
              [self initUserCMDView];
          }else
          {
              NSString* msgstr=(NSString *)[messageCenterObject.ret objectForKey:@"retMsg"];
              if (msgstr.length==0) {
                  [MBProgressHUD showLogTipWIthTitle:nil withText:[SwichLanguage getString:@"errorA100X"]];
              }else
              {
                  [MBProgressHUD showLogTipWIthTitle:nil withText:msgstr];
              }
              self->ProgressGetData=0;
          }
      }
                failure:^(NSError *error)
      {
         self->ProgressGetData=0;
      }];
}

//判断mainStr 里面是否包含有mStr
-(BOOL)CheckHadStr:(NSString*)mStr ByMainStr:(NSString*)mmainStr
{
    if (mmainStr==NULL||mmainStr.length<1) {
        return false;
    }
    if (mStr==NULL||mStr.length<1) {
        return false;
    }
    if ([mmainStr rangeOfString:mStr].location!=NSNotFound) {
        return true;
    }else
    {
        return false;
    }
}

//判断是否要添加防盗录音
-(BOOL)IsNeedAntiReCording
{
    //NSLog(@"Model=%@",_Model);
    NSMutableArray* ListType = [[NSMutableArray alloc] initWithObjects:
                                @"ZT06",@"E06",@"DM06",@"ZT19R",@"ZT09R",@"DM19R",@"N6",@"N7",@"N8",@"N9",@"P6",@"P6B",@"P6C",
                       nil];
    for (int i=0; i<ListType.count; i++) {
        NSString* mstr=[ListType objectAtIndex:i];
        if ([self CheckHadStr:mstr ByMainStr:_Model]) {
            return true;
        }
    }
    return false;
}

//判断是否要添加防盗锁车
-(BOOL)IsNeedAntiLock
{
    //NSLog(@"Model=%@",_Model);
    NSMutableArray* ListType = [[NSMutableArray alloc] initWithObjects:
                                @"U9",@"ZT06",@"E06",@"DM06",@"EG10",@"GS02",
                       nil];
    for (int i=0; i<ListType.count; i++) {
        NSString* mstr=[ListType objectAtIndex:i];
        if ([self CheckHadStr:mstr ByMainStr:_Model]) {
            return true;
        }
    }
    return false;
}
@end
