//
//  HistoryTrackViewController.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/16.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "HistoryTrackViewController.h"
#import "HistoryTrackService.h"
#import "TrackPlayerView.h"
#import "CustomPointAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationView.h"
#import <math.h>
#import "UIImage+Rotate.h"
#import "StartAndEndAnNotation.h"
#import "HistoryCell.h"
#import "HistoryScrollCell.h"
#define miniScale 0.5
@interface HistoryTrackViewController ()<BMKMapViewDelegate, TrackPlayerViewDelegate,UIGestureRecognizerDelegate>
{
    //NSArray *_historyLocations;
    CLLocationCoordinate2D *_hitoryCoors;
    NSInteger _coorCounter;
    
    NSString *_imei;
    NSString *_mstartstr;//是否有默认开始时间
    NSString *_mendstr;//是否有默认结束
    
    TrackPlayerView *_trackPlayerView;
    
    BMKMapView *_mapView;
    BMKPointAnnotation *_carAnnotation;
    BMKAnnotationView *_currentAnnotationView;
    
    //静止点判断相关
    CalloutMapAnnotation *_calloutMapAnnotation;
    
    float stoppoitla;//静止点坐标
    float stoppoitlo;
    NSString *startimestr;
    NSString *endtimestr;
    
    NSTimeInterval allstoptime;
    float _sumOfDistance;

    BOOL isGuoluJZ;//是否过滤基站数据
    
    UIButton *_liebiaoButton;
    float selectid;
    
    float tableViewH;
    UIView *btview;
    UIImageView* mbtig;
    float morigeBtY;//初使切换按钮的Y位置
    
    CGRect centerRect;//百度地图边界，用于提前加载
    
    BMKPolyline *polyLine;//记录线的位置
    UIImage *myLocationImage;
}
@property (nonatomic, strong) NSArray *historyLocations;
@property (nonatomic, strong) HistoryScrollCell *aroundCell;
@property (nonatomic,assign) float cellLastX; //最后的cell的移动距离
@property(nonatomic,strong)NSArray *topArr;
@property (nonatomic, strong) UIScrollView *topScrollView;
@end

@implementation HistoryTrackViewController

- (id)initWithImei:(NSString *)imei Withlalo:(CLLocationCoordinate2D)Coor
{
    self = [super init];
    if (self)
    {
        _imei = imei;
        _mstartstr=@"";
        _mendstr=@"";
        _sumOfDistance=-1;
        allstoptime=0;
        stoppoitla=0;
        stoppoitlo=0;
        [self setupView];
        [self setupMapView];
        [self addTrackPlayerView];
        [self tableViewSetting];
        [_mapView setCenterCoordinate:Coor animated:NO];
        [_mapView setZoomLevel:18.0f];
        isGuoluJZ=YES;
        
        centerRect = CGRectMake(CGRectGetWidth(_mapView.frame)/8,
                                        _mapView.frame.origin.y+CGRectGetHeight(_mapView.frame)/8,
                                        CGRectGetWidth(_mapView.frame)*3/4,
                                        CGRectGetHeight(_mapView.frame)-(VIEWHEIGHT-morigeBtY)-CGRectGetHeight(_mapView.frame)/4);
    }
    return self;
}

- (id)initWithImei:(NSString *)imei Withlalo:(CLLocationCoordinate2D)Coor WithStart:(NSString *)mstartstr WithEnd:(NSString *)mendstr
{
    self = [super init];
    if (self)
    {
        _imei = imei;
        _mstartstr=mstartstr;
        _mendstr=mendstr;
        _sumOfDistance=-1;
        allstoptime=0;
        stoppoitla=0;
        stoppoitlo=0;
        [self setupView];
        [self setupMapView];
        [self addTrackPlayerView];
        [self tableViewSetting];
        [_mapView setCenterCoordinate:Coor animated:NO];
        [_mapView setZoomLevel:18.0f];
        isGuoluJZ=YES;
    }
    return self;
}

- (void)setupView
{
    _liebiaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_liebiaoButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_liebiaoButton setTitle:[SwichLanguage getString:@"satellite"] forState:UIControlStateNormal];
    [_liebiaoButton sizeToFit];
    [_liebiaoButton setFrame:CGRectMake(10,
                                        IOS7DELTA+IPXMargin,
                                        CGRectGetWidth(_liebiaoButton.frame),
                                        44)];
    [_liebiaoButton addTarget:self action:@selector(click_righttop_button) forControlEvents:UIControlEventTouchUpInside];
    [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"p2tv2"] withRightButton:_liebiaoButton];
    
}

- (void)addTrackPlayerView
{
//    float playerviewheight;
//    if (KIsiPhoneX)
//    {
//        playerviewheight=NAVBARHEIGHT+3;
//    }else
//    {
//        playerviewheight=NAVBARHEIGHT+12;
//    }
//
//    _trackPlayerView = [[TrackPlayerView alloc] initWithFrame:CGRectMake(0,
//                                                                         playerviewheight,
//                                                                         VIEWWIDTH,
//                                                                         77)];
    _trackPlayerView = [[TrackPlayerView alloc] initWithFrame:CGRectMake(0,
                                                                         self.view.frame.size.height-75-IPXMargin,
                                                                         VIEWWIDTH,
                                                                         75+IPXMargin)];
    NSLog(@"_trackPlayerView=%f||VIEWWIDTH=%f",_trackPlayerView.frame.size.width,VIEWWIDTH);
    _trackPlayerView.delegate = self;
  //  _trackPlayerView.imeiLabel.text = _imei;
    [self.view addSubview:_trackPlayerView];
    [self.view addSubview:_trackPlayerView.selectionView];
    [self setupListButton];
}

