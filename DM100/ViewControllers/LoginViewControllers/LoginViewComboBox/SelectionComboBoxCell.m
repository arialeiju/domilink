//
//  SelectionComboBoxCell.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/6/15.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "SelectionComboBoxCell.h"

@implementation SelectionComboBoxCell
{
    CGRect _frame;
}

- (id)initWithFrame:(CGRect)frame
         withString:(NSString *)string
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SelectionComboBoxCell" owner:self options:nil] firstObject];
    if (self)
    {
        self.frame = frame;
        _frame = frame;
        _titleLabel.text = string;
        [self addGesture];
    }
    return self;
}

- (void)layoutSubviews
{
    self.frame = _frame;
}

- (void)addGesture
{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectionTapDo)];
    [_titleLabel addGestureRecognizer:tapGes];
    [_titleLabel setUserInteractionEnabled:YES];
}

- (void)selectionTapDo
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectionComboBoxCellDidSelected:)])
    {
        [_delegate selectionComboBoxCellDidSelected:self];
    }
}

- (IBAction)closeButtonDidPush:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectionComboBoxCellCloseButtonDidPush:)])
    {
        [_delegate selectionComboBoxCellCloseButtonDidPush:self];
    }
}


@end
