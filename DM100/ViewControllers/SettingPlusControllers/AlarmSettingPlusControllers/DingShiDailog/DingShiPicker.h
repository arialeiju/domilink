//
//  DingShiPicker.h
//  CarConnection
//
//  Created by 马真红 on 2020/10/26.
//  Copyright © 2020 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DingShiPicker : UIView
/**
 初始化方法
 @param startHour 选中时间点
 @param block 返回选中的时间
 @return QFTimePickerView实例
 */
- (instancetype)initDatePackerWithStartHour:(NSString *)startHour response:(void (^)(NSString *))block;
- (void)show;
@end

NS_ASSUME_NONNULL_END