- (void)setupMapView
{
    CGRect mapViewFrame = CGRectMake(0,
                                     NAVBARHEIGHT+IPXMargin,
                                     VIEWWIDTH,
                                     VIEWHEIGHT-NAVBARHEIGHT-IPXMargin);
    _mapView = [[BMKMapView alloc] initWithFrame:mapViewFrame];
    _mapView.rotateEnabled= NO;
    _mapView.overlookEnabled = NO;
    [self.view addSubview:_mapView];
    
}
/**
 百度地图拖动手势
 
 @param gesture 手势
 */
- (void)mapPanGesture:(UIGestureRecognizer *)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        [self checkIsPlaying];
    }
}

/**
 百度地图缩放手势
 
 @param gesture 手势
 */
- (void)mapPinchGesture:(UIGestureRecognizer *)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        [self checkIsPlaying];
    }
}

/**
当轨迹播放过程中，就检测到手势就停止播放
*/
-(void)checkIsPlaying
{
    if (_trackPlayerView.playPauseButton.selected==YES) {
         [_trackPlayerView.playPauseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_mstartstr.length<4||_mendstr.length<4) {
        [_trackPlayerView.timeRangeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        //NSLog(@"没有自动加载开始结束时间");
    }else
    {
        NSLog(@"自动加载开始结束时间 _mstartstr=%@  _mendstr=%@",_mstartstr,_mendstr);
        [self timeRangeDidSelectedWithStartTime:_mstartstr withEndTime:_mendstr withSpe:@"0"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapAnnotationSetter
- (void)setTrackArray:(NSArray *)array
{
    self.historyLocations = [NSArray arrayWithArray:array];
    selectid=0;
    int historyCount = (int)array.count;
    CLLocationCoordinate2D coors[historyCount];
    for (int i = 0; i < historyCount; i++)
    {
        HistoryLocationObject *object = array[i];
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([object.la floatValue], [object.lo floatValue]);
        coors[i] = coor;
        
        _coorCounter = i + 1;
    }
    _hitoryCoors = coors;
    
    [self updateMapTrack];
    [self setCarAnnotation:_hitoryCoors[0]];
}

- (void)updateMapTrack
{
    // 清除所有标志和路线
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    _carAnnotation = nil;
    _currentAnnotationView=nil;
    polyLine=nil;
//    BMKPolyline *polyLine = [BMKPolyline polylineWithCoordinates:_hitoryCoors
//                                                           count:_coorCounter];
//    [_mapView addOverlay:polyLine];
    
    BMKCoordinateRegion region;
    region.center = _hitoryCoors[0];
    region.span.longitudeDelta = 0.01;
    region.span.latitudeDelta = 0.01;
    
    BMKCoordinateRegion adjustRegion = [_mapView regionThatFits:region];
    [_mapView setRegion:adjustRegion animated:NO];
    [_mapView setZoomLevel:18.0f];
    
    stoppoitla=0;
    stoppoitlo=0;
    _sumOfDistance=-1;
    allstoptime=0;
    startimestr=nil;
    endtimestr=nil;
}

- (void)setCarAnnotation:(CLLocationCoordinate2D)coor
{
    if (_carAnnotation == nil)
    {
        _carAnnotation = [[BMKPointAnnotation alloc]init];
        [_mapView addAnnotation:_carAnnotation];
    }
    _carAnnotation.coordinate = coor;
    //[_mapView addAnnotation:_carAnnotation];
    
//    CGRect centerRect = CGRectMake(CGRectGetWidth(_mapView.frame)/4,
//                                   CGRectGetHeight(_mapView.frame)/4,
//                                   CGRectGetWidth(_mapView.frame)/2,
//                                   CGRectGetHeight(_mapView.frame)/2);
    CGPoint coorPoint = [_mapView convertCoordinate:coor toPointToView:_mapView];
    
    if (!CGRectContainsPoint(centerRect, coorPoint))
    {
        [_mapView setCenterCoordinate:coor animated:YES];
    }

}


#pragma mark - MapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CustomPointAnnotation class]]) {
        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"stopAnnotationView"];
        if (annotationView == nil)
        {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"stopAnnotationView"];
            annotationView.image = [self getMapPointImageFitSize:@"stop_bar.png"];
            annotationView.centerOffset = CGPointMake(0,-8);
            annotationView.canShowCallout=NO;
        }
        return annotationView;
    }else if ([annotation isKindOfClass:[CalloutMapAnnotation class]]){
        
        //此时annotation就是我们calloutview的annotation
        CalloutMapAnnotation *ann = (CalloutMapAnnotation*)annotation;
        
        //如果可以重用
        CallOutAnnotationView *calloutannotationview = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
        
        //否则创建新的calloutView
        if (!calloutannotationview) {
            calloutannotationview = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"calloutview"];
            
            BusPointCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BusPointCell" owner:self options:nil] objectAtIndex:0];
            cell.label1.adjustsFontSizeToFitWidth=YES;
            cell.label2.adjustsFontSizeToFitWidth=YES;
            [cell.label1 setText:[SwichLanguage getString:@"his1"]];
            [cell.label2 setText:[SwichLanguage getString:@"his2"]];
            [calloutannotationview.contentView addSubview:cell];
            calloutannotationview.busInfoView = cell;
        }
        
        //开始设置添加marker时的赋值
        calloutannotationview.busInfoView.starttime.text = [ann.locationInfo objectForKey:@"starttime"];
        calloutannotationview.busInfoView.endtime.text = [ann.locationInfo objectForKey:@"endtime"];
        calloutannotationview.busInfoView.stoptime.text =[ann.locationInfo objectForKey:@"stoptime"];
        
        return calloutannotationview;
        
        
        
    }else if ([annotation isKindOfClass:[StartAndEndAnNotation class]]) {
        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"StartAndEndAnNotation"];
        if (annotationView == nil)
        {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"StartAndEndAnNotation"];
            annotationView.centerOffset = CGPointMake(0,-14);
            annotationView.canShowCallout=NO;
        }
        annotationView.image = [self getimagebytype:annotation];
        return annotationView;
    }
    
    else if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        if (_currentAnnotationView==nil) {
            _currentAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
            //_currentAnnotationView.image =[self getShowImage:@"0" AndCouse:0 AndLogoType:@"0"];
            _currentAnnotationView.centerOffset = CGPointMake(0, 0);
            
            _currentAnnotationView.image = [UIImage imageNamed:@"蓝色-90.png"];//带箭头方向的图片
            myLocationImage= [UIImage imageNamed:@"蓝色-90.png"];//带箭头方向的图片
            //_currentAnnotationView.centerOffset = CGPointMake(0, _currentAnnotationView.frame.size.height/2);
        }
        return _currentAnnotationView;
    }
    return nil;
}

