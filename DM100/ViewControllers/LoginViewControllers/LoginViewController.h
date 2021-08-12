//
//  LoginViewController.h
//  domilink
//
//  Created by 马真红 on 2020/2/11.
//  Copyright © 2020 aika. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *loginBGImageView;

@property (weak, nonatomic) IBOutlet UIView *userNameView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userNameImageView;
@property (weak, nonatomic) IBOutlet UIView *passWordView;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *passWordImageView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *rememberPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *autoLoginButton;
- (IBAction)clickRememberPassword:(UIButton*)sender;
- (IBAction)clickAutoLogin:(UIButton*)sender;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *serverButton;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
- (IBAction)ClickChangeButton:(id)sender;
- (IBAction)ClickServerButton:(id)sender;
@end

NS_ASSUME_NONNULL_END
