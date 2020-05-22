//
//  ItemViewController.m
//  BLETestApp
//
//  Created by 马真红 on 2020/4/26.
//  Copyright © 2020 aika. All rights reserved.
//

#import "ItemViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入地图功能所有的头文件
#import <BMKLocationKit/BMKLocationComponent.h>
@interface ItemViewController ()

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViewAdapter];
}

-(void)initViewAdapter
{
    self.mapbutton.layer.masksToBounds=YES;
    self.mapbutton.layer.cornerRadius=2.0f;
}

- (IBAction)clickmapbutton:(id)sender {
    NSLog(@"click");
}
@end