-(UIImage*)getimagebytype:(StartAndEndAnNotation*)annotation
{
    //0为起点，1是终点
    UIImage* mimage;
    if (annotation.type==0) {
        mimage=  [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
        //mimage=[UIImage imageNamed:@"stop_bar.png"];
    }else
    {
        mimage=  [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
    }
    if(KIsiPhoneX)
    {
        return  [self.dataModel scaleImage:mimage width:3];
    }else
    {
        return mimage;
    }
}


- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"traffic_texture_smooth"]];
        //polylineView.strokeColor = [UIColor colorWithHexString:@"#00ff00"];
        polylineView.lineJoinType=kBMKLineJoinRound;
        polylineView.lineCapType=kBMKLineCapRound;
        polylineView.lineWidth = 6.5f;//3.0;
        
        return polylineView;
    }
    return nil;
}

#pragma mark - TrackPlayerViewDelegate
- (void)sliderValueDidChangeToStep:(NSInteger)step
                      withDuration:(CGFloat)duration
{
    NSLog(@"log1=%ld",(long)step);
    if(!self.messageCenterTableView.hidden)
    {
        [self clickShowTableListButton];
    }
    HistoryLocationObject *object = [self.historyLocations objectAtIndex:step];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([object.la floatValue], [object.lo floatValue]);
    
    _trackPlayerView.timeLabel.text = object.stsTime;
    _trackPlayerView.imeiLabel.text = [NSString stringWithFormat:@"%@ km/h",object.speed];
    NSLog(@"log2=%ld",(long)step);
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^
    {
        [self setCarAnnotation:coor];
        if(self->_currentAnnotationView!=nil)
        {
            //_currentAnnotationView.image=[self getShowImage:@"0" AndCouse:object.course AndLogoType:@"0"];
            self->_currentAnnotationView.image=[self.dataModel imageRotatedByDegrees:object.course andImage:self->myLocationImage];
        }
                     }
                     completion:^(BOOL finished)
    {
        ;
    }];
    if (step==self.historyLocations.count-1) {
        NSLog(@"到达最后一个点");
        //[self showAlltimeAndDistance];
    }
    
    int alow=(int)self.historyLocations.count;
    CLLocationCoordinate2D coorsttt[alow];
    for (int i = 0; i < alow; i++)
    {
        HistoryLocationObject *objectst = [self.historyLocations objectAtIndex:i];
        CLLocationCoordinate2D coorone = CLLocationCoordinate2DMake([objectst.la floatValue], [objectst.lo floatValue]);
        coorsttt[i] = coorone;
    }
    //NSLog(@"logC=%ld",(long)step);
    if (polyLine) {
        //NSLog(@"logC1=%ld",(long)step);
        [polyLine setPolylineWithCoordinates:coorsttt count:step+1];
        //NSLog(@"logC2=%ld",(long)step);
        return;
    }
    //NSLog(@"logD=%ld",(long)step);
    //NSLog(@"进入一次");
    polyLine = [BMKPolyline polylineWithCoordinates:coorsttt count:step+1];
    [_mapView addOverlay:polyLine];
}

