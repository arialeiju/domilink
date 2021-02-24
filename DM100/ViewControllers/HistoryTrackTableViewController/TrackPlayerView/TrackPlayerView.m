//
//  TrackPlayerView.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/16.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "TrackPlayerView.h"
#import "PickerView.h"
#import "AlarmTimeView.h"
#import "CustomTimeSelectionView.h"
#import "CustomPickerView.h"
#import "HistoryTrackService.h"

@interface TrackPlayerView ()<CustomPickerViewDelegate,pickerViewDelegate, AlarmTimeDelegate, CustomTimeSelectionViewDelegate>
{
    NSArray *_speedSelection;
    NSArray *_speedFloatArr;
    NSArray *_timeSelections;
    
    NSInteger _totalSteps;
    NSInteger _currentStep;
    NSInteger _currentSpeedIndex;
    
    NSTimer *_timer;
    
    NSString *_currentStartTime;
    NSString *_currentEndTime;
    
    CustomTimeSelectionView *_timeSelectionView;
    BOOL isGuoluJZ;//是否过滤基站数据

}
@end

@implementation TrackPlayerView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    NSArray *nibBundleArray = [[NSBundle mainBundle] loadNibNamed:@"TrackPlayerView"
                                                            owner:self
                                                          options:nil];
    self = [nibBundleArray firstObject];
    _selectionView = [nibBundleArray objectAtIndex:1];
    if (self)
    {
        self.frame = frame;

//        CGRect selectionFrame = _selectionView.frame;
//        selectionFrame.origin.x = VIEWWIDTH-CGRectGetWidth(selectionFrame)-10;
//        selectionFrame.origin.y = CGRectGetMaxY(self.frame)+20;
//
//        _selectionView.frame = selectionFrame;
//
//        _currentSpeedIndex = 2;
        float playerviewheight;
        if (KIsiPhoneX)
        {
            playerviewheight=NAVBARHEIGHT+3+20;
        }else
        {
            playerviewheight=NAVBARHEIGHT+12+20;
        }
        CGRect selectionFrame = _selectionView.frame;
        selectionFrame.origin.x = VIEWWIDTH-CGRectGetWidth(selectionFrame)-10;
        selectionFrame.origin.y = playerviewheight;
        
        _selectionView.frame = selectionFrame;
        
        _currentSpeedIndex = 2;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _currentStartTime = [formatter stringFromDate:[NSDate date]];
        _currentEndTime = [formatter stringFromDate:[NSDate date]];
        
        isGuoluJZ=NO;
        
        [self setupData];
        
        [self setupView];
    }
    return self;
}

- (void)setupData
{
    _timeSelections = @[[SwichLanguage getString:@"his7"],
                        [SwichLanguage getString:@"his6"],
                        [SwichLanguage getString:@"his5"],
                        [SwichLanguage getString:@"his4"]];
    
    _speedSelection =@[[SwichLanguage getString:@"speed1"],
                       [SwichLanguage getString:@"speed2"],
                       [SwichLanguage getString:@"speed3"],
                       [SwichLanguage getString:@"speed4"],
                       [SwichLanguage getString:@"speed5"]];
//    _speedFloatArr = @[[NSNumber numberWithFloat:2.0f],
//                       [NSNumber numberWithFloat:1.0f],
//                       [NSNumber numberWithFloat:0.5f],
//                       [NSNumber numberWithFloat:0.25f],
//                       [NSNumber numberWithFloat:0.125f]];
    
    _speedFloatArr = @[[NSNumber numberWithFloat:1.0f],
                       [NSNumber numberWithFloat:0.5f],
                       [NSNumber numberWithFloat:0.35f],
                       [NSNumber numberWithFloat:0.125f],
                       [NSNumber numberWithFloat:0.08f]];
}

