//
//  AddFenceViewController.m
//  DM100
//
//  Created by 马真红 on 2021/10/11.
//  Copyright © 2021 aika. All rights reserved.
//

#import "AddFenceViewController.h"
#import "MapLoctionSwich.h"
@interface AddFenceViewController ()<MKMapViewDelegate,UITextFieldDelegate>
{
    UIButton *_liebiaoButton;
    Boolean NeedLoadView;//优化保证只加载界面刷新一次
    
    UIImageView *mPoint;//和地图独立的大头针
    int mRadius;
    
    int mfenceId;
    //中心点经纬度
    CGFloat mlat;
    CGFloat mlon;
    
    MKCircle * _circle;
    
    NSString *_imei;
    NSString *_imeiname;
    Boolean isAdd;
    
    MBProgressHUD * _HUD;
    NSString *_strfencename;
    
    UIView *bgview;
}
@end

@implementation AddFenceViewController


-(id)initWithImei:(NSString *)mimei andImeiName:(NSString *)mImeiName andIsAdd:(Boolean)madd
{
    self = [super init];
    if (self)
    {
        _imei=mimei;
        _imeiname=mImeiName;
        mRadius=200;
        isAdd=madd;
    }
    return self;
}


-(void)setDataValueByFenceClss:(FenceClass*)mFenceClass
{
    mfenceId=mFenceClass.fenceId;
    mRadius=mFenceClass.radius;
    self.namefield.text=mFenceClass.fenceName;
    _strfencename=mFenceClass.fenceName;
    
    CLLocationCoordinate2D newpoi=[MapLoctionSwich wgs84ToGcj02:mFenceClass.latitude bdLon:mFenceClass.longitude];
    mlat=newpoi.latitude;
    mlon=newpoi.longitude;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
    NeedLoadView=true;

}

- (void)setupView
{
    _liebiaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_liebiaoButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_liebiaoButton setTitle:[SwichLanguage getString:@"delete"] forState:UIControlStateNormal];
    [_liebiaoButton sizeToFit];
    [_liebiaoButton setFrame:CGRectMake(10,
                                        IOS7DELTA+IPXMargin,
                                        CGRectGetWidth(_liebiaoButton.frame),
                                        44)];
    [_liebiaoButton addTarget:self action:@selector(click_righttop_button) forControlEvents:UIControlEventTouchUpInside];
    if(isAdd)
    {
        [self.submitbutton setTitle:[SwichLanguage getString:@"submit"] forState:UIControlStateNormal];
        [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"addfence"] withRightButton:_liebiaoButton];
    }else
    {
        [self.submitbutton setTitle:[SwichLanguage getString:@"modify"] forState:UIControlStateNormal];
        [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"modifyfence"] withRightButton:_liebiaoButton];
    }
    self.namefield.placeholder=[SwichLanguage getString:@"name"];
    
    //添加通知，来控制键盘和输入框的位置

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];//键盘的弹出

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];//键盘的消失
    
    
}
-(void)click_righttop_button
{
    _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    NSDictionary *bodyData =@{@"updateUser":self.inAppSetting.loginNo,
                              @"deviceImei":_imei,
                              @"fenceId":[NSString stringWithFormat:@"%d",mfenceId],
                              @"isAll":@"1"
                                };
     NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:131
                                                         withParameters:bodyData];
     [NetWorkModel POST:ServerURL
             parameters:parameters
                success:^(ResponseObject *messageCenterObject)
      {
         [self->_HUD hide:YES];
          NSDictionary *ret = messageCenterObject.ret;
          NSLog(@"send131CMD ret=%@",ret);
          int mretcode=[[ret objectForKey:@"stsCode" ] intValue];
          if (mretcode==1) {
              [MBProgressHUD showLogTipWIthTitle:nil withText:[SwichLanguage getString:@"deletefenceok"]];
              [self closeView];
          }else
          {
            [MBProgressHUD showLogTipWIthTitle:nil withText:[SwichLanguage getString:@"deletefencefail"]];
        }
      }
                failure:^(NSError *error)
      {
         [self->_HUD hide:YES];
         [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"tips"] withText:[SwichLanguage getString:@"deletefencefail"]];
      }];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (NeedLoadView) {
        //第一次打开界面的刷新
        [self autoFitView];
        if (isAdd) {
            [_liebiaoButton setHidden:YES];
            [self getCarLocation];
        }else
        {
            self.mslider.value=mRadius;
            self.namefield.text=_strfencename;
        }
        NeedLoadView=false;
    }
}