- (void)timeRangeDidSelectedWithStartTime:(NSString *)startTime
                              withEndTime:(NSString *)endTime
                               withSpe:(NSString *)spe
{
    //NSLog(@"spe=%@",spe);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HistoryTrackService getHistoryTrackWithImei:_imei
                                   withStartTime:startTime
                                     withEndTime:endTime
                                      withSpe:spe
                                       withJZStatus:isGuoluJZ
                                         success:^(NSArray *array)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
        
        if (array.count != 0)
        {
        
            // 用协议返回的array建立轨迹
            [self setTrackArray:array];
            // 轨迹移动的代码
            [_trackPlayerView setTotalSteps:array.count];
            // 自动开始啦
            [_trackPlayerView.playPauseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            //停留点判断，总停留时间判断，总里程判断
            //[self count_the_stop_poit_and_licheng:array];
            [self filtTrack_parseStatic:array];
            
            //标记起点
            HistoryLocationObject *startlocation=[array objectAtIndex:0];
            StartAndEndAnNotation *_userLocation = [[StartAndEndAnNotation alloc] init];
            _userLocation.type = 0;
            _userLocation.coordinate =CLLocationCoordinate2DMake([startlocation.la floatValue], [startlocation.lo floatValue]);
            [_mapView addAnnotation:_userLocation];
            
            //标记终点
            HistoryLocationObject *endlocation=[array objectAtIndex:array.count-1];
            StartAndEndAnNotation *_userLocation1 = [[StartAndEndAnNotation alloc] init];
            _userLocation1.type = 1;
            _userLocation1.coordinate =CLLocationCoordinate2DMake([endlocation.la floatValue], [endlocation.lo floatValue]);
            [_mapView addAnnotation:_userLocation1];
            
            [self getmileagewithStartTime:startTime withEndTime:endTime];
        }
        else
        {
            [MBProgressHUD showQuickTipWithText:[SwichLanguage getString:@"errorA109X"]];
        }
    }
                                         failure:^(NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showQuickTipWithText:[SwichLanguage getString:@"errorA100X"]];
    }];
    
}

//调用57协议获取里程
-(void)getmileagewithStartTime:(NSString *)startTime
                   withEndTime:(NSString *)endTime
{
    _sumOfDistance=-1;
    NSDictionary *bodyData = @{@"loginNo":_imei,
                               @"starttime":startTime,
                               @"endtime":endTime};
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:57
                                                        withParameters:bodyData];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *messageCenterObject)
     {
         NSLog(@"%@",messageCenterObject.ret);
         NSDictionary *ret = messageCenterObject.ret;
         
         NSString* _ret=(NSString *)[ret objectForKey:@"ret"];
         
         if ([_ret isEqualToString:@"1"]) {
             NSString* mileage=(NSString *)[ret objectForKey:@"mileage"];
             self->_sumOfDistance=[mileage floatValue];
         }
     }
               failure:^(NSError *error)
     {
     }];

}

#pragma mark - didDeselectAnnotationView
-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    if (_calloutMapAnnotation&&![view isKindOfClass:[CallOutAnnotationView class]]) {
        
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation = nil;
        }
    }
}

#pragma mark - didSelectAnnotationView
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    //CustomPointAnnotation 是自定义的marker标注点，通过这个来得到添加marker时设置的pointCalloutInfo属性
    CustomPointAnnotation *annn = (CustomPointAnnotation*)view.annotation;
    
    
    if ([view.annotation isKindOfClass:[CustomPointAnnotation class]]) {
        
        //如果点到了这个marker点，什么也不做
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        //如果当前显示着calloutview，又触发了select方法，删除这个calloutview annotation
        if (_calloutMapAnnotation) {
            [mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation=nil;
            
        }
        //创建搭载自定义calloutview的annotation
        _calloutMapAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude];
        //把通过marker(ZNBCPointAnnotation)设置的pointCalloutInfo信息赋值给CalloutMapAnnotation
        _calloutMapAnnotation.locationInfo = annn.pointCalloutInfo;
        [mapView addAnnotation:_calloutMapAnnotation];
        [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
        
    }
}

- (NSString *)getTimeDurationWithBeginTime:(NSString *)beginDateStr EndTime:(NSString *)endDateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *beginDate = [dateFormatter dateFromString:beginDateStr];
    NSDate * nowDate =[dateFormatter dateFromString:endDateStr];
    NSTimeInterval timeSpanInSeconds = [nowDate timeIntervalSinceDate:beginDate];
    allstoptime+=timeSpanInSeconds;
    return [self get_the_stop_time_str:timeSpanInSeconds];
    
    return @"";
}


-(NSString*)get_the_stop_time_str:(NSTimeInterval)timeSpanInSeconds
{
    NSString* mtime=[self.inAppSetting getTimeDurationWithtimeSpanInSeconds:timeSpanInSeconds];
    return [NSString stringWithFormat:@"%@%@",[SwichLanguage getString:@""],mtime];
}

