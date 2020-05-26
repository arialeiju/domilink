//
//  CarListTableCell.h
//  domilink
//
//  Created by 马真红 on 2020/2/16.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarListTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *bt1;
@property (weak, nonatomic) IBOutlet UIButton *bt2;
@property (weak, nonatomic) IBOutlet UIButton *bt3;
@property (weak, nonatomic) IBOutlet UILabel *tvname;
@property (weak, nonatomic) IBOutlet UILabel *tvstatus;
@property (weak, nonatomic) IBOutlet UILabel *tvtime;
@property (weak, nonatomic) IBOutlet UIImageView *imgstatus;

@end

NS_ASSUME_NONNULL_END
