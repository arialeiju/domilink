//
//  APMainMapViewController.m
//  domilink
//
//  Created by 马真红 on 2020/5/16.
//  Copyright © 2020 aika. All rights reserved.
//

#import "APMainMapViewController.h"
#import "DeviceDetailViewController.h"
#import "SettingViewController.h"
#import "CarAlarmViewController.h"
#import "AppleHistoryTrackController.h"
#import "DefenseService.h"
#import "MapLoctionSwich.h"
@interface APMainMapViewController ()<MKMapViewDelegate>
{
    __weak IBOutlet UIView *messageView;
    CGFloat mviewHeightC;//当前信息页面高度
    int ShowType;//信息界面显示模式  1 - 显示详细内容  ，  2 -隐藏详细内容
    Boolean NeedLoadView;//优化保证只加载界面刷新一次
    Boolean isCenter;//设置下次地图刷新时候是否要移动到中心
    Boolean isTrack;//是否选中跟踪模式
    NSTimer *_refreshTimer;
    
    CLLocationCoordinate2D _deviceCoor;

    Boolean isSatSelect;//卫星地图按钮是否被选中
    Boolean isZZSelect;//是否追踪按钮选中
    Boolean isGSM;//是否有信号强度提醒
    MKCircle * _circle;
    CLLocationCoordinate2D _deviceDenfenseCoor;
    MKAnnotationView *_carAnnotationView;//图标logo
    MKPointAnnotation * _deviceAnnotation;//图标
    
    NSString* mdevstatus;
    NSString* mcouse;
    NSString* mlogoType;
    NSMutableArray * mlinelist;//折线图数组
    MBProgressHUD * _HUD_userlist;
}
@end

@implementation APMainMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self InitAllView];
    isCenter=false;
    isSatSelect=false;
    isZZSelect=false;
    mdevstatus=@"1";
    mcouse=@"0";
    mlogoType=@"1";
    isGSM=false;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [self stopNSTimer];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (NeedLoadView) {
        //第一次打开界面的刷新
        [self setupMapView];
        [self updataViewShowWithType:ShowType];
        [self UpdateViewLanguage];
        [self autoUIadapter];
        NeedLoadView=false;
    }
    
    [self Page2BeginToShow];
    [self startNSTimer];
}

//自动界面适配
-(void)autoUIadapter
{
    NSLog(@"autoUIadapter=%f",messageView.frame.size.width);
    float allwidth=messageView.frame.size.width;
    if (allwidth<355) {//符合要求，调整大小
        [_tv4 setFont:[UIFont systemFontOfSize:9]];
        [_tv5 setFont:[UIFont systemFontOfSize:9]];
        [_tv6 setFont:[UIFont systemFontOfSize:9]];
        [_tv7 setFont:[UIFont systemFontOfSize:9]];
        CGRect mlabel=self.btlabel1.frame;
        mlabel.origin.x=allwidth/8-9;
        [_btlabel1 setFrame:mlabel];
        [_btlabel2 setFrame:mlabel];
        [_btlabel3 setFrame:mlabel];
        [_btlabel4 setFrame:mlabel];
        //CGRect mimg=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, 16, 16)
    }
    //左右栏控件适配
    CGRect mframe2=_controlview2.frame;
    
    float mmY=_mapView.frame.size.height/2-mframe2.size.height;//左中 右中 起点
    mframe2.origin.y=mmY;
    [_controlview2 setFrame:mframe2];
    
    CGRect mframe1=_controlview1.frame;
    mframe1.origin.y=mmY;
    [_controlview1 setFrame:mframe1];
    
    CGRect mframe3=_controlview3.frame;
    mframe3.origin.y=mmY-mframe3.size.height-_mapView.frame.size.height/15;
    [_controlview3 setFrame:mframe3];
    
    CGRect mframe4=_controlview4.frame;
    mframe4.origin.y=mmY-mframe4.size.height-_mapView.frame.size.height/15;
    [_controlview4 setFrame:mframe4];
    
    //设置分割线
    UIView* mline1=[[UIView alloc]initWithFrame:CGRectMake(3, 40, 24, 1)];
    mline1.backgroundColor=[UIColor lightGrayColor];
    [_controlview1 addSubview:mline1];
    
    UIView* mline2=[[UIView alloc]initWithFrame:CGRectMake(3, 40, 24, 1)];
    mline2.backgroundColor=[UIColor lightGrayColor];
    [_controlview2 addSubview:mline2];
    
    UIView* mline3=[[UIView alloc]initWithFrame:CGRectMake(3, 40, 24, 1)];
    mline3.backgroundColor=[UIColor lightGrayColor];
    [_controlview3 addSubview:mline3];
    
    UIView* mline41=[[UIView alloc]initWithFrame:CGRectMake(3, 40, 24, 1)];
    mline41.backgroundColor=[UIColor lightGrayColor];
    [_controlview4 addSubview:mline41];
    UIView* mline42=[[UIView alloc]initWithFrame:CGRectMake(3, 80, 24, 1)];
    mline42.backgroundColor=[UIColor lightGrayColor];
    [_controlview4 addSubview:mline42];
}