//停留点判断，总停留时间判断，总里程判断
-(void)count_the_stop_poit_and_licheng:(NSArray*) historypointlist
{
    for (int i=0; i<historypointlist.count; i++) {
        HistoryLocationObject *object = [self.historyLocations objectAtIndex:i];
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([object.la floatValue], [object.lo floatValue]);
        
        
        //统计里程
//        if (i>0) {
//            HistoryLocationObject *object1 = [_historyLocations objectAtIndex:i-1];
//            CLLocationCoordinate2D coor_before = CLLocationCoordinate2DMake([object1.la floatValue], [object1.lo floatValue]);
//            BMKMapPoint beforePoint = BMKMapPointForCoordinate(coor_before);
//            BMKMapPoint currentPoint = BMKMapPointForCoordinate(coor);
//            CLLocationDistance distance = BMKMetersBetweenMapPoints(beforePoint,currentPoint);
//             NSNumber * _distance = [NSNumber numberWithDouble:distance];
//            _sumOfDistance += [_distance floatValue];
//            //        float dis= [_distance floatValue];
//            //        NSLog(@"两点距离：%f",dis);
//        }
        
        //NSLog(@"[object.deviceSts=%@",object.deviceSts);
        //开始判断是否有静止点逻辑
        if ([object.deviceSts isEqualToString:@"0"]) {
            //更新静止点数据
            if (stoppoitla==0) {
                //之前不存在静止点,添加
                stoppoitla=coor.latitude;
                stoppoitlo=coor.longitude;
                startimestr=object.stsTime;
               // endtimestr=object.stsTime;
            }else{
                endtimestr=object.stsTime;
            }
        }else{
            if([object.speed intValue]<5){
                //更新静止点数据
                if (stoppoitla==0) {
                    //之前不存在静止点,添加
                    stoppoitla=coor.latitude;
                    stoppoitlo=coor.longitude;
                    startimestr=object.stsTime;
               //     endtimestr=object.stsTime;
                }else{
                    endtimestr=object.stsTime;
                }
            }else{
                if (stoppoitla!=0){
                    
                    if (endtimestr==nil) {//判断是不是只有突然一个静止包，过滤处理
                        //删除旧数据
                        stoppoitla=0;
                        stoppoitlo=0;
                        startimestr=nil;
                        endtimestr=nil;
                    }else
                    {
                        
                    //判断这次静止点的开始时间和结束时间是否大于5分钟。大于才绘制
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSDate *beginDate = [dateFormatter dateFromString:startimestr];
                        NSDate * nowDate =[dateFormatter dateFromString:endtimestr];
                        NSTimeInterval timeSpanInSeconds = [nowDate timeIntervalSinceDate:beginDate];
                        NSLog(@"timeSpanInSeconds=%f",timeSpanInSeconds);
                        if (timeSpanInSeconds>5) {// 停止超过5分钟才绘制静止点
                            //开始绘画静止点
                            CustomPointAnnotation *newPoint = [[CustomPointAnnotation alloc] init];
                            CLLocationCoordinate2D stoocoor=CLLocationCoordinate2DMake(stoppoitla, stoppoitlo);
                            newPoint.coordinate = stoocoor;
                            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[self getTimeDurationWithBeginTime:startimestr EndTime:endtimestr],@"stoptime",startimestr,@"starttime",endtimestr,@"endtime", nil];
                            newPoint.pointCalloutInfo=dict;
                            //newPoint.title=@"test";
                            [_mapView addAnnotation:newPoint];
                        }
                        
                    
                    //绘画完毕，删除旧数据
                    stoppoitla=0;
                    stoppoitlo=0;
                    startimestr=nil;
                    endtimestr=nil;
                    }
                }
            }
        }
    }
    
   // NSLog(@"总里程：%f",_sumOfDistance);
   // NSLog(@"总静止时间：%@",[self get_the_stop_time_str:allstoptime]);
}


-(void)showAlltimeAndDistance
{
    //if (_sumOfDistance!=0) {
        
        //总里程处理
        NSString *distancestr;
        if(_sumOfDistance>900)
        {
            distancestr=[NSString stringWithFormat:@"%@：%0.1fkm \r\n",[SwichLanguage getString:@"hisall1"],_sumOfDistance/1000];
        }else if(_sumOfDistance>=0)
        {
            distancestr=[NSString stringWithFormat:@"%@：%0.1fm \r\n",[SwichLanguage getString:@"hisall1"],_sumOfDistance];
        }else if(_sumOfDistance<0)
        {
            distancestr=@"";
        }
        
        
    NSString* str=[NSString stringWithFormat:@"%@ %@：%@",distancestr,[SwichLanguage getString:@"hisall2"],[self.inAppSetting getTimeDurationWithtimeSpanInSeconds:allstoptime]];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                             message:str
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:[SwichLanguage getString:@"close"], nil
                                   ];
        alertView.tag=0;
        [alertView show];
    //}
}
#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && alertView.tag==0) {
        
    }
}


- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

// 识别静止点
-(void) filtTrack_parseStatic:(NSArray*) track {
    
    if (track.count == 0) {
        return ;
    }
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    HistoryLocationObject *object1 = [track objectAtIndex:0];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([object1.la floatValue], [object1.lo floatValue]);
    
    CLLocationCoordinate2D prev_loc = coor;
    NSDate* prev_time = [df dateFromString:object1.stsTime];
    NSLog(@"object1.stsTime=%@ ",[df stringFromDate:prev_time]);
    for (int i = 1; i < track.count; i++) {
        
        HistoryLocationObject *object = [track objectAtIndex:i];
        CLLocationCoordinate2D currPt = CLLocationCoordinate2DMake([object.la floatValue], [object.lo floatValue]);
        
        float realDist = [self getDistanceByL:prev_loc and:currPt];
        NSTimeInterval dTime = [[df dateFromString:object.stsTime] timeIntervalSinceDate:prev_time]*1000;
        NSLog(@"dTime=%f object.stsTime=%@ prev_time=%@",dTime,object.stsTime,[df stringFromDate:prev_time] );
        
        float realSpd = [object.speed floatValue];
        
        float expSpd = realDist / dTime * 3600;
        float errRatio = expSpd / realSpd;
        
        
        // 判定上一帧为静止点
        if (dTime > 60*1000*5  && errRatio < 0.2) {
            NSLog(@"静止点");
            //开始绘画静止点
            CustomPointAnnotation *newPoint = [[CustomPointAnnotation alloc] init];
            newPoint.coordinate = currPt;
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[self getTimeDurationWithBeginTime: [df stringFromDate:prev_time] EndTime:object.stsTime],@"stoptime",[df stringFromDate:prev_time] ,@"starttime",object.stsTime,@"endtime", nil];
            newPoint.pointCalloutInfo=dict;
            //newPoint.title=@"test";
            [_mapView addAnnotation:newPoint];
        }
        
        prev_loc = currPt;
        prev_time =[df dateFromString:object.stsTime];
    }
    
}