- (void)setupView
{
    [_sliderBar addTarget:self
                   action:@selector(sliderTouchDown:)
         forControlEvents:UIControlEventTouchDown];
    
    [_sliderBar addTarget:self
                   action:@selector(sliderDidChangeValue:)
         forControlEvents:UIControlEventValueChanged];

    [_sliderBar addTarget:self
                   action:@selector(sliderTouchUp:)
         forControlEvents:UIControlEventTouchUpInside];
    [_sliderBar addTarget:self
                   action:@selector(sliderTouchUp:)
         forControlEvents:UIControlEventTouchUpOutside];
    [self.label1 setText:[SwichLanguage getString:@"popt2"]];
    [self.label2 setText:[NSString stringWithFormat:@"%@:",[SwichLanguage getString:@"mspeed"]]];
    self.label1.adjustsFontSizeToFitWidth=YES;
    self.label2.adjustsFontSizeToFitWidth=YES;
    self.showJZstatusView.adjustsFontSizeToFitWidth=YES;
}

#pragma mark - Setter
- (void)setTotalSteps:(NSInteger)steps
{
    _totalSteps = steps-1;
    _currentStep = 0;
    _sliderBar.maximumValue = _totalSteps;
    _sliderBar.value = 0.0f;
    _playPauseButton.enabled = YES;
    _speedButton.enabled = YES;
}


#pragma mark - ButtonDo
- (IBAction)playPauseButtonDo:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (!button.isSelected)
    {
        if (_currentStep == _totalSteps)
        {
            //[self setTotalSteps:_totalSteps];
            _currentStep=0;
        }
      //  _currentStep=0;
        if (_timer == nil)
        {
            _timer = [self timerForCurrentSpeed];
        }
        else
        {
            [_timer resumeTimer];
        }
    }
    else
    {
        [_timer pauseTimer];
    }
    
    [button setSelected:!button.isSelected];
}

-(void)stopshowing
{
    [_playPauseButton setSelected:NO];
    [_timer pauseTimer];
}

- (IBAction)speedButtonDo:(id)sender
{
    [_playPauseButton setSelected:NO];
    [_timer pauseTimer];
    
    CustomPickerView *customPickerView = [[CustomPickerView alloc] initWithSelection:_speedSelection];
    customPickerView.delegate = self;
    [customPickerView setPickerViewSelectedIndex:_currentSpeedIndex];
    [customPickerView showInView:[UIApplication sharedApplication].keyWindow];

}

- (IBAction)timeRangeButtonDo:(id)sender
{
    [_playPauseButton setSelected:NO];
    [_timer pauseTimer];
    
//    PickerView * picker = [[PickerView alloc] initWithTitle:@"历史时间选择" PickViewType:PickerViewTypeHistoryTime];
//    picker.delegate = self;
//    [picker showInView:[UIApplication sharedApplication].keyWindow];

    if (_timeSelectionView == nil)
    {
        _timeSelectionView = [[CustomTimeSelectionView alloc] initWithSelectionArray:_timeSelections
                                                                 withDatePickerModel:UIDatePickerModeDateAndTime
                                                                   withDateFormatter:@"yyyy-MM-dd HH:mm:ss"];
        _timeSelectionView.delegate = self;
        [_timeSelectionView.jizhangSwitchButton setOn:isGuoluJZ];
    }
    [_timeSelectionView showInView:[UIApplication sharedApplication].keyWindow];
}


#pragma mark - Slider
- (void)sliderTouchDown:(UISlider *)slider
{
    if (_timer)
    {
        [_timer pauseTimer];
    }
    [_playPauseButton setSelected:NO];
}

- (void)sliderDidChangeValue:(UISlider *)slider
{
    int currentIntValue = slider.value;
    if (currentIntValue != _currentStep)
    {
        _currentStep = currentIntValue;
        if (_delegate && [_delegate respondsToSelector:@selector(sliderValueDidChangeToStep:withDuration:)])
        {
            [_delegate sliderValueDidChangeToStep:_currentStep
                                     withDuration:0];
        }
    }
}

- (void)sliderTouchUp:(UISlider *)slider
{
    [slider setValue:_currentStep];
}


