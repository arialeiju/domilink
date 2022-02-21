//
//  CustomTimeSelectionView.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/5/22.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectableButton.h"

@class CustomTimeSelectionView;

@protocol CustomTimeSelectionViewDelegate <NSObject>

/// 自定义行点击确认前回调，返回字符串提示错误信息，返回nil确认并隐藏view
- (NSString *)customTimeSelectionView:(CustomTimeSelectionView *)view
           shouldConfirmWithStartTime:(NSString *)startTime
                          withEndTime:(NSString *)endTime;

/// 选择一般行回调
- (void)customTimeSelectionView:(CustomTimeSelectionView *)view
         didSelectedAtNormalRow:(NSInteger)row;

//是否过滤基站传输
-(void)ThejizhangStatusChange:(BOOL)theStatus;

//是否过滤wifi传输
-(void)TheWifiStatusChange:(BOOL)theStatus;
@end

@interface CustomTimeSelectionView : UIView

@property (weak, nonatomic) id<CustomTimeSelectionViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *customTimeRow;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jizhanglabel;
@property (weak, nonatomic) IBOutlet UILabel *wifilabel;


- (id)initWithSelectionArray:(NSArray *)selections
         withDatePickerModel:(UIDatePickerMode)datePickerModel
           withDateFormatter:(NSString *)dateFormatter;

- (void)showInView:(UIView *)view;
- (void)hide;
@property (weak, nonatomic) IBOutlet UISwitch *jizhangSwitchButton;
- (IBAction)clickjizhangButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *wifiSwitchButton;
- (IBAction)clickwifiButton:(id)sender;

@end
