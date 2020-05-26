//
//  APMainMapViewController.h
//  domilink
//
//  Created by 马真红 on 2020/5/16.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface APMainMapViewController : UIViewController
@property (strong, nonatomic) MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *btChange;//切换按钮
- (IBAction)clickChangeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bt4;//撤防
@property (weak, nonatomic) IBOutlet UIView *bt3;//布防
@property (weak, nonatomic) IBOutlet UIView *bt2;//轨迹
@property (weak, nonatomic) IBOutlet UIView *bt1;//导航
@property (weak, nonatomic) IBOutlet UIView *bt5;//详情
@property (weak, nonatomic) IBOutlet UIView *bt6;//设置
@property (weak, nonatomic) IBOutlet UILabel *btlabel4;
@property (weak, nonatomic) IBOutlet UILabel *btlabel3;
@property (weak, nonatomic) IBOutlet UILabel *btlabel2;
@property (weak, nonatomic) IBOutlet UILabel *btlabel1;
@property (weak, nonatomic) IBOutlet UILabel *btlabel5;
@property (weak, nonatomic) IBOutlet UILabel *btlabel6;

@property (weak, nonatomic) IBOutlet UILabel *tvname;//设备名
@property (weak, nonatomic) IBOutlet UILabel *tvstatus;//显示状态
@property (weak, nonatomic) IBOutlet UILabel *tvaddress;//中文地址
@property (weak, nonatomic) IBOutlet UILabel *tv1;
@property (weak, nonatomic) IBOutlet UILabel *tv2;
@property (weak, nonatomic) IBOutlet UILabel *tv3;
@property (weak, nonatomic) IBOutlet UILabel *tv4;
@property (weak, nonatomic) IBOutlet UILabel *tv5;
@property (weak, nonatomic) IBOutlet UILabel *tv6;
@property (weak, nonatomic) IBOutlet UILabel *tv7;
@property (weak, nonatomic) IBOutlet UILabel *tvlabel1;
@property (weak, nonatomic) IBOutlet UILabel *tvlabel2;
@property (weak, nonatomic) IBOutlet UILabel *tvlabel3;
@property (weak, nonatomic) IBOutlet UILabel *tvlabel4;
@property (weak, nonatomic) IBOutlet UILabel *tvlabel5;
@property (weak, nonatomic) IBOutlet UILabel *tvlabel6;
@property (weak, nonatomic) IBOutlet UILabel *tvlabel7;
@property (weak, nonatomic) IBOutlet UIView *controlview1;
@property (weak, nonatomic) IBOutlet UIView *controlview2;
@property (weak, nonatomic) IBOutlet UIView *controlview3;
@property (weak, nonatomic) IBOutlet UIView *controlview4;
@property (weak, nonatomic) IBOutlet UILabel *TopLlabel1;
@property (weak, nonatomic) IBOutlet UILabel *TopLlabel2;
@property (weak, nonatomic) IBOutlet UILabel *TopLlabel3;
@property (weak, nonatomic) IBOutlet UILabel *TopRlabel1;
@property (weak, nonatomic) IBOutlet UILabel *TopRlabel2;
@property (weak, nonatomic) IBOutlet UIImageView *btimg1;
@property (weak, nonatomic) IBOutlet UIImageView *btimg2;
@property (weak, nonatomic) IBOutlet UIImageView *btimg3;
@property (weak, nonatomic) IBOutlet UIImageView *btimg4;

@property (weak, nonatomic) IBOutlet UIView *TopLView1;
@property (weak, nonatomic) IBOutlet UIView *TopLView2;
@property (weak, nonatomic) IBOutlet UIView *TopLView3;
@property (weak, nonatomic) IBOutlet UIView *TopRView1;
@property (weak, nonatomic) IBOutlet UIView *TopRView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgSts;
- (IBAction)MapZoonInAction:(id)sender;
- (IBAction)MapZoonOutAction:(id)sender;
- (IBAction)SelectUpAction:(id)sender;
- (IBAction)SelectDownAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgsigal;
- (IBAction)clicktipbutton:(id)sender;
@end

NS_ASSUME_NONNULL_END
