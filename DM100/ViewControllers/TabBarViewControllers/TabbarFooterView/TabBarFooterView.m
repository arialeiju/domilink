//
//  TabBarFooterView.m
//  CarConnection
//
//  Created by Horace.Yuan on 15/3/31.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "TabBarFooterView.h"
@implementation TabBarFooterView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TabBarFooterView" owner:self options:nil] firstObject];
    if (self)
    {
        if(KIsiPhoneX)
        {
            CGRect framenew= CGRectMake(0,
                                        frame.origin.y-20,
                                        frame.size.width,
                                        frame.size.height+20);
             [self setFrame:framenew];
        }else
        {
            [self setFrame:frame];
        }
        //[self addLine];
        [_mainViewButton setSelected:YES];
        UIColor* mselect=[_mainViewButton titleColorForState:UIControlStateSelected];
        [_mtv1 setTextColor:mselect];
    }
    return self;
}

- (void)addLine
{
    for (int i = 0; i < 3; i++)
    {
        CGRect lineFrame = CGRectMake(CGRectGetWidth(self.frame)/4 * (1+i),
                                      8,
                                      0.5,
                                      33);
        UIView *line = [[UIView alloc] initWithFrame:lineFrame];
        [line setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]];
        [self addSubview:line];
    }
}

- (IBAction)mainViewButtonDo:(id)sender
{
    [self resetAllButton];
    [_mainViewButton setSelected:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarFooterViewButtonDidSelected:)])
    {
        [_delegate tabBarFooterViewButtonDidSelected:0];
    }
}

- (IBAction)carViewButtonDo:(id)sender
{
    [self resetAllButton];
    [_carViewButton setSelected:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarFooterViewButtonDidSelected:)])
    {
        [_delegate tabBarFooterViewButtonDidSelected:1];
    }
}

- (IBAction)mineViewButtonDo:(id)sender
{
    [self resetAllButton];
    [_mineViewButton setSelected:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarFooterViewButtonDidSelected:)])
    {
        [_delegate tabBarFooterViewButtonDidSelected:2];
    }
}

- (IBAction)settingViewButtonDo:(id)sender
{
    [self resetAllButton];
    [_settingViewButton setSelected:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarFooterViewButtonDidSelected:)])
    {
        [_delegate tabBarFooterViewButtonDidSelected:3];
    }
}

- (void)resetAllButton
{
    [_mainViewButton setSelected:NO];
    [_carViewButton setSelected:NO];
    [_mineViewButton setSelected:NO];
    [_settingViewButton setSelected:NO];
    UIColor* mnormal=[_mainViewButton titleColorForState:UIControlStateNormal];
    [_mtv1 setTextColor:mnormal];
    [_mtv2 setTextColor:mnormal];
    [_mtv3 setTextColor:mnormal];
    [_mtv4 setTextColor:mnormal];
}


- (void)setSelected:(NSInteger)index
{
    [self resetAllButton];
    UIColor* mselect=[_mainViewButton titleColorForState:UIControlStateSelected];
    switch (index)
    {
        case 0:
            [_mainViewButton setSelected:YES];
            [_mtv1 setTextColor:mselect];
            break;
        case 1:
            [_carViewButton setSelected:YES];
            [_mtv2 setTextColor:mselect];
            break;
        case 2:
            [_mineViewButton setSelected:YES];
            [_mtv3 setTextColor:mselect];
            break;
        case 3:
            [_settingViewButton setSelected:YES];
            [_mtv4 setTextColor:mselect];
            break;
        default:
            break;
    }
}

//更新语言，刷新见面
-(void)updateView
{
    [_mtv1 setText:[SwichLanguage getString:@"menu1"]];
    [_mtv2 setText:[SwichLanguage getString:@"menu2"]];
    [_mtv3 setText:[SwichLanguage getString:@"pg2mt2"]];
    [_mtv4 setText:[SwichLanguage getString:@"menu4"]];
}
@end
