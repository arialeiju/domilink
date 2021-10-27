//
//  AddFenceViewController.h
//  DM100
//
//  Created by 马真红 on 2021/10/11.
//  Copyright © 2021 aika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FenceClass.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddFenceViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *submitbutton;
@property (strong, nonatomic) IBOutlet UITextField *namefield;
@property (strong, nonatomic) IBOutlet UIView *bomttomview;
@property (strong, nonatomic) IBOutlet UISlider *mslider;
@property (strong, nonatomic) IBOutlet UILabel *mlabel;
@property (strong, nonatomic) IBOutlet UIImageView *mimageview;
- (IBAction)sliderchangeAction:(id)sender;
- (IBAction)clickBtnSubmit:(id)sender;

@property (strong, nonatomic) MKMapView *mapView;
-(id)initWithImei:(NSString *)mimei andImeiName:(NSString *)mImeiName andIsAdd:(Boolean)madd;
-(void)setDataValueByFenceClss:(FenceClass*)mFenceClass;
@end

NS_ASSUME_NONNULL_END
