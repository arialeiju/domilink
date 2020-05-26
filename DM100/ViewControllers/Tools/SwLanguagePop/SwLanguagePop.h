//
//  SwLanguagePop.h
//  domilink
//
//  Created by 马真红 on 2020/2/14.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SwLanguagePop;

@protocol SwLanguagePopDelegate <NSObject>
/// 选择一般行回调
- (void)didSelectedAtNormalRow:(int)row;
@end
@interface SwLanguagePop : UIView
@property (weak, nonatomic) id<SwLanguagePopDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *surebutton;
@property (weak, nonatomic) IBOutlet UIButton *cancelbutton;
@property (weak, nonatomic) IBOutlet UIButton *ck1button;
@property (weak, nonatomic) IBOutlet UIButton *ck2button;
- (void)showInView:(UIView *)view;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
