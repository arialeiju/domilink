//
//  OnlinePopView.h
//  HolyConsultCircle
//
//  Created by 马真红 on 15/8/5.
//  Copyright (c) 2015年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlinePopView : UIView<UITextFieldDelegate>
- (void)showInView:(UIView *)view andImei:(NSString*)mimei andImeiName:(NSString*)mimeiname;
-(void)hide;
@end
