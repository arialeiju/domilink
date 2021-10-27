//
//  SettingGridViewController.m
//  DM100
//
//  Created by 马真红 on 2021/10/8.
//  Copyright © 2021 aika. All rights reserved.
//

#import "SettingGridViewController.h"
#import "SettingGridViewCell.h"
#import "GridHeaderView.h"
#import "GridFooterView.h"
#import "FenceViewController.h"
#import "AlarmSettingPlusController.h"
#import "CheckCMDViewController.h"
#import "MediaPlayViewController.h"
#import "OnlineCMDService.h"
#import "ZhouQiDailog.h"
#import "AKRadioPopView.h"
#import "DingShiDailog.h"
#import "ChangePasswordViewController.h"
@interface SettingGridViewController ()<ZhouQiDailogDelegate,DingShiDailogDelegate>
{
    NSString *_imei;
    NSString *_devicetype;
    NSString *_imeiname;
    
    MBProgressHUD * _HUD;
    NSString * _cmdremeber;
    int ProgressGetData;//获取设备配置参数进度 0未获取 1获取中 2获取成功
    NSString *_Model;
    int basetype;//有线和无线
    int productType;
}
@end

#define KCellID @"SettingGridViewCell"
@implementation SettingGridViewController
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
        CGRect newfame=self.SettingGridConllection.frame;
        newfame.origin.y=newfame.origin.y+IPXMargin;
        newfame.size.height=newfame.size.height-IPXMargin;
        [self.SettingGridConllection setFrame:newfame];
    }
    [self setUpCollection];
    [self SendCMD64ToGetData];
}