// 视图被销毁
- (void)dealloc {
    NSLog(@"CarListViewController界面销毁");
    if(_mapView!=nil)
    {
        _mapView.delegate=nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 * description:切换到界面2时候参数刷新处理函数
 */
-(void)Page2BeginToShow
{
    [self goPage2AndUpdate];
    [self checklistsize];
}
/**
 *  page2 进入时候 数据初始化刷新 和切换选中设备更新
 */
-(void)goPage2AndUpdate
{
    NSLog(@"goPage2AndUpdate");
    isCenter=true;
    [self TackOff];
    if(self.inAppSetting.checkhaddata)
    {
        UnitModel* mUnitModel=[self.inAppSetting getSelectUnit];
        [_tvname setText:[mUnitModel getName]];
        [_tv2 setText:[mUnitModel getsigTime]];
        [_tv3 setText:[mUnitModel getlocTime]];
        //_deviceCoor = CLLocationCoordinate2DMake([mUnitModel getLat], [mUnitModel getLot]);
        _deviceCoor=[MapLoctionSwich bd09togcj02:[mUnitModel getLot] and:[mUnitModel getLat]];
        //地图  预设中心点
        [_mapView setCenterCoordinate:_deviceCoor];
        
        [self setUpAnnotation];
    }else
    {
        [self updataViewShowWithType:2];
         _deviceCoor = CLLocationCoordinate2DMake(0,0);
    }
}
/**
 * description:检查缓存设备列表数量，小于2则隐藏切换按钮
 */
-(void)checklistsize
{
    if(self.inAppSetting.user_itemList.count<2)
    {
        [_controlview1 setHidden:YES];
    }else
    {
        [_controlview1 setHidden:NO];
    }
}

//刷新语言
-(void)UpdateViewLanguage
{
    [self.btlabel1 setText:[SwichLanguage getString:@"p2tv1"]];
    [self.btlabel2 setText:[SwichLanguage getString:@"p2tv2"]];
    [self.btlabel3 setText:[SwichLanguage getString:@"p2tv3"]];
    [self.btlabel4 setText:[SwichLanguage getString:@"p2tv4"]];
    [self.btlabel5 setText:[SwichLanguage getString:@"details"]];
    [self.btlabel6 setText:[SwichLanguage getString:@"setting"]];
    [self.tvlabel1 setText:[SwichLanguage getString:@"loctype"]];
    [self.tvlabel2 setText:[SwichLanguage getString:@"loctime"]];
    [self.tvlabel3 setText:[SwichLanguage getString:@"sigtime"]];
    [self.tvlabel4 setText:[SwichLanguage getString:@"power"]];
    [self.tvlabel5 setText:[SwichLanguage getString:@"volt"]];
    [self.tvlabel6 setText:[SwichLanguage getString:@"model"]];
    [self.TopLlabel1 setText:[SwichLanguage getString:@"pg2mt1"]];
    [self.TopLlabel2 setText:[SwichLanguage getString:@"pg2mt2"]];
    [self.TopLlabel3 setText:[SwichLanguage getString:@"pg2mt3"]];
    [self.TopRlabel1 setText:[SwichLanguage getString:@"pg2mt4"]];
    [self.TopRlabel2 setText:[SwichLanguage getString:@"pg2mt5"]];
}


//代码设置信息框 界面  非常重要
#define mviewHeightH 50 //信息页面隐藏时候高度
#define mviewHeightS 246 //信息页面显示时候高度
#define mviewMargin 10 //信息页面距离周边margin
-(void)InitAllView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateViewLanguage) name:@"changeLanguage" object:nil];
    messageView.layer.cornerRadius=5.0f;
    messageView.layer.masksToBounds = YES;
    messageView.layer.borderWidth = 1;
    messageView.layer.borderColor = [[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1] CGColor];
    [messageView setBackgroundColor:[UIColor whiteColor]];
    ShowType=1;
    NeedLoadView=true;
    _btlabel1.adjustsFontSizeToFitWidth=YES;
    _btlabel2.adjustsFontSizeToFitWidth=YES;
    _btlabel3.adjustsFontSizeToFitWidth=YES;
    _btlabel4.adjustsFontSizeToFitWidth=YES;
    _btlabel5.adjustsFontSizeToFitWidth=YES;
    _btlabel6.adjustsFontSizeToFitWidth=YES;
    _tvlabel1.adjustsFontSizeToFitWidth=YES;
    _tvlabel2.adjustsFontSizeToFitWidth=YES;
    _tvlabel3.adjustsFontSizeToFitWidth=YES;
    _tvlabel4.adjustsFontSizeToFitWidth=YES;
    _tvlabel5.adjustsFontSizeToFitWidth=YES;
    _tvlabel6.adjustsFontSizeToFitWidth=YES;
    _tvlabel7.adjustsFontSizeToFitWidth=YES;
    _TopLlabel1.adjustsFontSizeToFitWidth=YES;
    _TopLlabel2.adjustsFontSizeToFitWidth=YES;
    _TopLlabel3.adjustsFontSizeToFitWidth=YES;
    _TopRlabel1.adjustsFontSizeToFitWidth=YES;
    _TopRlabel2.adjustsFontSizeToFitWidth=YES;
    _tv6.adjustsFontSizeToFitWidth=YES;
    _tvstatus.adjustsFontSizeToFitWidth=YES;
    _tvname.adjustsFontSizeToFitWidth=YES;
    _tvaddress.adjustsFontSizeToFitWidth=YES;
    UITapGestureRecognizer *tapGes1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickButton1)];
    [_bt1 addGestureRecognizer:tapGes1];
    UITapGestureRecognizer *tapGes2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickButton2)];
    [_bt2 addGestureRecognizer:tapGes2];
    UITapGestureRecognizer *tapGes3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickButton3)];
    [_bt3 addGestureRecognizer:tapGes3];
    UITapGestureRecognizer *tapGes4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickButton4)];
    [_bt4 addGestureRecognizer:tapGes4];
    UITapGestureRecognizer *tapGes5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickButton5)];
    [_bt5 addGestureRecognizer:tapGes5];
    UITapGestureRecognizer *tapGes6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickButton6)];
    [_bt6 addGestureRecognizer:tapGes6];
    UITapGestureRecognizer *tapGesTL1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTopLButton1)];
    [_TopLView1 addGestureRecognizer:tapGesTL1];
    UITapGestureRecognizer *tapGesTL2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTopLButton2)];
    [_TopLView2 addGestureRecognizer:tapGesTL2];
    UITapGestureRecognizer *tapGesTL3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTopLButton3)];
    [_TopLView3 addGestureRecognizer:tapGesTL3];
    UITapGestureRecognizer *tapGesTR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTopRButton1)];
    [_TopRView1 addGestureRecognizer:tapGesTR1];
    UITapGestureRecognizer *tapGesTR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickTopRButton2)];
    [_TopRView2 addGestureRecognizer:tapGesTR2];
    _bt5.layer.cornerRadius=5.0f;
    _bt5.layer.masksToBounds = YES;
    _bt6.layer.cornerRadius=5.0f;
    _bt6.layer.masksToBounds = YES;
    _controlview1.layer.cornerRadius=5.0f;
    _controlview1.layer.masksToBounds = YES;
    _controlview1.layer.borderWidth = 1;
    _controlview1.layer.borderColor = [[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1] CGColor];
    _controlview2.layer.cornerRadius=5.0f;
    _controlview2.layer.masksToBounds = YES;
    _controlview2.layer.borderWidth = 1;
    _controlview2.layer.borderColor = [[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1] CGColor];
    _controlview3.layer.cornerRadius=5.0f;
    _controlview3.layer.masksToBounds = YES;
    _controlview3.layer.borderWidth = 1;
    _controlview3.layer.borderColor = [[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1] CGColor];
    _controlview4.layer.cornerRadius=5.0f;
    _controlview4.layer.masksToBounds = YES;
    _controlview4.layer.borderWidth = 1;
    _controlview4.layer.borderColor = [[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1] CGColor];
}
//刷新messageview 等界面位置。 1 - 显示  ，  2 -隐藏详细内容
-(void)updataViewShowWithType:(int)mtype
{
    switch (mtype) {
        case 1:
        {
            mviewHeightC=mviewHeightS;
            self.btChange.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
            break;
        case 2:
        {
            mviewHeightC=mviewHeightH;
            self.btChange.imageView.transform = CGAffineTransformIdentity;
        }
            break;
    }
    ShowType=mtype;
    CGFloat originY=self.view.frame.size.height-TABBARHEIGHT-IPXMargin-mviewHeightC-mviewMargin;//设置tableview的起点
    CGRect framenew= CGRectMake(mviewMargin,
                                originY,
                                VIEWWIDTH-mviewMargin*2,
                                mviewHeightC);
    [messageView setFrame:framenew];
    
    [self.btChange setFrame:CGRectMake(VIEWWIDTH-mviewMargin-25, originY-24-mviewMargin/2, 25, 25)];//25X25
    [self.bt5 setFrame:CGRectMake(mviewMargin, originY-30-mviewMargin/2, 70, 30)];// 70X30
    [self.bt6 setFrame:CGRectMake(mviewMargin+self.bt5.frame.size.width+mviewMargin/2, originY-30-mviewMargin/2, 70, 30)];//70x30
}
- (IBAction)clickChangeButton:(id)sender {
    if (ShowType==1) {
        [self updataViewShowWithType:2];//隐藏
    }else
    {
        [self updataViewShowWithType:1];//显示
    }
}
-(void)ClickButton1
{
    NSLog(@"点击按钮1");
}
-(void)ClickButton2
{
    //NSLog(@"点击按钮2");
    if ([self.inAppSetting checkhaddata]) {
        UnitModel *detail = [self.inAppSetting getSelectUnit];
        CLLocationCoordinate2D mdeviceCoor=CLLocationCoordinate2DMake([detail getLat], [detail getLot]);
        AppleHistoryTrackController *historyTrackVC = [[AppleHistoryTrackController alloc] initWithImei:[detail getImei] Withlalo:mdeviceCoor];
        [self.navigationController pushViewController:historyTrackVC animated:YES];
    }
}
-(void)ClickButton3
{
    NSLog(@"点击按钮3");
    [self SetDefenseButtonDo:true];
}
-(void)ClickButton4
{
    NSLog(@"点击按钮4");
    [self SetDefenseButtonDo:false];
}

//详情按钮
-(void)ClickButton5
{
    if ([self.inAppSetting checkhaddata]) {
        UnitModel *detail = [self.inAppSetting getSelectUnit];
        DeviceDetailViewController *mDeviceDetailViewController = [[DeviceDetailViewController alloc]initWithImei:[detail getImei] andName:[detail getName] andplateNumber:[detail getCarNumber]];
        [self.navigationController pushViewController:mDeviceDetailViewController animated:YES];
    }
}
//设置按钮
-(void)ClickButton6
{
    NSLog(@"点击按钮6");
    if ([self.inAppSetting checkhaddata]) {
        UnitModel *detail = [self.inAppSetting getSelectUnit];
        SettingViewController *mSettingViewController = [[SettingViewController alloc]initWithImei:[detail getImei] anddevicetype:detail.devType];
        [self.navigationController pushViewController:mSettingViewController animated:YES];
    }
}
-(void)ClickTopRButton1
{
    NSLog(@"点击按钮 车");
    if ([self.inAppSetting checkhaddata])
    {
        [self TackOff];
        _mapView.showsUserLocation=NO;
        [_mapView setCenterCoordinate:_deviceCoor];
        //[_mapView setZoomLevel:17];
        MKCoordinateSpan span = MKCoordinateSpanMake(0.005,0.005);
        [_mapView setRegion:MKCoordinateRegionMake(_deviceCoor, span) animated:NO];
    }
    
}
-(void)ClickTopRButton2
{
    NSLog(@"点击按钮 我的，需要真机验证");
    [self TackOff];
    _mapView.showsUserLocation=YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
}
-(void)ClickTopLButton1
{
    if (isSatSelect) {
        isSatSelect=false;
        [_TopLView1 setBackgroundColor:[UIColor whiteColor]];
        [_mapView setMapType:MKMapTypeStandard];
    }else
    {
        isSatSelect=true;
        [_TopLView1 setBackgroundColor:[UIColor grayColor]];
        [_mapView setMapType:MKMapTypeSatellite];
    }
    
    if (_carAnnotationView!=nil) {
        _carAnnotationView.image =[self getShowImage:mdevstatus AndCouse:mcouse AndLogoType:mlogoType];
        //NSLog(@"ClickTopLButton1 IN!");
    }
}
-(void)ClickTopLButton2
{
    if ([self.inAppSetting checkhaddata]) {
        UnitModel *detail = [self.inAppSetting getSelectUnit];
        CarAlarmViewController *mCarAlarmViewController = [[CarAlarmViewController alloc]initWithImei:[detail getImei] anddevicetype:@"1"];
        [self.navigationController pushViewController:mCarAlarmViewController animated:YES];
    }
}
-(void)ClickTopLButton3
{
    if (isZZSelect) {
        [self TackOff];
    }else
    {
        [self TackOn];
    }
}
//设置追踪按钮选中状态
-(void)setZZButtonSelected:(Boolean)mselect
{
    if (mselect) {
        isZZSelect=true;
        [_TopLView3 setBackgroundColor:[UIColor grayColor]];
    }else
    {
        isZZSelect=false;
        [_TopLView3 setBackgroundColor:[UIColor whiteColor]];
    }
}


- (void)SetDefenseButtonDo:(Boolean)misBufang
{
    if (![self.inAppSetting checkhaddata]) {//没数据，退出
        return;
    }
    //[sender setEnabled:NO];
    _HUD_userlist = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UnitModel* mdata=[self.inAppSetting getSelectUnit];
    [DefenseService setDefenseWithImei:[mdata getImei]
                       withDefenseType:(misBufang?DefenseTypeSet:DefenseTypeRemove)
                               success:^(ResponseObject *responseObject) {
                                   [_HUD_userlist hide:YES];
                                   
                                   
                                   NSDictionary *ret = responseObject.ret;
                                   NSString *mret=[NSString stringWithFormat:@"%@",[ret objectForKey:@"ret"]];
                                   NSString *mstatus=[NSString stringWithFormat:@"%@",[ret objectForKey:@"status"]];
                                   if ([mstatus isEqualToString:@"1"])
                                   {
                                   }
                                   else
                                   {
                                   }
                                   if ([mret isEqualToString:@"0"]) {
                                       NSString *mcontent=[NSString stringWithFormat:@"%@",[ret objectForKey:@"content"]];
                                       [MBProgressHUD showLogTipWIthTitle:nil withText:mcontent];
                                   }
                                   [self reStartNSTimer];
                               }
                               failure:^(NSError *error) {
                                   [_HUD_userlist hide:YES];
                                   [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA107X"] withText:nil];
                               }];
}

/**
 *  page2 定时器
 */
-(void)stopNSTimer
{
    //NSLog(@"stopNSTimer");
    if (_refreshTimer != nil)
    {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
}

-(void)startNSTimer
{
    [self stopNSTimer];
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:nstimers
                                                     target:self
                                                   selector:@selector(refreshaction)
                                                   userInfo:nil
                                                    repeats:YES];
    [_refreshTimer fire];
     //NSLog(@"startNSTimer");
}
-(void)reStartNSTimer
{
    if (_refreshTimer==nil) {
        [self startNSTimer];
    }else
    {
        [_refreshTimer fire];
    }
}
//定时器触发
-(void)refreshaction
{
    if([self.inAppSetting checkhaddata]) {//检测有选中
        //NSLog(@"refreshaction");
        //reloadCarListby854();
        if (_HUD_userlist!=nil) {
            [_HUD_userlist setHidden:YES];
            _HUD_userlist =nil;
        }
        [self reloadCarListby854];
    }
}

/**
 * 界面2 定位数据加载
 */
-(void)reloadCarListby854
{
    typeof(self) __weak weakSelf = self;
    UnitModel * mUnitModel=[self.inAppSetting getSelectUnit];
    NSDictionary *bodyData = @{@"imei": [mUnitModel getImei],
                               @"langu":@"0"};
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:854
                                                        withParameters:bodyData];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *messageCenterObject)
     {
         NSDictionary* ret=messageCenterObject.ret;
         //NSString* la=[ret objectForKey:@"la"];
         //NSString* lo=[ret objectForKey:@"lo"];
         NSString* la=[NSString stringWithFormat:@"%@",[ret objectForKey:@"la"]];
         NSString* lo=[NSString stringWithFormat:@"%@",[ret objectForKey:@"lo"]];
        
         //获取数据时候就转化了
        CLLocationCoordinate2D mlalo=[MapLoctionSwich bd09togcj02:[lo floatValue] and:[la floatValue]];
         float ila= mlalo.latitude;
         float ilo= mlalo.longitude;
         
         NSString* gpsStar=[NSString stringWithFormat:@"%@",[ret objectForKey:@"gpsStar"]];
         NSString* beidouStar=[NSString stringWithFormat:@"%@",[ret objectForKey:@"beidouStar"]];
         NSString* gsmSignal=[NSString stringWithFormat:@"%@",[ret objectForKey:@"gsmSignal"]];
         //NSLog(@"a=%@ b=%@ c=%@",gpsStar,beidouStar,gsmSignal);
         
         NSString* mloctime=[ret objectForKey:@"stsTime"];
         NSString* msigtime=[ret objectForKey:@"signalTime"];
         NSString* model1= [self checkifunupdate:[ret objectForKey:@"model1"] withStr:@""];
         NSString* model2= [self checkifunupdate:[ret objectForKey:@"model2"] withStr:@""];
         NSString* model= [self checkifunupdate:[ret objectForKey:@"mode"] withStr:@""];
         NSString* deviceSts=[ret objectForKey:@"deviceSts"];
         NSString* speedstr=[ret objectForKey:@"speed"];
         //NSLog(@"a=%@ b=%@ c=%@",model1,model2,model);
         //为图标有方向做准备
         self->mcouse=[ret objectForKey:@"course"];
         self->mdevstatus=deviceSts;//设置设备离线状态
        
        NSString* mmlogo=[NSString stringWithFormat:@"%@",[ret objectForKey:@"logoType"]];
        if ([mmlogo isEqualToString:@"(null)"]) {
             self->mlogoType=@"1";
        }else
        {
            self->mlogoType=mmlogo;
        }
        
         NSString* accSts=[ret objectForKey:@"accSts"];
         NSLog(@"accSts=%@",accSts);
         NSString* delon=[NSString stringWithFormat:@"%@",[ret objectForKey:@"delon"]];
         NSString* delat=[NSString stringWithFormat:@"%@",[ret objectForKey:@"delat"]];
        
        CLLocationCoordinate2D mdelalo=[MapLoctionSwich bd09togcj02:[delon floatValue] and:[delat floatValue]];
         float dela= mdelalo.latitude;
         float delo= mdelalo.longitude;
//         float dela= [delat floatValue];
//         float delo= [delon floatValue];
         
         //是否布防状态
         NSString* bufangstr=[ret objectForKey:@"defense"];
         Boolean isbufuang= ![bufangstr isEqualToString:@"0"];
         float mspeed= [speedstr floatValue];
         //定位时间
         [weakSelf.tv2 setText:mloctime];
         //心跳时间
         [weakSelf.tv3 setText:msigtime];
         //定位类型
         [weakSelf.tv1 setText:[self.inAppSetting returnthestringbytype:[ret objectForKey:@"type"]]];
         //acc
         [weakSelf.tv7 setText:([accSts isEqualToString:@"1"]?[SwichLanguage getString:@"open"]:[SwichLanguage getString:@"close"])];
         //模式
         [weakSelf.tv6 setText:[NSString stringWithFormat:@"%@(1/%@ 2/%@h)",model,model1,model2]];
         
         //设置卫星信号以及复炸的 电量 电压
         if ([gpsStar isEqualToString:@"-1"]||[gpsStar isEqualToString:@"null"]) {
             isGSM=false;
             [weakSelf.tvlabel4 setText:[SwichLanguage getString:@"power"]];
             [weakSelf.tvlabel5 setText:[SwichLanguage getString:@"volt"]];
             //电量
             [weakSelf.tv4 setText:[self checkifunupdate:[NSString stringWithFormat:@"%@",[ret objectForKey:@"power"]] withStr:@"%"]];
             //电压
             [weakSelf.tv5 setText:[self checkifunupdate:[NSString stringWithFormat:@"%@",[ret objectForKey:@"valt"]] withStr:@"V"]];
             [weakSelf.imgsigal setImage:[UIImage imageNamed:@"power.png"]];
         }else
         {
             isGSM=true;
             [weakSelf.tvlabel4 setText:[SwichLanguage getString:@"SatSigal"]];
             [weakSelf.tvlabel5 setText:[SwichLanguage getString:@"Energy"]];
             NSString* m2=[self checkifunupdate:[NSString stringWithFormat:@"%@",[ret objectForKey:@"power"]] withStr:@"%"];
             NSString* m1=[self checkifunupdate:[NSString stringWithFormat:@"%@",[ret objectForKey:@"valt"]] withStr:@"V"];
             [weakSelf.tv5 setText:[NSString stringWithFormat:@"%@ %@",m1,m2]];
             
//             NSString* gpsStar=[NSString stringWithFormat:@"%@",[ret objectForKey:@"gpsStar"]];
//             NSString* beidouStar=[NSString stringWithFormat:@"%@",[ret objectForKey:@"beidouStar"]];
//             NSString* gsmSignal=[NSString stringWithFormat:@"%@",[ret objectForKey:@"gsmSignal"]];
             [weakSelf.tv4 setText:[NSString stringWithFormat:@"%@/%@/%@",gsmSignal,gpsStar,beidouStar]];
             int mgsm= [gsmSignal intValue];
             if(mgsm>=24)//满信号
             {
                 [weakSelf.imgsigal setImage:[UIImage imageNamed:@"signal3.png"]];
             }else if(mgsm>=16)
             {
                 [weakSelf.imgsigal setImage:[UIImage imageNamed:@"signal2.png"]];
             }else if(mgsm>=8)
             {
                 [weakSelf.imgsigal setImage:[UIImage imageNamed:@"signal1.png"]];
             }else
             {
                 [weakSelf.imgsigal setImage:[UIImage imageNamed:@"signal0.png"]];
             }
         }
         
         //int mdevSts=0;
         NSString* pinstr=@"";
        
        [weakSelf.imgSts setImage:[weakSelf.dataModel getImageWithLogoType:self->mlogoType AndStatus:deviceSts]];
        
         if([deviceSts isEqualToString:@"1"]){
             [weakSelf.tvstatus setText:[SwichLanguage getString:@"offline"]];
             //[weakSelf.imgSts setImage:[UIImage imageNamed:@"offline_car.png"]];
             
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
             NSDate * stsTime =[dateFormatter dateFromString:msigtime];
             NSTimeInterval stsTimenSeconds = [[NSDate date] timeIntervalSinceDate:stsTime];
             NSString * timestr=[self.inAppSetting getTimeDurationWithtimeSpanInSeconds:stsTimenSeconds];
             pinstr=[NSString stringWithFormat:@"%@ %@",[SwichLanguage getString:@"offline"],timestr];
         }else if([deviceSts isEqualToString:@"2"])
         {
             [weakSelf.tvstatus setText:[SwichLanguage getString:@"expire"]];
             //[weakSelf.imgSts setImage:[UIImage imageNamed:@"offline_car.png"]];
             //mdevSts=3;
             pinstr=[SwichLanguage getString:@"expire"];
         }else if([deviceSts isEqualToString:@"3"])
         {
             [weakSelf.tvstatus setText:[SwichLanguage getString:@"driving"]];
             //[weakSelf.imgSts setImage:[UIImage imageNamed:@"online_car.png"]];
             
             pinstr=[NSString stringWithFormat:@"%@ %0.2fkm/h",[SwichLanguage getString:@"mspeed"],mspeed];
             //mdevSts=2;
         }else if([deviceSts isEqualToString:@"0"])
         {
             [weakSelf.tvstatus setText:[SwichLanguage getString:@"quiescent"]];
             //[weakSelf.imgSts setImage:[UIImage imageNamed:@"online_car.png"]];
             
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
             NSDate * stsTime =[dateFormatter dateFromString:mloctime];
             NSTimeInterval stsTimenSeconds = [[NSDate date] timeIntervalSinceDate:stsTime];
             NSString * timestr=[self.inAppSetting getTimeDurationWithtimeSpanInSeconds:stsTimenSeconds];
             pinstr=[NSString stringWithFormat:@"%@ %@",[SwichLanguage getString:@"quiescent"],timestr];
             //mdevSts=1;
         }else
         {//未知，默认过期
             [weakSelf.tvstatus setText:[SwichLanguage getString:@"expire"]];
             //[weakSelf.imgSts setImage:[UIImage imageNamed:@"offline_car.png"]];
             //mdevSts=3;
             pinstr=[SwichLanguage getString:@"expire"];
         }
        
        if (_deviceAnnotation == nil)
        {
            _deviceAnnotation = [[MKPointAnnotation alloc] init];
            [_mapView addAnnotation:_deviceAnnotation];
        }
         if (self->_deviceAnnotation!=nil) {
             self->_deviceAnnotation.title=pinstr;
         }
         
         //先清除之前的布防圈
         if (_circle!=nil) {
             [_mapView removeOverlay:_circle];
         }
         //更新布防圈
         _deviceDenfenseCoor = CLLocationCoordinate2DMake(dela, delo);
         
         if (isbufuang) {
             NSString* mradius=[ret objectForKey:@"radius"];
             int radius=[mradius intValue];
             if (radius>0) {
                 _circle = [MKCircle circleWithCenterCoordinate:_deviceDenfenseCoor
                                                                radius:radius];
                 [_mapView addOverlay:_circle];
             }
         }
        if (self->_carAnnotationView!=nil) {
            self->_carAnnotationView.image =[self getShowImage:self->mdevstatus AndCouse:self->mcouse AndLogoType:self->mlogoType];
        }
         //地图操作相关
         CLLocationCoordinate2D latestDeviceCoor = CLLocationCoordinate2DMake(ila,ilo);
         
//         BMKCircle *circle2 = [BMKCircle circleWithCenterCoordinate:_deviceDenfenseCoor radius:200];
//         [_mapView addOverlay:circle2];
         
         if(latestDeviceCoor.latitude==self->_deviceCoor.latitude&&latestDeviceCoor.longitude==self->_deviceCoor.longitude) {
             NSLog(@"相同位置，不刷新退出");
         }else
         {
             //改变图标位置
//             if (self->_deviceAnnotation!=nil) {
//                 [self->_mapView removeAnnotation:self->_deviceAnnotation];
//             }
             
             
             self->_deviceAnnotation.coordinate = latestDeviceCoor;
             //拉到中心点
             if(self->isCenter||self->isTrack)
             {
                 self->isCenter=false;
                 self->_mapView.centerCoordinate=latestDeviceCoor;
             }
             //绘画线条
             if (self->isTrack) {
                 if (self->_deviceCoor.latitude<1||self->_deviceCoor.longitude<1) {//不在中国内，去掉
                     NSLog(@"0 0点，不画线");
                 }else
                 {
                     if (!(self->_deviceCoor.longitude==ila&&self->_deviceCoor.longitude==ilo)) {
                         CLLocationCoordinate2D coords[2] = {0};
                         coords[0] = CLLocationCoordinate2DMake(self->_deviceCoor.latitude, self->_deviceCoor.longitude);
                         coords[1] = CLLocationCoordinate2DMake(ila, ilo);
                         MKPolyline *mpolyline = [MKPolyline polylineWithCoordinates:coords count:2];
                         [self->_mapView addOverlay:mpolyline];
                         [self->mlinelist addObject:mpolyline];
                     }
                 }
             }
             
             
             self->_deviceCoor=latestDeviceCoor;
             
             //反编译 具体 中文地址
             //[self setReverseGeoSearchWithCoor:latestDeviceCoor];
             
         }
     }
               failure:^(NSError *error)
     {
     }];
}
-(NSString*)checkifunupdate:(NSString*)mi withStr:(NSString*)fuhao
{
    if ([mi isEqualToString:@"-1"]) {
        return @"-1";
    }
    if ([mi isEqualToString:@"null"]) {
        return @"";
    }
    if (mi==nil) {
        return @"-1";
    }
    return [NSString stringWithFormat:@"%@%@",mi,fuhao];
}