-(float)getDistanceByL:(CLLocationCoordinate2D)coor_before and:(CLLocationCoordinate2D)coor
{
                BMKMapPoint beforePoint = BMKMapPointForCoordinate(coor_before);
                BMKMapPoint currentPoint = BMKMapPointForCoordinate(coor);
                CLLocationDistance distance = BMKMetersBetweenMapPoints(beforePoint,currentPoint);
                 NSNumber * _distance = [NSNumber numberWithDouble:distance];
                return  [_distance floatValue];
}



-(void)handleHistoryData:(NSArray*)array withstartTime:(NSString*)startTime withendTime:(NSString*)endTime withIsFirst:(BOOL)theFirst
{
    if (array.count != 0)
    {
        
        // 用协议返回的array建立轨迹
        [self setTrackArray:array];
        // 轨迹移动的代码
        [_trackPlayerView setTotalSteps:array.count];
        // 自动开始啦
        [_trackPlayerView.playPauseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        //停留点判断，总停留时间判断，总里程判断
        //[self count_the_stop_poit_and_licheng:array];
        [self filtTrack_parseStatic:array];
        
        //标记起点
        HistoryLocationObject *startlocation=[array objectAtIndex:0];
        StartAndEndAnNotation *_userLocation = [[StartAndEndAnNotation alloc] init];
        _userLocation.type = 0;
        _userLocation.coordinate =CLLocationCoordinate2DMake([startlocation.la floatValue], [startlocation.lo floatValue]);
        [_mapView addAnnotation:_userLocation];
        
        //标记终点1989515
        
        HistoryLocationObject *endlocation=[array objectAtIndex:array.count-1];
        StartAndEndAnNotation *_userLocation1 = [[StartAndEndAnNotation alloc] init];
        _userLocation1.type = 1;
        _userLocation1.coordinate =CLLocationCoordinate2DMake([endlocation.la floatValue], [endlocation.lo floatValue]);
        [_mapView addAnnotation:_userLocation1];
        if (theFirst) {
            [self getmileagewithStartTime:startTime withEndTime:endTime];
        }
    }
    else
    {
        [MBProgressHUD showQuickTipWithText:[SwichLanguage getString:@"errorA109X"]];
    }
}

-(void)ThejizhangStatusChange:(BOOL)theStatus
{
    NSLog(@"ThejizhangStatusChange=theStatus=%@",theStatus==YES?@"yes":@"no");
    isGuoluJZ=theStatus;
}

-(void)click_righttop_button
{
    
    if (_mapView.mapType==BMKMapTypeSatellite) {
        [_mapView setMapType:BMKMapTypeStandard];
        [_liebiaoButton setTitle:[SwichLanguage getString:@"satellite"] forState:UIControlStateNormal];
    }else
    {
        [_mapView setMapType:BMKMapTypeSatellite];
        [_liebiaoButton setTitle:[SwichLanguage getString:@"normol"] forState:UIControlStateNormal];
    }
}
-(void)updateTableView
{
    selectid=_trackPlayerView.sliderBar.value;
    [self.messageCenterTableView setHidden:NO];
    self.messageArray=[self.historyLocations mutableCopy];
    [self.messageCenterTableView reloadData];
    NSLog(@"selectid=%f",selectid);
    if(self.messageArray.count>0&&self.messageArray.count>=selectid)
    {
    [self.messageCenterTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectid inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void)tableViewSetting
{
//    if(KIsiPhoneX)
//    {
//        CGRect newfame=self.messageCenterTableView.frame;
//        newfame.origin.y=newfame.origin.y+IPXMargin;
//        newfame.size.height=newfame.size.height-IPXMagin;
//        [self.messageCenterTableView setFrame:newfame];
//    }
    CGRect newfame=CGRectMake(0,morigeBtY-tableViewH+btview.frame.size.height, VIEWWIDTH, tableViewH);
    self.messageCenterTableView =[[RefreshableTableView alloc] initWithFrame:newfame];
    [self.view addSubview:self.messageCenterTableView];
    self.messageCenterTableView.hidden=YES;
    
    self.messageCenterTableView.delegate = self;
    self.messageCenterTableView.dataSource = self;
    [self.messageCenterTableView setBackgroundColor:[UIColor whiteColor]];
    [self.messageCenterTableView setTableFooterView:[[UIView alloc] init]];
    //[self.messageCenterTableView registerNib:[UINib nibWithNibName:@"HistoryScrollCell" bundle:nil] forCellReuseIdentifier:@"HistoryScrollCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.messageArray = [NSMutableArray array];
    // [self.messageCenterTableView.header beginRefreshing];//刷新加载
    [self.view bringSubviewToFront:self.messageCenterTableView];
    
    self.topArr = @[[SwichLanguage getString:@"hislist2"],[SwichLanguage getString:@"hislist3"], [SwichLanguage getString:@"hislist4"], [SwichLanguage getString:@"hislist5"], [SwichLanguage getString:@"hislist6"]];
    // 注册一个
    extern NSString *tapCellScrollNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:tapCellScrollNotification object:nil];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.messageArray.count = %lu",(unsigned long) self.messageArray.count);
    return self.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;//50
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     //NSLog(@"点击一下");
    [_trackPlayerView.sliderBar setValue:indexPath.row];
    [self clickShowTableListButton];
    [self sliderValueDidChangeToStep:indexPath.row withDuration:0];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
//    UIControl *titileView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0,self.messageCenterTableView.frame.size.width, 30)];
//    titileView.backgroundColor = [UIColor blackColor];
//
//    float mainwith=self.messageCenterTableView.frame.size.width;
//    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, mainwith/8,20)];
//    titleLable.textColor = [UIColor whiteColor];
//    titleLable.font = [UIFont systemFontOfSize:14];
//    titleLable.text = [SwichLanguage getString:@"hislist1"];
//    titleLable.adjustsFontSizeToFitWidth=YES;
//    titleLable.minimumScaleFactor=miniScale;
//    titleLable.textAlignment=NSTextAlignmentCenter;
//    [titileView addSubview:titleLable];
//
//    UILabel *mileageLable = [[UILabel alloc] initWithFrame:CGRectMake(mainwith/8, 5, mainwith/4,20)];
//    mileageLable.textColor = [UIColor whiteColor];
//    mileageLable.font = [UIFont systemFontOfSize:14];
//    mileageLable.text =[SwichLanguage getString:@"hislist2"];
//    mileageLable.adjustsFontSizeToFitWidth=YES;
//    mileageLable.textAlignment=NSTextAlignmentCenter;
//    mileageLable.minimumScaleFactor=miniScale;
//    [titileView addSubview:mileageLable];
//
//
//    UILabel *oilLable = [[UILabel alloc] initWithFrame:CGRectMake(mainwith*3/8, 5, mainwith/4,20)];
//    oilLable.textColor = [UIColor whiteColor];
//    oilLable.font = [UIFont systemFontOfSize:14];
//    oilLable.text =[SwichLanguage getString:@"hislist3"];;
//    oilLable.textAlignment=NSTextAlignmentCenter;
//    oilLable.adjustsFontSizeToFitWidth=YES;
//    oilLable.minimumScaleFactor=miniScale;
//    [titileView addSubview:oilLable];
//
//    UILabel *durationLable = [[UILabel alloc] initWithFrame:CGRectMake(mainwith*5/8, 5, mainwith*3/8,20)];
//    durationLable.textColor = [UIColor whiteColor];
//    durationLable.font = [UIFont systemFontOfSize:14];
//    durationLable.text =[SwichLanguage getString:@"hislist4"];;
//    durationLable.textAlignment=NSTextAlignmentCenter;
//    durationLable.adjustsFontSizeToFitWidth=YES;
//    durationLable.minimumScaleFactor=miniScale;
//    [titileView addSubview:durationLable];
//
//    return titileView;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        CGFloat lblW = self.view.bounds.size.width / 5;
        
        UILabel *titleLbl = [UILabel new];
        titleLbl.frame = CGRectMake(0, 0, 48, 40);
        titleLbl.text = [SwichLanguage getString:@"hislist1"];
        titleLbl.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
        titleLbl.font = [UIFont systemFontOfSize:14];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:titleLbl];
        
        self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(48, 0, self.view.bounds.size.width-48, 40)];
        self.topScrollView.showsVerticalScrollIndicator = NO;
        self.topScrollView.showsHorizontalScrollIndicator = NO;
        self.topScrollView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
        
        
        //CGFloat labelW = self.view.bounds.size.width / 5;
        CGFloat labelW = 80;
        [self.topArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = [UILabel new];
            switch (idx) {
                case 0:
                    label.frame = CGRectMake(labelW * idx, 0, labelW, 40);
                    break;
                case 1:
                    label.frame = CGRectMake(labelW * idx, 0, labelW, 40);
                    break;
                case 2:
                    label.frame = CGRectMake(labelW * idx, 0, labelW+70, 40);
                    break;
                case 3:
                    label.frame = CGRectMake(labelW * idx+70, 0, labelW, 40);
                    break;
                case 4:
                    label.frame = CGRectMake(labelW * idx+70, 0, labelW, 40);
                    break;
                default:
                    break;
            }
            label.text = self.topArr[idx];
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self.topScrollView addSubview:label];
        }];
        self.topScrollView.contentSize = CGSizeMake(lblW * self.topArr.count+70, 0);
        self.topScrollView.delegate = self;
        
        [headerView addSubview:self.topScrollView];
        
        return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CarLogCell *cell = [CarLogCell cellWithTableView:tableView];
