//
//  PickerView.h
//  CarConnection
//
//  Created by 林张宇 on 15/4/2.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PickerViewHeight 268

@protocol pickerViewDelegate <NSObject>

@optional
- (void)refreshFinishButtonDidPushWithcontentOfRow:(NSString *)contentOfRow;
- (void)courseFinishButtonDidPushWithcontentOfRow:(NSString *)contentOfRow;
- (void)histotyFinishButtonDidPushWithcontentOfRow:(NSString *)contentOfRow;
@end

typedef enum : NSUInteger {
    PickerViewTypeRefreshTime,
    PickerViewTypeCouresTime,
    PickerViewTypeHistoryTime
} PickerViewType;

@interface PickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak ,nonatomic) id<pickerViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *pickerViewTitle;


/**
 @brief 根据类型初始化选择器
 @param pickViewType  PickViewTypeRefreshTime or PickViewTypeCouresTime
 */
- (id)initWithTitle:(NSString *)title
       PickViewType:(PickerViewType)pickerViewType;
- (void)showInView:(UIView *)view;
- (void)hideInView;


@end