#pragma mark - timer
- (NSTimer *)timerForCurrentSpeed
{
    return [NSTimer scheduledTimerWithTimeInterval:[_speedFloatArr[_currentSpeedIndex] floatValue]
                                            target:self
                                          selector:@selector(playTrackPerTrack)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)playTrackPerTrack
{
    if (_currentStep < _totalSteps)
    {
        _currentStep++;
        _sliderBar.value = _currentStep;
        if (_delegate && [_delegate respondsToSelector:@selector(sliderValueDidChangeToStep:withDuration:)])
        {
            [_delegate sliderValueDidChangeToStep:_currentStep
                                     withDuration:[_speedFloatArr[_currentSpeedIndex] floatValue]];
        }
    }
    else
    {
        [_playPauseButton setSelected:NO];
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)countHistoryTime:(NSString *)contentOfRow
{
    NSDate * now = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    NSInteger second = [dateComponent second];
    NSString *spe=@"0";
    //判断字段，然后内部计算时间
    if ([contentOfRow isEqualToString:[_timeSelections objectAtIndex:0]])
    {
        NSDate * delayStartTime = [now dateByAddingTimeInterval:- (hour * 60 *60 + minute * 60 + second)];
        _currentStartTime = [dateFormatter stringFromDate:delayStartTime];
        _currentEndTime = [dateFormatter stringFromDate:now];
    }
    else if ([contentOfRow isEqualToString:[_timeSelections objectAtIndex:1]])
    {
        NSDate * delayStartTime = [now dateByAddingTimeInterval:- (24*60*60 + hour * 60 *60 + minute * 60 + second)];
        NSDate * delayEndTime = [now dateByAddingTimeInterval:- (hour * 60 *60 + minute * 60 + second)];
        _currentStartTime = [dateFormatter stringFromDate:delayStartTime];
        _currentEndTime = [dateFormatter stringFromDate:delayEndTime];
    }
    else if ([contentOfRow isEqualToString:[_timeSelections objectAtIndex:2]])
    {
        NSDate * delayStartTime = [now dateByAddingTimeInterval:- (2*24*60*60 + hour * 60 *60 + minute * 60 + second)];
        NSDate * delayEndTime = [now dateByAddingTimeInterval:- (24*60*60 + hour * 60 *60 + minute * 60 + second)];
        _currentStartTime = [dateFormatter stringFromDate:delayStartTime];
        _currentEndTime = [dateFormatter stringFromDate:delayEndTime];
    }
    else if ([contentOfRow isEqualToString:[_timeSelections objectAtIndex:3]])
    {
        NSDate * delayStartTime = [now dateByAddingTimeInterval:- (60*60)];
        _currentStartTime = [dateFormatter stringFromDate:delayStartTime];
        _currentEndTime = [dateFormatter stringFromDate:now];
        spe=@"1";
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(timeRangeDidSelectedWithStartTime:withEndTime:withSpe:)])
    {
        [_delegate timeRangeDidSelectedWithStartTime:_currentStartTime
                                         withEndTime:_currentEndTime
                                         withSpe:spe];
    }
    
    _currentEndTime = [dateFormatter stringFromDate:now];
    _currentStartTime = [dateFormatter stringFromDate:now];
}
#pragma mark - pickerViewDelegate
- (void)histotyFinishButtonDidPushWithcontentOfRow:(NSString *)contentOfRow
{
    if ([contentOfRow isEqualToString:[SwichLanguage getString:@"his3"]])
    {
        AlarmTimeView *timeRangePickerView = [[AlarmTimeView alloc] initWithMode:UIDatePickerModeDateAndTime WithDateFormatter:@"yyyy-MM-dd HH:mm:ss" WithUserIdentify:HistoryTrack];
        timeRangePickerView.titleLabel.text =[SwichLanguage getString:@"dailog5T"];
        timeRangePickerView.startTimeTextField.text = _currentStartTime;
        timeRangePickerView.endTimeTextField.text = _currentEndTime;
        timeRangePickerView.delegate = self;
        [timeRangePickerView showInView:[UIApplication sharedApplication].keyWindow];
    }
    else
    {
        [self countHistoryTime:contentOfRow];
    }
}

#pragma mark - customPickerViewDelegate
- (void)customPickerView:(CustomPickerView *)pickerView didSelectRow:(NSInteger)row
{
    _currentSpeedIndex = row;
    [_timer invalidate];
    _timer = nil;
} 

#pragma mark - AlarmTimeViewDelegate
- (void)alarmTimeSettingWithStartTime:(NSString *)startTime EndTime:(NSString *)endTime withSpe:(NSString *)spe
{
    if (_currentStartTime == startTime && _currentEndTime == endTime)
    {
        return;
    }
    
    _currentStartTime = startTime;
    _currentEndTime = endTime;
    
    if (_delegate && [_delegate respondsToSelector:@selector(timeRangeDidSelectedWithStartTime:withEndTime:withSpe:)])
    {
        [_delegate timeRangeDidSelectedWithStartTime:startTime
                                         withEndTime:endTime
                                            withSpe:spe];
    }
}

- (void)NotMeetTheStandards:(NSString *)message
{
    [MBProgressHUD showQuickTipWithText:message];
}

#pragma mark - CustomTimeSelectionViewDelegate
- (void)customTimeSelectionView:(CustomTimeSelectionView *)view
         didSelectedAtNormalRow:(NSInteger)row
{
    [self countHistoryTime:[_timeSelections objectAtIndex:row]];
}

- (NSString *)customTimeSelectionView:(CustomTimeSelectionView *)view
           shouldConfirmWithStartTime:(NSString *)startTime
                          withEndTime:(NSString *)endTime
                            withSpe:(NSString *)spe
{
    NSString *errMsg = [self judgeTimeRangeWithStartTime:startTime
                                             withEndTime:endTime];
    if (errMsg == nil)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(timeRangeDidSelectedWithStartTime:withEndTime:withSpe:)])
        {
            [_delegate timeRangeDidSelectedWithStartTime:startTime
                                             withEndTime:endTime
                                             withSpe:spe
                                                ];
        }
    }
    return errMsg;
}