- (void)setupMapView
{
    
    if(KIsiPhoneX)
    {
//        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0,
//                                                                IPXMargin,
//                                                                VIEWWIDTH,
//                                                                VIEWHEIGHT-NAVBARHEIGHT-IPXMargin)];
        _mapView= [[MKMapView alloc]initWithFrame:self.view.bounds];
    }else//低于iphonex的适配
    {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,
                                                                -120,
                                                                VIEWWIDTH,
                                                                VIEWHEIGHT+120)];
    }
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.mapType = MKMapTypeStandard;//标准地图
    _mapView.delegate = self;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01,0.01);
     [_mapView setRegion:MKCoordinateRegionMake(_deviceCoor, span) animated:NO];
    
    _mapView.rotateEnabled= NO;//禁用手势旋转
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
    //判断有没有点，需要预设中心点
}
- (IBAction)MapZoonInAction:(id)sender {
    MKCoordinateRegion region = _mapView.region;
    region.span.latitudeDelta = region.span.latitudeDelta * 0.5;
    region.span.longitudeDelta = region.span.longitudeDelta * 0.5;
    [_mapView setRegion:region animated:YES];
}

- (IBAction)MapZoonOutAction:(id)sender {
    MKCoordinateRegion region = _mapView.region;
    region.span.latitudeDelta = region.span.latitudeDelta * 2;
    region.span.longitudeDelta = region.span.longitudeDelta * 2;
    [_mapView setRegion:region animated:YES];
}

