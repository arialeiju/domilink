//
//  CustomPickerView.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/21.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "CustomPickerView.h"
#define AnimationDuration 0.2f

@interface CustomPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIView *_background;
    NSArray *_selectionArray;
}
@end

@implementation CustomPickerView

@synthesize delegate = _delegate;

- (id)initWithSelection:(NSArray *)selection
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomPickerView"
                                          owner:self
                                        options:nil] firstObject];
    if (self)
    {
        _selectionArray = [NSArray arrayWithArray:selection];
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    self.frame = CGRectMake(0,
                            VIEWHEIGHT,
                            VIEWWIDTH,
                            CGRectGetHeight(self.frame));
    [self.confirmButton setTitle:[SwichLanguage getString:@"sure"] forState:UIControlStateNormal];
    [self.titleLabel setText:[SwichLanguage getString:@"dailog4T"]];
}

#pragma mark - Setter
- (void)setPickerViewSelectedIndex:(NSInteger)index
{
    [_pickerView selectRow:index inComponent:0 animated:NO];
}


#pragma mark - PickerView Delegate & DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_selectionArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_selectionArray objectAtIndex:row];
}

#pragma mark - ButtonDo
- (IBAction)confirmButtonDo:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(customPickerView:didSelectRow:)])
    {
        [_delegate customPickerView:self didSelectRow:[_pickerView selectedRowInComponent:0]];
    }
    [self hide];
}

#pragma mark - Method
- (void)showInView:(UIView *)view
{
    if (_background == nil)
    {
        _background = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_background setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
        [_background.layer setOpacity:0.0f];
    }
    [_background addSubview:self];
    [view addSubview:_background];
    [UIView animateWithDuration:AnimationDuration
                     animations:^
    {
        [_background.layer setOpacity:1.0f];
        [self setFrame:CGRectMake(0,
                                  VIEWHEIGHT-CGRectGetHeight(self.frame),
                                  VIEWWIDTH,
                                  CGRectGetHeight(self.frame))];
    }
                     completion:^(BOOL finished)
    {
        UITapGestureRecognizer *closeTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_background addGestureRecognizer:closeTapGes];
    }];
}

- (void)hide
{
    [UIView animateWithDuration:AnimationDuration
                     animations:^
    {
        [_background.layer setOpacity:0.0f];
        [self setFrame:CGRectMake(0,
                                  VIEWHEIGHT,
                                  VIEWWIDTH,
                                  CGRectGetHeight(self.frame))];
    }
                     completion:^(BOOL finished)
    {
        [self removeFromSuperview];
        [_background removeFromSuperview];
    }];
}

@end