//    static NSString * identifier = @"HistoryScrollCell";
//    HistoryScrollCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    HistoryLocationObject *object = [_historyLocations objectAtIndex:indexPath.row];
//    cell.label1.text=[NSString stringWithFormat:@"%ld",(indexPath.row+1)];
//    cell.label2.text=object.getDescribeBystsTime;
//    cell.label3.text=object.getDescribeBylocateSts;
//    cell.label4.text=object.getDescribeBylalo;
//    if(selectid==indexPath.row)
//    {
//        cell.label1.textColor=[UIColor blueColor];
//    }else
//    {
//        cell.label1.textColor=[UIColor blackColor];
//    }
    
    
    static NSString *cellID = @"cellID";
    
    _aroundCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!_aroundCell)
    {
        _aroundCell = [[HistoryScrollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    

    _aroundCell.tableView = self.messageCenterTableView;
    __weak typeof(self) weakSelf = self;
    _aroundCell.tapCellClick = ^(NSIndexPath *indexPath) {
        [weakSelf tableView:tableView didSelectRowAtIndexPath:indexPath];
    };
    HistoryLocationObject *object = [self.historyLocations objectAtIndex:indexPath.row];
    SS_Model *model= [[SS_Model alloc]init];
    model.title=[NSString stringWithFormat:@"%ld",(indexPath.row+1)];
    model.str1=object.getDescribeBystsTime;
    model.str2=object.getDescribeBylocateSts;
    model.str3=object.getDescribeBylalo;
    model.str4=object.getaAltitude;
    model.str5=object.getAccuracyType;
    
    [_aroundCell initWithCellModel:model andArray:self.topArr];
    return _aroundCell;
}

// 分辨率大小调整图标大小
-(UIImage*)getMapPointImageFitSize:(NSString*)mimagename
{
    UIImage* mimage=[UIImage imageNamed:mimagename];
    if(KIsiPhoneX)
    {
        return  [self.dataModel scaleImage:mimage width:3];
    }else
    {
        return mimage;
    }
}

//配置列表按钮
-(void)setupListButton
{
    float btH=30;//按钮高度
    btview=[[UIView alloc] initWithFrame:CGRectMake(0,VIEWHEIGHT- _trackPlayerView.frame.size.height-btH, VIEWWIDTH, btH)];
    [btview setBackgroundColor:[UIColor whiteColor]];
    btview.userInteractionEnabled=YES;
    morigeBtY=btview.frame.origin.y;
    [self.view addSubview:btview];
    
    mbtig=[[UIImageView alloc] initWithFrame:CGRectMake(VIEWWIDTH/2-10,10, 20, 10)];
    [mbtig setImage:[UIImage imageNamed:@"setupb.png"]];
    //[mbtig setBackgroundColor:[UIColor redColor]];
    [btview addSubview:mbtig];
    
    UIView *lineView1=[[UIView alloc] initWithFrame:CGRectMake(0,btH-2, VIEWWIDTH, 2)];
    [lineView1 setBackgroundColor:LineGraycolor];
    [btview addSubview:lineView1];
    
    //配资点击触发
    UITapGestureRecognizer *tagGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShowTableListButton)];
    [btview addGestureRecognizer:tagGes];
    
    //配置table view 高度，影响列表按钮的位置变动
    if(KIsiPhoneX)
    {
        tableViewH=VIEWHEIGHT/2-btH*2-_trackPlayerView.frame.size.height;
    }else
    {
        tableViewH=VIEWHEIGHT/2;
    }
}

