//
//  AlarmTimeView.h
//  CarConnection
//
//  Created by 林张宇 on 15/4/17.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger{
    MainView,
    HistoryTrack
}userIdentity;

@protocol AlarmTimeDelegate <NSObject>

- (void)alarmTimeSettingWithStartTime:(NSString *)startTime EndTime:(NSString *)endTime;

@optional
- (void)NotMeetTheStandards:(NSString *)message;

@end

@interface AlarmTimeView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) id<AlarmTimeDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *showlabel1;
@property (weak, nonatomic) IBOutlet UILabel *showlabel2;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

- (id)initWithMode:(UIDatePickerMode)pickerViewMode
 WithDateFormatter:(NSString *)dateFormatter
  WithUserIdentify:(userIdentity)userIdentity;
- (void)showInView:(UIView *)view;

@end