- (IBAction)SelectUpAction:(id)sender {
    [self clickUpOrDownLay:false];
}

- (IBAction)SelectDownAction:(id)sender {
    [self clickUpOrDownLay:true];
}


#pragma mark - BMKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    _carAnnotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:@"carAnnotationView"];
    if (_carAnnotationView == nil) {
        _carAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"carAnnotationView"];
        //_carAnnotationView.image =[self getShowImage:mdevstatus AndCouse:mcouse AndLogoType:mlogoType];
        //_carAnnotationView.image = [UIImage imageNamed:@"黄色-30.png"];
        _carAnnotationView.centerOffset = CGPointMake(0, 0);
    }
    _carAnnotationView.image =[self getShowImage:mdevstatus AndCouse:mcouse AndLogoType:mlogoType];
    //NSLog(@"viewForAnnotation");
    return _carAnnotationView;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineRenderer *polylineView = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        //设置polylineView的画笔颜色为蓝色
        polylineView.strokeColor = [[UIColor alloc] initWithRed:19/255.0 green:107/255.0 blue:251/255.0 alpha:1.0];
        //设置polylineView的画笔宽度为16
        polylineView.lineWidth = 4;
        //圆点虚线，V5.0.0新增
        //        polylineView.lineDashType = kBMKLineDashTypeDot;
        //方块虚线，V5.0.0新增
        //       polylineView.lineDashType = kBMKLineDashTypeSquare;
        return polylineView;
    }
    if ([overlay isKindOfClass:[MKCircle class]]){
        MKCircleRenderer* circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor colorWithHexString:@"5771bb"]colorWithAlphaComponent:0.3];
        circleView.strokeColor = [[UIColor colorWithHexString:@"5771bb"]colorWithAlphaComponent:1.0];
        circleView.lineWidth = 2.0;
        
        return circleView;
    }
    return nil;
}

