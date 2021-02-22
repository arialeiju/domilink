//
//  AKTimePicker.h
//  CarConnection
//
//  Created by 马真红 on 2020/10/23.
//  Copyright © 2020 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AKTimePicker : UIView
/**
 初始化方法
 @param startHour 其实时间点 时
 @param endHour 结束时间点 时
 @param period 间隔多少分中
 @param showtype 0代表普通模式 1代表被定时上报列表模式
 @param block 返回选中的时间
 @return QFTimePickerView实例
 */
- (instancetype)initDatePackerWithStartHour:(NSString *)startHour endHour:(NSString *)endHour period:(NSInteger)period showtype:(NSInteger)showtype response:(void (^)(NSString *))block;

//设置弹出的使时间
-(void)setShowRow:(NSString*)mDefaultTime;
- (void)show;
@end

NS_ASSUME_NONNULL_END
