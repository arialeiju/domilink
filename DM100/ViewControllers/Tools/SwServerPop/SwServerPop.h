//
//  SwSeverPop.h
//  DM100
//
//  Created by 马真红 on 2021/8/2.
//  Copyright © 2021 aika. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwServerPop : UIView
@property (weak, nonatomic) IBOutlet UIButton *surebutton;
@property (weak, nonatomic) IBOutlet UIButton *cancelbutton;
@property (weak, nonatomic) IBOutlet UIButton *ck1button;
@property (weak, nonatomic) IBOutlet UIButton *ck2button;
- (void)showInView:(UIView *)view;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
