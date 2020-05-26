//
//  CustomTimeSelectionView.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/5/22.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "CustomTimeSelectionView.h"

#define ViewTopDelta    10.0f
#define ButtonMinX      10.0f

@interface CustomTimeSelectionView ()
{
    UIView *_backgroundView;
    UIDatePicker *_startDatePicker;
    UIDatePicker *_endDatePicker;
    UIDatePickerMode _datePickerViewModel;
    NSString *_dateFormatter;
    
    NSArray *_selectionsArray;
    NSMutableArray *_selectionButtons;
    
    NSInteger _totalCount;
    NSInteger _selectedRow;
}
@end

@implementation CustomTimeSelectionView

- (id)initWithSelectionArray:(NSArray *)selections
         withDatePickerModel:(UIDatePickerMode)datePickerModel
           withDateFormatter:(NSString *)dateFormatter
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomTimeSelectionView"
                                          owner:self
                                        options:nil] firstObject];
    if (self)
    {
        _dateFormatter = dateFormatter;
        _datePickerViewModel = datePickerModel;
        
        _selectionButtons = [NSMutableArray array];
        _selectionsArray = selections;
        [self setupSelections];
        [self setupView];
        [self setupCustomRow];
    }
    return self;
    
}

- (void)setupSelections
{
    CGRect buttonFrame = CGRectMake(ButtonMinX,
                                    ViewTopDelta,
                                    SelectableButtonWidth,
                                    SelectableButtonHeight);
    CGRect lineFrame = CGRectMake(ButtonMinX,
                                  CGRectGetMaxY(buttonFrame),
                                  SelectableButtonWidth,
                                  0.5);
    
    int tag = 0;
    for (NSString *selection in _selectionsArray)
    {
        // button
        SelectableButton *button = [[SelectableButton alloc] initWithTitle:selection];
        button.frame = buttonFrame;
        button.tag = tag++;
        [button addTarget:self
                   action:@selector(selectableButtonDidPush:)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_selectionButtons addObject:button];
        
        // line
        UIView *line = [[UIView alloc] initWithFrame:lineFrame];
        line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [self addSubview:line];
        
        // update frame
        buttonFrame.origin.y += SelectableButtonHeight + 1;
        lineFrame.origin.y += SelectableButtonHeight + 1;
    }
    _totalCount = tag+1;
    
    // customRow frame
    buttonFrame.origin.x = 0;
    buttonFrame.size = CGSizeMake(CGRectGetWidth(_customTimeRow.frame),
                                  CGRectGetHeight(_customTimeRow.frame));
    
    // 移动CustomRow
    _customTimeRow.frame = buttonFrame;
    [self bringSubviewToFront:_customTimeRow];
    // customTimeRow Button
    SelectableButton *customButton = [[SelectableButton alloc] initWithTitle:[SwichLanguage getString:@"his3"]];
    customButton.frame = CGRectMake(ButtonMinX,
                                    0,
                                    SelectableButtonWidth,
                                    SelectableButtonHeight);
    customButton.tag = tag;
    [_selectionButtons addObject:customButton];
    [customButton addTarget:self
                     action:@selector(selectableButtonDidPush:)
           forControlEvents:UIControlEventTouchUpInside];
    [_customTimeRow addSubview:customButton];
    
    // View frame
    CGRect newViewFrame = CGRectMake(0,
                                     0,
                                     CGRectGetWidth(self.frame),
                                     CGRectGetMaxY(buttonFrame));
    self.frame = newViewFrame;
}

- (void)setupView
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0f;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(blockGesture)];
    [self addGestureRecognizer:tapGes];
    
    [self.startTimeLabel setText:[SwichLanguage getString:@"his1"]];
    [self.endTimeLabel setText:[SwichLanguage getString:@"his2"]];
    self.startTimeLabel.adjustsFontSizeToFitWidth=YES;
    self.endTimeLabel.adjustsFontSizeToFitWidth=YES;
    [self.jizhanglabel setText:[SwichLanguage getString:@"JizhangHit3"]];
    self.jizhanglabel.adjustsFontSizeToFitWidth=YES;
    [self.confirmButton setTitle:[SwichLanguage getString:@"sure"] forState:UIControlStateNormal];
    [self.cancelButton setTitle:[SwichLanguage getString:@"cancel"] forState:UIControlStateNormal];
}

