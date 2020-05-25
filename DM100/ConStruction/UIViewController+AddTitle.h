//
//  UIViewController+AddTitle.h
//  VideoOnline
//
//  Created by Goman on 14-12-16.
//  Copyright (c) 2014年 Goman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AddTitle)

-(UILabel *)addTitleView:(NSString *) title withLeftButton:(UIButton *) leftButton andRightButton:(UIButton *) rightButtion;

- (void)initNavigationBar:(NSString *) title;

- (void)addBackButtonTitleWithTitle:(NSString *)title;

- (void)addBackButtonTitleWithTitle:(NSString *)title withRightButton:(UIButton *)rightButtion;

@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UILabel * titleLabel;

@end
