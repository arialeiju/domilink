//
//  MediaPlayViewController.h
//  CarConnection
//
//  Created by 马真红 on 2018/8/31.
//  Copyright © 2018年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshableTableView.h"
@interface MediaPlayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet RefreshableTableView *messageCenterTableView;
@property (strong, nonatomic) NSString * messagePage;
@property (strong, nonatomic) NSMutableArray * messageArray;
-(id)initWithImei:(NSString *)mimei anddevicetype:(NSString*)mdevicetype andImeiName:(NSString *)mImeiName;
@end