-(void)autoFitView
{
    if(KIsiPhoneX)
    {
        CGRect newfame=CGRectMake(0, VIEWHEIGHT-IPXLiuHai-self.bomttomview.frame.size.height, VIEWWIDTH, self.bomttomview.frame.size.height);
        [self.bomttomview setFrame:newfame];
        NSLog(@"autoFitView");
    }
    
    [self setupMapView];
    [self setupPointImageView];
    
    float mapOY=KIsiPhoneX?(64+IPXMargin):64;
    CGRect newslifame=CGRectMake(10,mapOY+20, VIEWWIDTH-20, self.mslider.frame.size.height);
    [self.mslider setFrame:newslifame];
    [self.view bringSubviewToFront:self.mslider];
    
    CGRect newlabelfame=CGRectMake(10,newslifame.origin.y+newslifame.size.height+20, VIEWWIDTH-20, 40);
    [self.mimageview setFrame:newlabelfame];
    [self.mlabel setFrame:newlabelfame];
    [self.view bringSubviewToFront:self.mimageview];
    [self.view bringSubviewToFront:self.mlabel];
    
    [self setShowRadiusView:mRadius];
    
    CGRect mr=self.namefield.frame;
    mr.size.width=self.submitbutton.frame.origin.x-mr.origin.x-8;
    [self.namefield setFrame:mr];
    
    [self initBGview];
}

-(void)setupMapView
{
    float mapOY=KIsiPhoneX?(64+IPXMargin):64;
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,mapOY, VIEWWIDTH, self.bomttomview.frame.origin.y-mapOY)];
    
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    //设置标准地图
    _mapView.mapType = MKMapTypeStandard;
    // 不显示罗盘和比例尺
    if (@available(iOS 9.0, *)) {
       _mapView.showsCompass = YES;
       //_mapView.showsScale = YES;
     }
    
    _mapView.showsScale = YES;
    
     // 开启定位
     _mapView.showsUserLocation = YES;
     _mapView.delegate = self;
     //初始位置及显示范围
    if (isAdd) {
    mlat= 23.043;
    mlon=113.411;
    }
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01,0.01);
        CLLocationCoordinate2D startLocation=CLLocationCoordinate2DMake( mlat,mlon);
         [_mapView setRegion:MKCoordinateRegionMake(startLocation, span) animated:YES];
    

    [self.view addSubview:_mapView];
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
      
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
      
    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
//    mlat=touchMapCoordinate.latitude;
//    mlon=touchMapCoordinate.longitude;

}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

   MKCoordinateRegion region;
   CLLocationCoordinate2D centerCoordinate = mapView.region.center;
   region.center= centerCoordinate;

   NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
//    if (latLabel!=nil) {
//        latLabel.text=[NSString stringWithFormat:@"Latitude:%f",centerCoordinate.latitude];
//    }
//   if (logLabel!=nil) {
//       logLabel.text=[NSString stringWithFormat:@"Longitude:%f",centerCoordinate.longitude];
//   }
   mlat=centerCoordinate.latitude;
   mlon=centerCoordinate.longitude;
   [self drawCircle:mRadius];
}
-(void)setupPointImageView
{
    float mPointW=VIEWWIDTH*2/3;
    float mPointOY=_mapView.frame.origin.y+_mapView.frame.size.height/2-mPointW/2;
    mPoint=[[UIImageView alloc]initWithFrame:CGRectMake(VIEWWIDTH/2-mPointW/2,mPointOY, mPointW, mPointW)];
    mPoint.image= [UIImage imageNamed:@"centerPoit2"];
    [self.view addSubview:mPoint];
}

-(void)setShowRadiusView:(int)mr
{
    self.mlabel.text=[NSString stringWithFormat:@"%@ %d (M)",[SwichLanguage getString:@"radius"],mr];
}
- (IBAction)clickBtnSubmit:(id)sender {
    if (self.namefield.text.length>0) {
        if (isAdd) {
            [self addNewFence];
        }else
        {
            [self modifyFence];
        }
    }else
    {
        [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"fenceerror1"] withText:nil];
    }
}

- (IBAction)sliderchangeAction:(UISlider *)slider{
    
    [slider setValue:((int)((slider.value + 50) / 100) * 100) animated:NO];
    if (mRadius!=self.mslider.value) {
        mRadius=self.mslider.value;
        [self setShowRadiusView:mRadius];
        [self drawCircle:mRadius];
        NSLog(@"setShowRadiusView");
    }
}

-(void)drawCircle:(int)mtRadius
{
    //先清除之前的布防圈
    if (_circle!=nil) {
        [_mapView removeOverlay:_circle];
    }
    //更新布防圈
    CLLocationCoordinate2D _deviceDenfenseCoor = CLLocationCoordinate2DMake(mlat, mlon);

    _circle = [MKCircle circleWithCenterCoordinate:_deviceDenfenseCoor
                                                           radius:mtRadius];
    [_mapView addOverlay:_circle];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKCircle class]]){
        MKCircleRenderer* circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor colorWithHexString:@"5771bb"]colorWithAlphaComponent:0.3];
        circleView.strokeColor = [[UIColor colorWithHexString:@"5771bb"]colorWithAlphaComponent:1.0];
        circleView.lineWidth = 2.0;
        
        return circleView;
    }
    return nil;
}

-(void)getCarLocation
{
    
            NSDictionary *bodyData = @{@"imei":_imei,
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
                    CLLocationCoordinate2D mlalo=[MapLoctionSwich bd09togcj02:[lo floatValue] and:[la floatValue]];
                self->mlat=mlalo.latitude;
                self->mlon=mlalo.longitude;
                 
                self->_mapView.centerCoordinate=mlalo;
             }failure:^(NSError *error)
             {
             }];
}