//刷新messageview 等界面位置
-(void)clickShowTableListButton
{
    float my;
    if (_messageCenterTableView.hidden) {
        mbtig.transform = CGAffineTransformMakeRotation(M_PI);
        my=morigeBtY-tableViewH;
        [_messageCenterTableView setHidden:NO];
        [_trackPlayerView stopshowing];
        [self updateTableView];
    }else
    {
        mbtig.transform =CGAffineTransformIdentity;
        my=morigeBtY;
        [_messageCenterTableView setHidden:YES];
    }
    CGRect mrect=btview.frame;
    mrect.origin.y=my;
    [btview setFrame:mrect];
}
//获取图标要显示的类型
-(UIImage*)getShowImage:(NSString*)mdevstatus AndCouse:(NSString*)mcouse AndLogoType:(NSString*)mlogoType
{
    //NSLog(@"getShowImage:mdevstatus=%@ mcouse=%@",mdevstatus,mcouse);
    int thecouse=0;//默认方向
    if (mcouse!=nil) {
        thecouse=[mcouse intValue];
    }
    //return [self.dataModel getImageWithStatus:mdevstatus AndCouser:thecouse];
    return [self.dataModel getMapImageWithStatus:mdevstatus AndCouser:thecouse AndLogoType:mlogoType];
}


#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:self.topScrollView])
    {
        CGPoint offSet = _aroundCell.rightScrollView.contentOffset;
        offSet.x = scrollView.contentOffset.x;
        _aroundCell.rightScrollView.contentOffset = offSet;
    }
    if ([scrollView isEqual:self.messageCenterTableView])
    {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(self.cellLastX)}];
    }
    
}

-(void)scrollMove:(NSNotification*)notification
{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    self.cellLastX = x;
    CGPoint offSet = self.topScrollView.contentOffset;
    offSet.x = x;
    self.topScrollView.contentOffset = offSet;
    obj = nil;
}
@end
