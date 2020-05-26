//
//  BusPointCell.h
//  CarConnection
//
//  Created by 马真红 on 15/10/10.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusPointCell : UIView
@property (weak, nonatomic) IBOutlet UILabel *stoptime;
@property (weak, nonatomic) IBOutlet UILabel *starttime;
@property (weak, nonatomic) IBOutlet UILabel *endtime;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end
