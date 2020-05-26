//
//  SelectionComboBoxCell.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/6/15.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SelectionComboBoxCellHeight 30

@class SelectionComboBoxCell;
@protocol SelectionComboBoxCellDelegate <NSObject>

- (void)selectionComboBoxCellCloseButtonDidPush:(SelectionComboBoxCell *)cell;
- (void)selectionComboBoxCellDidSelected:(SelectionComboBoxCell *)cell;

@end

@interface SelectionComboBoxCell : UIView

@property (weak, nonatomic) id<SelectionComboBoxCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (id)initWithFrame:(CGRect)frame
         withString:(NSString *)string;

@end
