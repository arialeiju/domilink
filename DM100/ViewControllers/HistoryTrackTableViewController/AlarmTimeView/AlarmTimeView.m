//
//  AlarmTimeView.m
//  CarConnection
//
//  Created by 林张宇 on 15/4/17.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "AlarmTimeView.h"

#define AnimationDuration 0.2f

@interface AlarmTimeView()
{
    userIdentity user;
    
    UIView *_backgroundView;
    UIDatePicker *_startDatePicker;
    UIDatePicker *_endDatePicker;
    
    UIDatePickerMode _datePickerViewModel;
    NSString *_dateFormatter;
    
    BOOL state ;
}
@end

@implementation AlarmTimeView

@synthesize delegate = _delegate;

- (id)init
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"AlarmTimeView" owner:self options:nil]firstObject];
    if (self)
    {
        _datePickerViewModel = UIDatePickerModeTime;
        
        _dateFormatter = @"HH:mm";
        
        [self setupView];
        
        [self addNotification];
    }
    return self;
}

- (id)initWithMode:(UIDatePickerMode)pickerViewMode
 WithDateFormatter:(NSString *)dateFormatter WithUserIdentify:(userIdentity)userIdentity
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"AlarmTimeView" owner:self options:nil]firstObject];
    if (self)
    {
        _datePickerViewModel = pickerViewMode;
        
        _dateFormatter = dateFormatter;
     
        user = userIdentity;
        
        [self setupView];
        
        [self addNotification];
    }
    return self;
}


- (void)setupView
{
    
    
    self.center = CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2+40);
    
    self.startTimeTextField.delegate = self;
    self.endTimeTextField.delegate = self;
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    _startDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, VIEWHEIGHT-162, VIEWHEIGHT, 162)];
    _startDatePicker.datePickerMode = _datePickerViewModel;
    _startDatePicker.backgroundColor = [UIColor whiteColor];
    [_startDatePicker addTarget:self
                         action:@selector(startPickerValueChange:)
               forControlEvents:UIControlEventValueChanged];
    self.startTimeTextField.inputView = _startDatePicker;
    
    _endDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, VIEWHEIGHT-162, VIEWHEIGHT, 162)];
    _endDatePicker.datePickerMode = _datePickerViewModel;
    _endDatePicker.backgroundColor = [UIColor whiteColor];
    [_endDatePicker addTarget:self
                       action:@selector(endPickerValueChange:)
             forControlEvents:UIControlEventValueChanged];
    self.endTimeTextField.inputView = _endDatePicker;
    
    [self.showlabel1 setText:[SwichLanguage getString:@"his1"]];
    [self.showlabel2 setText:[SwichLanguage getString:@"his2"]];
    self.showlabel1.adjustsFontSizeToFitWidth=YES;
    self.showlabel2.adjustsFontSizeToFitWidth=YES;
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Target Responder
- (void)startPickerValueChange:(UIDatePicker *)datePicker
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:_dateFormatter];
    NSString * dateString = [formatter stringFromDate:datePicker.date];
    _startTimeTextField.text = dateString;
}

- (void)endPickerValueChange:(UIDatePicker *)datePicker
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:_dateFormatter];
    NSString * dateString = [formatter stringFromDate:datePicker.date];
    _endTimeTextField.text = dateString;
}

- (IBAction)confirmButtonDidPush:(id)sender {
    [self hideViewMethod];
    [self judgeUser];
    if (state == YES)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(alarmTimeSettingWithStartTime:EndTime:)]) {
        [_delegate alarmTimeSettingWithStartTime:self.startTimeTextField.text EndTime:self.endTimeTextField.text];
        }
    }
    
}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         [self setCenter:CGPointMake(VIEWWIDTH/2,
                                                     VIEWHEIGHT-CGRectGetHeight(keyboardFrame)-CGRectGetHeight(self.frame)/2-20)];
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         [self setCenter:CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2)];
                     }];
}

#pragma mark - Method

- (void)showInView:(UIView *)view
{
    if (_backgroundView == nil)
    {
        _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
        [_backgroundView.layer setOpacity:0];
    }
    
    [_backgroundView addSubview:self];
    [view addSubview:_backgroundView];
    [UIView animateWithDuration:AnimationDuration
                     animations:^{
                         [_backgroundView.layer setOpacity:1.0f];
                         [self setCenter:CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2)];
                     }completion:^(BOOL finished) {
                         UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideViewMethod)];
                         [_backgroundView addGestureRecognizer:tapGes];
                     }];
    
}

- (void)hideViewMethod
{
    [self.startTimeTextField resignFirstResponder];
    [self.endTimeTextField resignFirstResponder];
    [UIView animateWithDuration:AnimationDuration
                     animations:^{
                         [_backgroundView.layer setOpacity:0.0f];
                         [self setCenter:CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2+40)];
                     }completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [_backgroundView removeFromSuperview];
                     }];
    [self removeNotification];
}

- (void)judgeUser
{
    NSTimeInterval timeBetween = [_endDatePicker.date timeIntervalSinceDate:_startDatePicker.date];
    NSLog(@"%f",timeBetween);
    
    NSString * message;
    if (user == MainView) {
        if (timeBetween < 0) {
            //开始比结束的日期大
            state = NO;
            message = [SwichLanguage getString:@"dailog5A1"];
        }
        else
        {
            state = YES;
        }
    }
    else if (user == HistoryTrack)
    {
        if (0 < timeBetween && timeBetween < 86460) {
            //86460代表一天多一分钟，一分钟留给用户操作的时间限制
            //开始时间符合规定
            state = YES;
        }
        else if (timeBetween <= 0)
        {
            //开始时间大于结束时间
            state = NO;
            message = [SwichLanguage getString:@"dailog5A1"];
        }
        else
        {
            //开始时间不符合规定
            state = NO;
            message = [SwichLanguage getString:@"dailog5A3"];
        }
        
    }
    if (state == NO) {
        if (_delegate && [_delegate respondsToSelector:@selector(NotMeetTheStandards:)]) {
            [_delegate NotMeetTheStandards:message];
        }
    }
}

@end