- (void)setupCustomRow
{
    // TimetextField
    _startTimeTextField.layer.borderColor = [[UIColor colorWithHexString:@"#eeeeee"] CGColor];
    _endTimeTextField.layer.borderColor = [[UIColor colorWithHexString:@"#eeeeee"] CGColor];
    _startTimeTextField.layer.borderWidth = 1.0f;
    _endTimeTextField.layer.borderWidth = 1.0f;
    
    // datePicker
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
    
    // 预设日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:_dateFormatter];
    self.startTimeTextField.text = [formatter stringFromDate:[NSDate date]];
    self.endTimeTextField.text = [formatter stringFromDate:[NSDate date]];
    
    // button
    _confirmButton.layer.masksToBounds = YES;
    _confirmButton.layer.cornerRadius = 3.0f;
    
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.cornerRadius = 3.0f;
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


#pragma mark - action

- (void)selectableButtonDidPush:(SelectableButton *)button
{
    for (UIButton *button in _selectionButtons)
    {
        [button setSelected:NO];
    }
    
    [button setSelected:YES];
    _selectedRow = button.tag;
    
    if (button.tag == _totalCount-1)
    {
        _startTimeTextField.enabled = YES;
        _endTimeTextField.enabled = YES;
        _startTimeTextField.textColor = [UIColor blackColor];
        _endTimeTextField.textColor = [UIColor blackColor];
        
        _startTimeLabel.textColor = [UIColor blackColor];
        _endTimeLabel.textColor = [UIColor blackColor];
    }
    else
    {
        _startTimeTextField.enabled = NO;
        _endTimeTextField.enabled = NO;
        _startTimeTextField.textColor = [UIColor lightGrayColor];
        _endTimeTextField.textColor = [UIColor lightGrayColor];
        
        _startTimeLabel.textColor = [UIColor lightGrayColor];
        _endTimeLabel.textColor = [UIColor lightGrayColor];
    }
    
    _confirmButton.enabled = YES;
    [_confirmButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
    [_confirmButton setBackgroundColor:[UIColor colorWithHexString:@"#00B7EE"]];
}


- (void)showInView:(UIView *)view
{
    [self addNotification];
    
    if (_backgroundView == nil)
    {
        _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        _backgroundView.layer.opacity = 0.0f;
        
        UITapGestureRecognizer *tagGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_backgroundView addGestureRecognizer:tagGes];
    }
    
    self.center = CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2 + 100);
    [_backgroundView addSubview:self];
    [view addSubview:_backgroundView];
    
    // animitaion
    [UIView animateWithDuration:0.25
                     animations:^
     {
         _backgroundView.layer.opacity = 1.0f;
         _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
         self.center = CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2);
     }];
}

- (void)hide
{
    [UIView animateWithDuration:0.25
                     animations:^
     {
         _backgroundView.layer.opacity = 0.0f;
         _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
         self.center = CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2+100);
     }
                     completion:^(BOOL finished)
     {
         [self removeFromSuperview];
         [_backgroundView removeFromSuperview];
         [self removeNotification];
     }];
}

- (void)blockGesture
{
    // do Nothing but useful
}

- (IBAction)confirmButtonDo:(id)sender
{
    if (_delegate == nil)
    {
        [self hide];
        return;
    }
    
    if (_selectedRow != _totalCount-1)
    {
        if ([_delegate respondsToSelector:@selector(customTimeSelectionView:didSelectedAtNormalRow:)])
        {
            [_delegate customTimeSelectionView:self
                        didSelectedAtNormalRow:_selectedRow];
        }
        [self hide];
    }
    else
    {
        NSString *errMsg = nil;
        if ([_delegate respondsToSelector:@selector(customTimeSelectionView:shouldConfirmWithStartTime:withEndTime:)])
        {
            errMsg = [_delegate customTimeSelectionView:self
                             shouldConfirmWithStartTime:_startTimeTextField.text
                                            withEndTime:_endTimeTextField.text];
            
        }
        
        if (errMsg)
        {
            [MBProgressHUD showQuickTipWithText:errMsg];
        }
        else
        {
            [self hide];
        }
    }
}

- (IBAction)cancelButtonDo:(id)sender
{
    [self hide];
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

#pragma mark - datePicker Value Change
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


- (IBAction)clickjizhangButton:(UISwitch *)swt{
    if ([_delegate respondsToSelector:@selector(ThejizhangStatusChange:)])
    {
        [_delegate ThejizhangStatusChange:swt.on];
    }

}
@end
