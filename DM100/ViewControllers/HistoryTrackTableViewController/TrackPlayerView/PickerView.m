//
//  PickerView.m
//  CarConnection
//
//  Created by 林张宇 on 15/4/2.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "PickerView.h"

@implementation PickerView
{
    UIView * _backGroundView;
    
    NSString *_title;
    NSArray *_pickerArray;
    PickerViewType _pickerViewType;
    NSString * _timeString;
    NSString * _contentOfRow;
    NSString * _rowOfPickerView;
}

@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self)
    {
       
        self = [[[NSBundle mainBundle] loadNibNamed:@"PickerView"
                                              owner:self
                                            options:nil] objectAtIndex:0];
        [self setFrame:CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds]), CGRectGetWidth([[UIScreen mainScreen] bounds]), 268)];
        [self.pickerView setDelegate:self];
        [self.pickerView setDataSource:self];
        [self setupBackGroundView];
    }
    return self;
}


#pragma mark - Method

- (id)initWithTitle:(NSString *)title
       PickViewType:(PickerViewType)pickerViewType;
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"PickerView"
                                          owner:self
                                        options:nil] firstObject];
    if (self)
    {
        _title = title;
        _pickerViewType = pickerViewType;
        _rowOfPickerView = @"0";
        [self setupView];
        [self setupData];
    }
    return self;
}

- (void)setupView
{
    // viewFrame
    [self setFrame:CGRectMake(0,
                              CGRectGetHeight([[UIScreen mainScreen] bounds]),
                              CGRectGetWidth([[UIScreen mainScreen] bounds]),
                              PickerViewHeight)];
    
    // inner pickerView
    [self setupPickerView];
    
    // background View
    [self setupBackGroundView];
}

- (void)setupPickerView
{
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}

- (void)setupBackGroundView
{
    _backGroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _backGroundView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer * hideBGViewGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInView)];
    [_backGroundView addGestureRecognizer:hideBGViewGes];
    [_backGroundView addSubview:self];
}

- (void)setupData
{
    _pickerViewTitle.text = _title;
    switch (_pickerViewType)
    {
        case PickerViewTypeRefreshTime:
        {
            _pickerArray = [[NSMutableArray alloc] initWithObjects:
                            @"",
                            @"关闭自动刷新",
                            @"10秒",
                            @"30秒",
                            @"1分钟",
                            @"3分钟",
                            @"5分钟",
                            @"10分钟",
                            nil];
        }
            break;
        case PickerViewTypeCouresTime:
        {
            _pickerArray = [[NSMutableArray alloc] initWithObjects:
                            @"",
                            @"今天",
                            @"昨天",
                            @"前天",
                            @"本周",
                            @"本月",
                            @"自定义",
                            nil];
        }
            break;
        case PickerViewTypeHistoryTime:
        {
            _pickerArray = [[NSMutableArray alloc] initWithObjects:
                            @"",
                            @"今天",
                            @"昨天",
                            @"前天",
                            @"前一个小时",
                            @"自定义",
                            nil];
        }
            break;
        default:
            break;
    }
}


#pragma mark - Animation & Responder
- (IBAction)finishButtonDidPush:(id)sender
{
//    NSLog(@"string = %@",_timeString);
//    NSLog(@"row = %@",_rowOfPickerView);
    [self hideInView];
    
    if ([_rowOfPickerView isEqualToString:@"0"]) {
        return;
    }
    switch (_pickerViewType) {
        case PickerViewTypeRefreshTime:{
            if (_delegate &&[_delegate respondsToSelector:@selector(refreshFinishButtonDidPushWithcontentOfRow:)]) {
                [_delegate refreshFinishButtonDidPushWithcontentOfRow:_contentOfRow];
            }
        }
            break;
        case PickerViewTypeCouresTime:{
            if (_delegate &&[_delegate respondsToSelector:@selector(courseFinishButtonDidPushWithcontentOfRow:)]) {
                [_delegate courseFinishButtonDidPushWithcontentOfRow:_contentOfRow ];
            }
        }
        case PickerViewTypeHistoryTime:
        {
            if (_delegate &&[_delegate respondsToSelector:@selector(histotyFinishButtonDidPushWithcontentOfRow:)]) {
                [_delegate histotyFinishButtonDidPushWithcontentOfRow:_contentOfRow ];
            }
        }
        default:
            break;
    }
}

- (void)showInView:(UIView *)view
{
    [view addSubview:_backGroundView];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0,CGRectGetHeight([[UIScreen mainScreen] bounds])-268, CGRectGetWidth([[UIScreen mainScreen] bounds]), 268);
    }];
}

- (void)hideInView{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0,CGRectGetHeight([[UIScreen mainScreen] bounds]), CGRectGetWidth([[UIScreen mainScreen] bounds]), 268);
                     }
                     completion:^(BOOL finished){
                         [_backGroundView removeFromSuperview];
                     }];
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //_timeString = [_pickerArray objectAtIndex:row];
    _contentOfRow = [_pickerArray objectAtIndex:row];
    _rowOfPickerView = [NSString stringWithFormat:@"%ld",(long)row];
}


@end
