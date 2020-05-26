//
//  CarAlarmMapViewController.m
//  CarConnection
//
//  Created by 林张宇 on 15/5/21.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "CarAlarmMapViewController.h"
#import "CarAlarmPaopaoView.h"

@interface CarAlarmMapViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate, CarAlarmPaopaoViewDelegate>
{
    CarAlarmPaopaoView * _paopaoView;
    BMKPointAnnotation * _deviceAnnotation;
    BMKGeoCodeSearch * _deviceAddressSearch;
    
    CLLocationCoordinate2D _deviceCoor;
    NSString * _deviceSpeed;
    NSString * _deviceTime;
    NSString * _deviceDirection;
    NSString * _deviceAddress;
    
    /**
     "time":"消息的时间",
     "str":"消息内容",
     "imei":"设备imei",
     "name":"设备名称",
     "source":"0/1",
     "course":"航向",
     "speed":"速度",
     "longitude":"经度",
     "latitude":"纬度",
     "accsts":"acc状态(1：开启、0：熄火)"
     "deviceSts":"设备状态" (0代表静止 ，1代表离线 ，2代表过期 ，3代表行驶中)
     */
    NSDictionary *_deviceInfoDic;
    
}
@end

@implementation CarAlarmMapViewController

- (id)initWithType:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _deviceInfoDic = dictionary;
        _deviceCoor = CLLocationCoordinate2DMake([[_deviceInfoDic valueForKey:@"latitude"] floatValue], [[_deviceInfoDic valueForKey:@"longitude"] floatValue]);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"alarmmap"]];
    [self setUpMapView];
    [self setUpAnnotation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];

    //[self setUpAnnotation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setUpDeviceAddress];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _mapView.delegate = nil;
    if (_deviceAddressSearch!=nil) {
         _deviceAddressSearch.delegate = nil;
    }
    [_mapView viewWillDisappear];
}

#pragma mark Method
- (void)setDeviceInformationWith:(CLLocationCoordinate2D)deviceCoor
                           speed:(NSString *)speed
                            time:(NSString *)time
                       direction:(NSString *)direction
{
    _deviceCoor = deviceCoor;
    _deviceSpeed = speed;
    _deviceTime = time;
    _deviceDirection = direction;
}

- (void)setDeviceInfoWithDictionary:(NSDictionary *)dictionary
{
    _deviceInfoDic = dictionary;
    _deviceCoor = CLLocationCoordinate2DMake([[_deviceInfoDic valueForKey:@"latitude"] floatValue], [[_deviceInfoDic valueForKey:@"longitude"] floatValue]);
}

- (void)setUpMapView
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0,
                                                            NAVBARHEIGHT+(KIsiPhoneX?IPXMargin:0),
                                                            VIEWWIDTH,
                                                            VIEWHEIGHT-NAVBARHEIGHT)];
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 16;
    _mapView.delegate = self;
    [_mapView setCenterCoordinate:_deviceCoor
                         animated:YES];
    [self.view addSubview:_mapView];
}

- (void)setUpAnnotation
{
    if (_deviceAnnotation == nil)
    {
        _deviceAnnotation = [[BMKPointAnnotation alloc] init];
    }
    _deviceAnnotation.coordinate = _deviceCoor;
    [_mapView addAnnotation:_deviceAnnotation];
}

//- (void)setUpDeviceDirection
//{
//    NSArray * directionArray = [[NSArray alloc] initWithObjects:@"北",@"东北",@"东",@"东南",@"南",@"西南",@"西",@"西北",@"北", nil];
//    float degree = [_deviceDirection floatValue];
//    degree += 22.5;
//    int area = degree / 45;
//    _deviceDirection = [directionArray objectAtIndex:area];
//}