- (NSString *)customTimeSelectionView:(CustomTimeSelectionView *)view
           shouldConfirmWithStartTime:(NSString *)startTime
                          withEndTime:(NSString *)endTime
{
    NSString *errMsg = [self judgeTimeRangeWithStartTime:startTime
                                             withEndTime:endTime];
    if (errMsg == nil)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(timeRangeDidSelectedWithStartTime:withEndTime:withSpe:)])
        {
            [_delegate timeRangeDidSelectedWithStartTime:startTime
                                             withEndTime:endTime
                                                 withSpe:@"0"
             ];
        }
    }
    return errMsg;
}

- (NSString *)judgeTimeRangeWithStartTime:(NSString *)startTime
                              withEndTime:(NSString *)endTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [formatter dateFromString:startTime];
    NSDate *endDate = [formatter dateFromString:endTime];
    
    NSTimeInterval timeBetween = [endDate timeIntervalSinceDate:startDate];
    NSLog(@"%f",timeBetween);
    
    NSString * message = nil;

    if (0 < timeBetween && timeBetween < 86460*5)
    {
        //86460代表一天多一分钟，一分钟留给用户操作的时间限制
        //开始时间符合规定
    }
    else if (timeBetween <= 0)
    {
        //开始时间大于结束时间
       // message = @"开始日期必须早于或等于结束日期";
        message = [SwichLanguage getString:@"dailog5A1"];
    }
    else
    {
        //开始时间不符合规定
        message = [SwichLanguage getString:@"dailog5A3"];
    }
    return message;
}

-(void)ThejizhangStatusChange:(BOOL)theStatus
{
    isGuoluJZ=theStatus;
    //NSLog(@"ThejizhangStatusChange=theStatus=%@",theStatus==YES?@"yes":@"no");
    if ([_delegate respondsToSelector:@selector(ThejizhangStatusChange:)])
    {
        [_delegate ThejizhangStatusChange:theStatus];
    }
    if (theStatus) {
        [self.showJZstatusView setText:[SwichLanguage getString:@"JizhangHit1"]];
    }else
    {
        [self.showJZstatusView setText:[SwichLanguage getString:@"JizhangHit2"]];
    }
}
@end
