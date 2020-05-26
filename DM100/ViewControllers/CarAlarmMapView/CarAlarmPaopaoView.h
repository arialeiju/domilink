//
//  CarAlarmPaopaoView.h
//  CarConnection
//
//  Created by 林张宇 on 15/5/22.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CarAlarmPaopaoView;

@protocol CarAlarmPaopaoViewDelegate <NSObject>

- (void)carAlarmPaopaoViewCloseButtonDidPush;

@end

@interface CarAlarmPaopaoView : UIView

@property (weak, nonatomic) id<CarAlarmPaopaoViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *imeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *accLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmType;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;

- (void)setAddressText:(NSString *)text;

@end
