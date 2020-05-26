//
//  SelectionComboBox.h
//  CarConnection
//
//  Created by Horace.Yuan on 15/6/15.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectionComboBox;
@protocol SelectionComboBoxDelegate <NSObject>

- (void)selectionCombox:(SelectionComboBox *)comboBox
          didSelectedAt:(NSInteger)index;
- (void)selectionCombox:(SelectionComboBox *)comboBox
           didDeleteRow:(NSArray *)usernameList;

@end

@interface SelectionComboBox : UIView

@property (weak, nonatomic) id<SelectionComboBoxDelegate> delegate;
- (id)initWithFrame:(CGRect)frame
    withStringArray:(NSArray *)selections;
- (void)showInView:(UIView *)view;
- (void)hide;

@end
