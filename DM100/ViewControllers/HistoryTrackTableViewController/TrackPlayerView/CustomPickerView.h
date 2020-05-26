//
//  CustomPickerView.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/4/21.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPickerView;

@protocol CustomPickerViewDelegate <NSObject>

- (void)customPickerView:(CustomPickerView *)pickerView didSelectRow:(NSInteger)row;

@end

@interface CustomPickerView : UIView
@property (weak, nonatomic) id<CustomPickerViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (id)initWithSelection:(NSArray *)selection;
- (void)setPickerViewSelectedIndex:(NSInteger)index;
- (void)showInView:(UIView *)view;
- (void)hide;

@end
