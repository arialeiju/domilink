//
//  SettingViewController.h
//  domilink
//
//  Created by 马真红 on 2020/2/16.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *kContentView;
@property (weak, nonatomic) IBOutlet UIButton *bt1;
@property (weak, nonatomic) IBOutlet UIButton *bt2;
@property (weak, nonatomic) IBOutlet UIButton *bt3;
@property (weak, nonatomic) IBOutlet UIButton *bt4;
- (IBAction)clickbt1:(id)sender;
- (IBAction)clickbt2:(id)sender;
- (IBAction)clickbt3:(id)sender;
- (IBAction)clickbt4:(id)sender;
- (id)initWithImei:(NSString *)mimei anddevicetype:(NSString*)mdevicetype;
@end

NS_ASSUME_NONNULL_END