- (void)setUpDeviceAddress
{
    if (_deviceAddressSearch == nil)
    {
        _deviceAddressSearch = [[BMKGeoCodeSearch alloc] init];
    }
    _deviceAddressSearch.delegate = self;
    BMKReverseGeoCodeSearchOption * _reverseGeoCodeOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    
    _reverseGeoCodeOption.location = _deviceCoor;
    _reverseGeoCodeOption.isLatestAdmin = YES;
    BOOL flag = [_deviceAddressSearch reverseGeoCode:_reverseGeoCodeOption];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
}

#pragma mark - Data Controller
- (NSString *)deviceStatusString
{
    
    NSString *statusStr = nil;
    NSString *deviceStatus = [_deviceInfoDic valueForKey:@"deviceSts"];
    if ([deviceStatus isEqualToString:@"1"])
    {
        statusStr = [SwichLanguage getString:@"offline"];
    }
    else if ([deviceStatus isEqualToString:@"2"])
    {
        statusStr = [SwichLanguage getString:@"expire"];
    }
    else if ([deviceStatus isEqualToString:@"3"])
    {
        statusStr = [SwichLanguage getString:@"driving"];
    }
    else if ([deviceStatus isEqualToString:@"0"])
    {
       statusStr = [SwichLanguage getString:@"quiescent"];
    }
    else
    {
        statusStr = deviceStatus;
    }
    
    return statusStr;
}

- (NSString *)getTimeDurationWithBeginTime:(NSString *)beginDateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *beginDate = [dateFormatter dateFromString:beginDateStr];
    if (beginDate == nil)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        beginDate = [dateFormatter dateFromString:beginDateStr];
    }
    
    return [self.dataModel formatTimeSpan:beginDate];
}

#pragma mark - TrackPaopaoViewDelegate
- (void)TrackPaopaoViewDeleteButtonDidPush:(UIButton *)sender
{
    [_mapView deselectAnnotation:_deviceAnnotation animated:YES];
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    BMKAnnotationView * annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    if (annotationView == nil) {
        annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
        annotationView.image = [UIImage imageNamed:@"car_locate.png"];
        annotationView.centerOffset = CGPointMake(0, 0);
    }
    _paopaoView=[[CarAlarmPaopaoView alloc]init];
    _paopaoView.delegate = self;
    _paopaoView.imeiLabel.text = [_deviceInfoDic valueForKey:@"name"];
    _paopaoView.timeLabel.text = [_deviceInfoDic valueForKey:@"time"];
    _paopaoView.statusLabel.text = [self deviceStatusString];
    _paopaoView.alarmType.text = [_deviceInfoDic valueForKey:@"str"];
    
    //设备acc
    if ([_deviceInfoDic valueForKey:@"accsts"] != nil &&
        [[_deviceInfoDic valueForKey:@"accsts"] isEqualToString:@"1"])
    {
         _paopaoView.accLabel.text = [SwichLanguage getString:@"open"];
    }
    else if ([_deviceInfoDic valueForKey:@"accsts"] != nil &&  [[_deviceInfoDic valueForKey:@"accsts"] isEqualToString:@"0"])
    {
         _paopaoView.accLabel.text =  [SwichLanguage getString:@"close"];
    }
    else
    {
        _paopaoView.accLabel.text = @"";
    }
    
    BMKActionPaopaoView * actionPaopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:_paopaoView];
    [annotationView setPaopaoView:actionPaopaoView];
    annotationView.selected = YES;
    return annotationView;
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        //[_paopaoView setAddressText:result.address];
        NSString* maddress=result.sematicDescription;
        NSLog(@"maddress=%@",maddress);
        if (maddress!=nil&&maddress.length>0) {
            [_paopaoView setAddressText:[NSString stringWithFormat:@"%@(%@)",result.address,maddress]];
        }else
        {
            [_paopaoView setAddressText:result.address];
        }
    }
    else
    {
        _paopaoView.addressLabel.text = @"";
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - CarAlarmPaopaoViewDelegate
- (void)carAlarmPaopaoViewCloseButtonDidPush
{
    [_mapView deselectAnnotation:_deviceAnnotation animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
