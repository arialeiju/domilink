//
//  UIViewController+AddTitle.m
//  VideoOnline
//
//  Created by Goman on 14-12-16.
//  Copyright (c) 2014年 Goman. All rights reserved.
//

#import "UIViewController+AddTitle.h"
#import "UIColor+Hexstring.h"
#import <objc/runtime.h>

#define kTitleColorHex   @"#1C1E1D"
#define KBackButtonName  @"back_btn.png"

@implementation UIViewController (AddTitle)

static void * TitleViewKey = (void *)@"TitleViewKey";
static void * TitleLabelKey = (void *)@"TitleLabelKey";

- (void)setTitleLabel:(UILabel *)titleLabel
{
    objc_setAssociatedObject(self, TitleLabelKey, titleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)titleLabel
{
    return objc_getAssociatedObject(self, TitleLabelKey);
}

- (void)setTitleView:(UIView *)titleView
{
    objc_setAssociatedObject(self, TitleViewKey, titleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)titleView
{
    return objc_getAssociatedObject(self, TitleViewKey);
}

-(UILabel *) addTitleView:(NSString *) title withLeftButton:(UIButton *) leftButton andRightButton:(UIButton *) rightButtion
{
//    CALayer* aheader = [[CALayer alloc]init];
//    [aheader setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, NAVBARHEIGHT)];
//    UIImage* img = [UIImage imageNamed:@"homeNavBarBg"];
//    aheader.contents = (id)img.CGImage;
//    [self.view.layer addSublayer:aheader];
    
    float KIsiPhoneXheight=KIsiPhoneX?20:0;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              CGRectGetWidth([[UIScreen mainScreen] bounds]),
                                                              NAVBARHEIGHT+KIsiPhoneXheight)];
    [header setBackgroundColor:[UIColor colorWithHexString:kTitleColorHex]];
    [self.view addSubview:header];
    
    //#标题
    UILabel * aLB = [[UILabel alloc]initWithFrame:CGRectMake(60, IOS7DELTA+KIsiPhoneXheight, header.frame.size.width - 120, 44)];

    aLB.backgroundColor = [UIColor clearColor];
    aLB.textAlignment = NSTextAlignmentCenter;
    aLB.textColor = [UIColor whiteColor];
    
    aLB.font=[UIFont systemFontOfSize:19.0];
    aLB.text = title;
    
    // 自动调整关闭
    if (IOS7LATER)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 添加按钮
    if(leftButton != nil)
    {
        [leftButton sizeToFit];
        leftButton.frame = CGRectMake(10, IOS7DELTA+KIsiPhoneXheight, CGRectGetWidth(leftButton.frame), 44);
        [header addSubview:leftButton];
    }
    
    if(rightButtion != nil)
    {
        [rightButtion sizeToFit];
        rightButtion.frame = CGRectMake(VIEWWIDTH - CGRectGetWidth(rightButtion.frame) - 10, IOS7DELTA+KIsiPhoneXheight, CGRectGetWidth(rightButtion.frame), 44);
        [header addSubview:rightButtion];
    }
    [header addSubview:aLB];
    
    self.titleLabel = aLB;
    self.titleView = header;
    
    
    return aLB;
}

- (void)initNavigationBar:(NSString *) title
{
    UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 45, 60)];
    titleLable.text = title;
    titleLable.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    titleLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLable;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.27 green:0.29 blue:0.33 alpha:1.0];
    
    UIBarButtonItem * backStep = [[UIBarButtonItem alloc]initWithTitle:[SwichLanguage getString:@"back"] style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.backBarButtonItem = backStep;
}

// 改进版
- (void)addBackButtonTitleWithTitle:(NSString *)title
{
    [self addBackButtonTitleWithTitle:title withRightButton:nil];
}

- (void)addBackButtonTitleWithTitle:(NSString *)title withRightButton:(UIButton *)rightButtion
{
    // backButton
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, IOS7DELTA,
                                    80, 44)];
    [backButton setImage:[UIImage imageNamed:@"back_btn.png"]
                forState:UIControlStateNormal];
    [backButton setTitle:[SwichLanguage getString:@"back"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton setFrame:CGRectMake(10,
                                    IOS7DELTA,
                                    CGRectGetWidth(backButton.frame),
                                    44)];
    [backButton addTarget:self action:@selector(backButtonDo:) forControlEvents:UIControlEventTouchUpInside];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    
    // 产生title
    [self addTitleView:title withLeftButton:backButton andRightButton:rightButtion];
}


- (void)backButtonDo:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