-(void)setUpCollection
{
    self.dataArr1=[NSMutableArray array];
    self.dataArr2=[NSMutableArray array];
    self.dataArr3=[NSMutableArray array];
    self.imageArr1=[NSMutableArray array];
    self.imageArr2=[NSMutableArray array];
    self.imageArr3=[NSMutableArray array];
    
    [self.dataArr1 addObject:[SwichLanguage getString:@"setitem9"]];
    [self.dataArr1 addObject:[SwichLanguage getString:@"setitem7"]];
    [self.dataArr1 addObject:[SwichLanguage getString:@"page4item7"]];
    [self.dataArr1 addObject:[SwichLanguage getString:@"setitem10"]];
    
    [self.imageArr1 addObject:@"gridm1"];
    [self.imageArr1 addObject:@"gridm2"];
    [self.imageArr1 addObject:@"gridm3"];
    [self.imageArr1 addObject:@"gridm4"];
    
    [self.dataArr2 addObject:[SwichLanguage getString:@"offline2"]];
    [self.dataArr2 addObject:[SwichLanguage getString:@"offline3"]];
    [self.dataArr2 addObject:[SwichLanguage getString:@"offline4"]];
    [self.dataArr2 addObject:[SwichLanguage getString:@"setitem6"]];
    [self.dataArr2 addObject:[SwichLanguage getString:@"offline6"]];
    [self.dataArr2 addObject:[SwichLanguage getString:@"online6"]];
    
    [self.imageArr2 addObject:@"gridu1"];
    [self.imageArr2 addObject:@"gridu2"];
    [self.imageArr2 addObject:@"gridu3"];
    [self.imageArr2 addObject:@"gridu4"];
    [self.imageArr2 addObject:@"gridu5"];
    [self.imageArr2 addObject:@"gridu6"];
    
    [self.dataArr3 addObject:[SwichLanguage getString:@"online1"]];
    [self.dataArr3 addObject:[SwichLanguage getString:@"online2"]];
    [self.dataArr3 addObject:[SwichLanguage getString:@"online3"]];
    [self.dataArr3 addObject:[SwichLanguage getString:@"online4"]];
    [self.dataArr3 addObject:[SwichLanguage getString:@"setitem8"]];
    
    [self.imageArr3 addObject:@"gridc1"];
    [self.imageArr3 addObject:@"gridc2"];
    [self.imageArr3 addObject:@"gridc3"];
    [self.imageArr3 addObject:@"gridc4"];
    [self.imageArr3 addObject:@"gridc5"];
    
    self.SettingGridConllection.delegate=self;
    self.SettingGridConllection.dataSource=self;
    //[self.SettingGridConllection registerClass:[SettingGridViewCell class] forCellWithReuseIdentifier:KCellID];
    [self.SettingGridConllection registerNib:[UINib nibWithNibName:@"SettingGridViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SettingGridViewCell"];
    
    [self.SettingGridConllection registerNib:[UINib nibWithNibName:@"GridHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GridHeaderView"];//注册组头
    [self.SettingGridConllection registerNib:[UINib nibWithNibName:@"GridFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"GridFooterView"];//注册组尾
    
    self.SettingGridConllection.showsVerticalScrollIndicator=NO;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return _imageArr1.count;
    }else if (section==1) {
        return _imageArr2.count;
    }else if (section==2) {
        return _imageArr3.count;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SettingGridViewCell *cell = (SettingGridViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SettingGridViewCell" forIndexPath:indexPath];
//    cell.title.text=@"AIKA";
//    cell.title.backgroundColor=[UIColor greenColor];
//    NSString *imageToLoad = [NSString stringWithFormat:@"%d.JPG", indexPath.row];
//
//
//    cell.imageView.image = [UIImage imageNamed:imageToLoad];
    NSString *imageToLoad;
    NSString *mtitle;
    if (indexPath.section==0) {
        imageToLoad=[_imageArr1 objectAtIndex:indexPath.row];
        mtitle=[_dataArr1 objectAtIndex:indexPath.row];
        
    }else if (indexPath.section==1) {
        imageToLoad=[_imageArr2 objectAtIndex:indexPath.row];
        mtitle=[_dataArr2 objectAtIndex:indexPath.row];
    }else if (indexPath.section==2) {
        imageToLoad=[_imageArr3 objectAtIndex:indexPath.row];
        mtitle=[_dataArr3 objectAtIndex:indexPath.row];
    }
    
    [cell setFitTitle:mtitle];
    cell.imageview.image= [UIImage imageNamed:imageToLoad];
    return cell;

}
//定义展示的Section的个数

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat mw=(VIEWWIDTH-20)/3;
    return CGSizeMake(mw,mw*9/12);
}

//单独设置每个header的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(VIEWWIDTH-20, 45);
}

//单独设置每个footer的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(VIEWWIDTH-20, 10);
}

//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        GridHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GridHeaderView" forIndexPath:indexPath];
        if(indexPath.section==0)
        {
            headerView.label.text=[SwichLanguage getString:@"basic"];
        }else if(indexPath.section==1)
        {
            headerView.label.text=[SwichLanguage getString:@"setitem4"];
        }else if(indexPath.section==2)
        {
            headerView.label.text=[SwichLanguage getString:@"setitem3"];
        }
        return headerView;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        GridFooterView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"GridFooterView" forIndexPath:indexPath];
        return headerView;
    }
    
    return nil;
}