- (void)setUpAnnotation
{
    if (_deviceAnnotation == nil)
    {
        _deviceAnnotation = [[MKPointAnnotation alloc] init];
        _deviceAnnotation.coordinate = _deviceCoor;
        [_mapView addAnnotation:_deviceAnnotation];
    }else
    {
        _deviceAnnotation.coordinate = _deviceCoor;
    }
}

//获取图标要显示的类型
-(UIImage*)getShowImage:(NSString*)mdevstatus AndCouse:(NSString*)mcouse AndLogoType:(NSString*)mlogoType
{
    //NSLog(@"getShowImage:mdevstatus=%@ mcouse=%@",mdevstatus,mcouse);
    int thecouse=0;//默认方向
    if (mcouse!=nil) {
        thecouse=[mcouse intValue];
    }
    UIImage *oldimgae=[self.dataModel getMapImageWithStatus:mdevstatus AndCouser:thecouse AndLogoType:mlogoType];
    //return [self scaleImages:oldimgae toScale:0.75];
    return [self.dataModel scaleImage:oldimgae width:0.3];
    //return [self.dataModel getMapImageWithStatus:mdevstatus AndCouser:thecouse AndLogoType:mlogoType];
}
//跟踪模式开启
-(void)TackOn{
    [self setZZButtonSelected:true];
    if (mlinelist==nil) {
        mlinelist=[NSMutableArray array];
    }else
    {
        [mlinelist removeAllObjects];
    }
    isTrack=true;
}
//跟踪模式关闭
-(void)TackOff{
    [self setZZButtonSelected:false];
    isTrack=false;
    if (mlinelist!=nil) {
        for (int i=0; i<mlinelist.count; i++) {
            MKPolyline* mline=[mlinelist objectAtIndex:i];
            [_mapView removeOverlay:mline];
        }
        [mlinelist removeAllObjects];
        mlinelist=nil;
    }
}

//地图页面点击了上下切换按钮 true是上 false是下
-(void)clickUpOrDownLay:(Boolean)b {
    // TODO Auto-generated method stub
    int listsize=(int)self.inAppSetting.user_itemList.count;
    [self TackOff];
    if(listsize<2)
    {
        [self.controlview1 setHidden:YES];
        return;
    }
    
    int mselectItem=self.inAppSetting.selectid;
    
    if(b)
    {
        if((mselectItem-1)<0)
        {
           self.inAppSetting.selectid=listsize-1;
        }else
        {
           self.inAppSetting.selectid=mselectItem-1;
        }
    }else
    {
        if((mselectItem+1)>listsize-1)
        {
            self.inAppSetting.selectid=0;
        }else
        {
            self.inAppSetting.selectid=mselectItem+1;
        }
    }
    [self goPage2AndUpdate];
    [self reStartNSTimer];
}

- (IBAction)clicktipbutton:(id)sender {
    if (isGSM) {
        [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"page2tipT"] withText:[SwichLanguage getString:@"page2tipC"]];
    }
    //NSLog(@"clicktipbutton");
}

@end
