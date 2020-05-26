//
//  CarAlarmPaopaoView.m
//  CarConnection
//
//  Created by 林张宇 on 15/5/22.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "CarAlarmPaopaoView.h"

@implementation CarAlarmPaopaoView


- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CarAlarmPaopaoView" owner:nil options:nil]firstObject];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setupView
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    _label1.adjustsFontSizeToFitWidth=YES;
    _label2.adjustsFontSizeToFitWidth=YES;
    _label3.adjustsFontSizeToFitWidth=YES;
    _label4.adjustsFontSizeToFitWidth=YES;
    _label5.adjustsFontSizeToFitWidth=YES;
    [_label1 setText:[SwichLanguage getString:@"popt1"]];
    [_label2 setText:[SwichLanguage getString:@"popt2"]];
    [_label4 setText:[SwichLanguage getString:@"popt4"]];
    [_label5 setText:[SwichLanguage getString:@"popt5"]];
}


- (void)setAddressText:(NSString *)text
{
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                     NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13.0f]};
    
    CGFloat height = [self.dataModel heightForText:text
                                         withWidth:CGRectGetWidth(_addressLabel.frame)
                                        withHeight:200
                                withTextAttributes:textAttributes];
    
    _addressLabel.text = text;
    CGRect newAddressLabelFrame = _addressLabel.frame;
    newAddressLabelFrame.size.height = height;
    [_addressLabel setFrame:newAddressLabelFrame];
    
    CGRect newViewFrame = self.frame;
    newViewFrame.size.height = CGRectGetMaxY(_addressLabel.frame) + 10;
    [self setFrame:newViewFrame];
}


- (IBAction)closeButtonDo:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(carAlarmPaopaoViewCloseButtonDidPush)])
    {
        [_delegate carAlarmPaopaoViewCloseButtonDidPush];
    }
}


@end
