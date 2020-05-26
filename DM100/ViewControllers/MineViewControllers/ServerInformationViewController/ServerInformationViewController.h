//
//  ServerInformationViewController.h
//  CarConnection
//
//  Created by 林张宇 on 15/4/21.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerInformationViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UITableView *serverInformationTableView;
@property (strong,nonatomic) NSMutableArray * serverInformationArray;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkManLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (void)setInformationArray:(NSMutableArray *)array;
@end