-(void)addNewFence
{
    NSArray *latlon=[MapLoctionSwich gcjToWGS:mlat and:mlon];
    _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    NSDictionary *bodyData =@{@"updateUser":self.inAppSetting.loginNo,
                              @"deviceImei":_imei,
                              @"latitude":[NSString stringWithFormat:@"%@",latlon.firstObject],
                              @"longitude":[NSString stringWithFormat:@"%@",latlon.lastObject],
                              @"radius":[NSString stringWithFormat:@"%d",mRadius],
                              @"isLeaveAlarm":@"1",
                              @"isEnterAlarm":@"1",
                              @"fenceName":self.namefield.text
                                };
     NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:130
                                                         withParameters:bodyData];
     [NetWorkModel POST:ServerURL
             parameters:parameters
                success:^(ResponseObject *messageCenterObject)
      {
         [self->_HUD hide:YES];
          NSDictionary *ret = messageCenterObject.ret;
          NSLog(@"send121CMD ret=%@",ret);
          int mretcode=[[ret objectForKey:@"stsCode" ] intValue];
          if (mretcode==1) {
              [MBProgressHUD showLogTipWIthTitle:nil withText:[SwichLanguage getString:@"fenceaddok"]];
              [self closeView];
          }else
          {
              NSString* msgstr=(NSString *)[messageCenterObject.ret objectForKey:@"stsMsg"];
              if (msgstr.length==0) {
                  [MBProgressHUD showLogTipWIthTitle:nil withText:[SwichLanguage getString:@"fenceaddfail"]];
              }else
              {
                  [MBProgressHUD showLogTipWIthTitle:nil withText:msgstr];
              }
          }
      }
                failure:^(NSError *error)
      {
         [self->_HUD hide:YES];
         [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"tips"] withText:[SwichLanguage getString:@"fenceaddfail"]];
      }];
}

-(void)modifyFence
{
    NSArray *latlon=[MapLoctionSwich gcjToWGS:mlat and:mlon];
    _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    NSDictionary *bodyData =@{@"updateUser":self.inAppSetting.loginNo,
                              @"deviceImei":_imei,
                              @"latitude":[NSString stringWithFormat:@"%@",latlon.firstObject],
                              @"longitude":[NSString stringWithFormat:@"%@",latlon.lastObject],
                              @"radius":[NSString stringWithFormat:@"%d",mRadius],
                              @"isLeaveAlarm":@"1",
                              @"isEnterAlarm":@"1",
                              @"fenceId":[NSString stringWithFormat:@"%d",mfenceId],
                              @"fenceName":self.namefield.text
                                };
     NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:132
                                                         withParameters:bodyData];
     [NetWorkModel POST:ServerURL
             parameters:parameters
                success:^(ResponseObject *messageCenterObject)
      {
         [self->_HUD hide:YES];
          NSDictionary *ret = messageCenterObject.ret;
          NSLog(@"send132CMD ret=%@",ret);
          int mretcode=[[ret objectForKey:@"stsCode" ] intValue];
          if (mretcode==1) {
              [MBProgressHUD showLogTipWIthTitle:nil withText:[SwichLanguage getString:@"modifyfenceok"]];
              [self closeView];
          }else
          {
              NSString* msgstr=(NSString *)[messageCenterObject.ret objectForKey:@"stsMsg"];
              if (msgstr.length==0) {
                  [MBProgressHUD showLogTipWIthTitle:nil withText:[SwichLanguage getString:@"modifyfencefail"]];
              }else
              {
                  [MBProgressHUD showLogTipWIthTitle:nil withText:msgstr];
              }
          }
      }
                failure:^(NSError *error)
      {
         [self->_HUD hide:YES];
         [MBProgressHUD showLogTipWIthTitle:[SwichLanguage getString:@"tips"] withText:[SwichLanguage getString:@"modifyfencefail"]];
      }];
}
-(void)closeView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----- 键盘显示的时候的处理

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    [bgview setHidden:NO];
    //获得键盘的大小

    NSDictionary* info = [aNotification userInfo];

    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    

    [UIView beginAnimations:nil context:nil];

    [UIView setAnimationDuration:0.25];

    [UIView setAnimationCurve:7];

    self.view.frame = CGRectMake(0,-kbSize.height , self.view.frame.size.width, self.view.frame.size.height);

    [UIView commitAnimations];
}


#pragma mark -----    键盘消失的时候的处理

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [bgview setHidden:YES];
    [UIView beginAnimations:nil context:nil];

    [UIView setAnimationDuration:0.25];

    [UIView setAnimationCurve:7];

    self.view.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);

    [UIView commitAnimations];
}
-(void)dealloc

{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

//初始化弹出键盘时候的灰色界面
-(void)initBGview
{
    bgview=[[UIView alloc]initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgview.backgroundColor=[UIColor clearColor];
    [self.view addSubview:bgview];
    [self.view bringSubviewToFront:bgview];
    [bgview setHidden:YES];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(done:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [bgview addGestureRecognizer:tapGestureRecognizer];
}

- (void)done:(id)sender
{
     [self.namefield resignFirstResponder];
}
@end