////每个 section的margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 10, 0);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"collectionView 点击 row=%ld section=%ld",(long)indexPath.row,(long)indexPath.section);
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 3:
            {//电子围栏
                FenceViewController *mFenceViewController=[[FenceViewController alloc]initWithImei:_imei andImeiName:_imeiname];
                [self.navigationController pushViewController:mFenceViewController animated:YES];
            }
                break;
            case 0:
            {//报警设置
                AlarmSettingPlusController *mAlarmSettingPlusController = [[AlarmSettingPlusController alloc]initWithImei:_imei anddevicetype:_devicetype andImeiName:_imeiname];
                [self.navigationController pushViewController:mAlarmSettingPlusController animated:YES];
            }
                break;
            case 1:
            {//指令历史记录
                CheckCMDViewController* mCheckCMDViewController = [[CheckCMDViewController alloc]initWithImei:_imei];
                [self.navigationController pushViewController:mCheckCMDViewController animated:YES];
            }
                break;
            case 2:
            {//修改设备密码
                ChangePasswordViewController * changePasswordViewController = [[ChangePasswordViewController alloc] initWithImei:_imei WithDeviceType:@"1" AndShowType:1];
                [self.navigationController pushViewController:changePasswordViewController animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else if(indexPath.section==2)
    {
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
    }else if(indexPath.section==1)
    {
        NSString* clickname=[_dataArr2 objectAtIndex:indexPath.row];
        
//        [self.dataArr2 addObject:[SwichLanguage getString:@"offline2"]];
//        [self.dataArr2 addObject:[SwichLanguage getString:@"offline3"]];
//        [self.dataArr2 addObject:[SwichLanguage getString:@"offline4"]];
//        [self.dataArr2 addObject:[SwichLanguage getString:@"setitem6"]];
//        [self.dataArr2 addObject:[SwichLanguage getString:@"offline6"]];
//        [self.dataArr2 addObject:[SwichLanguage getString:@"online6"]];
        
        //报警设置
        if([clickname isEqualToString:[SwichLanguage getString:@"offline2"]]) {
            [self clickDingShiDailog:0];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"offline5"]]) {
            [self clickDingShiDailog:1];
        }else if([clickname isEqualToString:[SwichLanguage getString:@"offline6"]]) {
            [self showOilOnOrOffDailog];
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
    }
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

-(void)initUserCMDView
{
    //位置类型
    //[_offlinelist addObject:[SwichLanguage getString:@"offline1"]];
    //[_offlineIconlist addObject:[SwichLanguage getString:@"set41"]];
    [self.dataArr2 removeAllObjects];
    [self.imageArr2 removeAllObjects];
    

    //运动上报模式
    [self.dataArr2 addObject:[SwichLanguage getString:@"offline2"]];
    [self.imageArr2 addObject:@"gridu1"];
    //实时在线模式
    [self.dataArr2 addObject:[SwichLanguage getString:@"offline4"]];
    [self.imageArr2 addObject:@"gridu3"];

    
    if(basetype==1)
    {
        //周期上报模式
        [self.dataArr2 addObject:[SwichLanguage getString:@"offline3"]];
        [self.imageArr2 addObject:@"gridu2"];
        //闹铃上报模式
        [self.dataArr2  addObject:[SwichLanguage getString:@"offline5"]];
        [self.imageArr2 addObject:[SwichLanguage getString:@"gridu7"]];
    }
    
    
    if(productType==1)//蓝牙设备
    {
        //查询蓝牙名称
        [self.dataArr2 addObject:[SwichLanguage getString:@"online8"]];
        [self.imageArr2 addObject:[SwichLanguage getString:@"gridu8"]];
        if(basetype==0)
        {
        //修改蓝牙名称
        [self.dataArr2  addObject:[SwichLanguage getString:@"online9"]];
        [self.imageArr2 addObject:[SwichLanguage getString:@"gridu9"]];
        }else
        {
        //蓝牙连接失败次数上报
        [self.dataArr2  addObject:[SwichLanguage getString:@"online10"]];
        [self.imageArr2 addObject:[SwichLanguage getString:@"gridu10"]];
        }
    }
    
    //重启设备
    [self.dataArr2  addObject:[SwichLanguage getString:@"online6"]];
    [self.imageArr2 addObject:[SwichLanguage getString:@"gridu6"]];
    
    if([self IsNeedAntiReCording])
    {
        //语音监听
        [self.dataArr2 addObject:[SwichLanguage getString:@"setitem6"]];
        [self.imageArr2 addObject:[SwichLanguage getString:@"gridu4"]];
    }
    
    if([self IsNeedAntiLock])
    {
        //防盗锁车
        [self.dataArr2 addObject:[SwichLanguage getString:@"offline6"]];
        [self.imageArr2 addObject:[SwichLanguage getString:@"gridu5"]];
        
    }
    [self.SettingGridConllection reloadData];
    
}
@end
