//
//  TabBarFooterView.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/3/31.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarFooterViewDelegate <NSObject>

- (void)tabBarFooterViewButtonDidSelected:(NSInteger)index;

@end

@interface TabBarFooterView : UIView

@property (strong, nonatomic) IBOutlet UIButton *mainViewButton;
@property (strong, nonatomic) IBOutlet UIButton *carViewButton;
@property (strong, nonatomic) IBOutlet UIButton *mineViewButton;
@property (strong, nonatomic) IBOutlet UIButton *settingViewButton;
@property (weak, nonatomic) IBOutlet UILabel *mtv1;
@property (weak, nonatomic) IBOutlet UILabel *mtv2;
@property (weak, nonatomic) IBOutlet UILabel *mtv3;
@property (weak, nonatomic) IBOutlet UILabel *mtv4;

@property (weak, nonatomic) id<TabBarFooterViewDelegate> delegate;

- (void)setSelected:(NSInteger)index;
-(void)updateView;
@end
