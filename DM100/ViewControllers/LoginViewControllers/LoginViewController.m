//
//  LoginViewController.m
//  domilink
//
//  Created by 马真红 on 2020/2/11.
//  Copyright © 2020 aika. All rights reserved.
//

#import "LoginViewController.h"
#import "SelectionComboBox.h"
#import "UserLoginService.h"
#import "TabBarViewController.h"
#import "SwichLanguage.h"
#import "SwLanguagePop.h"
#import "SwServerPop.h"
#import <CloudPushSDK/CloudPushSDK.h>
@interface LoginViewController ()<UITextFieldDelegate, SelectionComboBoxDelegate,SwLanguagePopDelegate>
{
    MBProgressHUD * _HUD;
    SelectionComboBox *_selectionComboBox;
    BOOL isOpenNameList;
}
@end

@implementation LoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView) name:@"changeLanguage" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setBGImage];
    [self setLoginButtonRadius];
    [self updateView];
    isOpenNameList=NO;
    if (@available(iOS 11.0, *)) {
        self.passWordTextField.textContentType = UITextContentTypeName;
    }
    
    self.rememberPasswordButton.selected=self.inAppSetting.rememberPasswordState;
    if (self.rememberPasswordButton.selected) {
        self.passWordTextField.text=self.inAppSetting.password;
        NSLog(@"passWordTextField=%@",self.passWordTextField.text);
    }
    self.autoLoginButton.selected=self.inAppSetting.autoLoginState;
    
    
    //_userNameTextField.text = self.inAppSetting.usernameList[0];
    _userNameTextField.keyboardType=UIKeyboardTypeDefault;
    NSLog(@"self.inAppSetting.loginNo=%@",self.inAppSetting.loginNo);
    if ( self.inAppSetting.loginNo) {
        _userNameTextField.text = self.inAppSetting.loginNo;
    }
    //开始自动登录
    NSString *userName = _userNameTextField.text;
    NSString *password = _passWordTextField.text;
    if (self.autoLoginButton.selected&&userName.length>0&&password.length>0) {
       //等待编写自动登录操作
        NSLog(@"自动登录");
        [self startLoginByLoginNo:userName andPassword:password];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.view setFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
}
//设置j登陆按钮圆角
-(void)setLoginButtonRadius
{
    float theheight=self.loginButton.frame.size.height/20;
    [self.loginButton.layer setMasksToBounds:YES];
    [self.loginButton.layer setCornerRadius:theheight];
}

- (void)setBGImage//设置监听，关闭软键盘
{
    UITapGestureRecognizer * hideKeyBoardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHideWithTapGesture)];
    [_loginBGImageView addGestureRecognizer:hideKeyBoardGesture];
}

#pragma mark 键盘高度的监听
- (void)keyBoardShow:(NSNotification *)noti
{
    CGRect keyBoardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -((deltaY + 20) - (VIEWHEIGHT - CGRectGetMaxY(self.loginButton.frame))));
        //        self.view.transform = CGAffineTransformMakeTranslation(0, -(deltaY - (self.view.frame.size.height - self.loginButton.frame.origin.y - 60)));
    }];
}

- (void)keyBoardHide:(NSNotification *)noti
{
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (void)keyBoardHideWithTapGesture
{
    [self.userNameTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    
    if (_selectionComboBox)
    {
        [_selectionComboBox hide];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)clickRememberPassword:(UIButton*)sender {
    if (sender.selected) {
        sender.selected=NO;
        self.inAppSetting.rememberPasswordState=NO;
    }else
    {
        sender.selected=YES;
        self.inAppSetting.rememberPasswordState=YES;
    }
}

- (IBAction)clickAutoLogin:(UIButton*)sender {
    if (sender.selected) {
        sender.selected=NO;
        self.inAppSetting.autoLoginState=NO;
    }else
    {
        sender.selected=YES;
        self.inAppSetting.autoLoginState=YES;
    }
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameTextField)
    {
        [_passWordTextField becomeFirstResponder];
    }
    if (textField == _passWordTextField)
    {
        [_passWordTextField resignFirstResponder];
    }
    
    return YES;
}


#pragma mark - SelectionComboBoxDelegate
- (void)selectionCombox:(SelectionComboBox *)comboBox didDeleteRow:(NSArray *)usernameList
{
    self.inAppSetting.usernameList = usernameList;
}

- (void)selectionCombox:(SelectionComboBox *)comboBox didSelectedAt:(NSInteger)index
{
    NSArray *array = self.inAppSetting.usernameList;
    _userNameTextField.text = array[index];
    
    [comboBox hide];
}

-(void)startLoginByLoginNo:(NSString*)userName andPassword:(NSString*)password
{
    if ([userName isEqualToString:@""] || [password isEqualToString:@""]) {
        [MBProgressHUD showQuickTipWithText:@"请输入完整的账号密码"];
        return;
    }
    else
    {
        _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    
    self.inAppSetting.username = userName;
    self.inAppSetting.password = password;
    __block LoginViewController *weakSelf = self;
    [UserLoginService loginWithUserName:userName
                               password:password
                                succeed:^(UserLoginObject *loginObject)
     {
         [weakSelf->_HUD hide:YES];
         if (loginObject.type == -1)
         {
             [MBProgressHUD showQuickTipWIthTitle:@"登陆失败" withText:@"账号或密码错误"];
             return ;
         }

         
//         if (loginObject.imeiList.count==0) {
        
//             [MBProgressHUD showQuickTipWIthTitle:@"登陆失败" withText:@"没有数据"];
//             return ;
//         }else{
             
             // 保存登录用户名
             [self saveUserName:userName];
             self.inAppSetting.loginNo =[NSString stringWithFormat:@"%@", loginObject.loginNo];
             self.inAppSetting.userId = [NSString stringWithFormat:@"%@",loginObject.userId];
             self.inAppSetting.username= [NSString stringWithFormat:@"%@",loginObject.username];
             self.inAppSetting.type= [NSString stringWithFormat:@"%ld", (long)loginObject.type ];
             self.inAppSetting.password=weakSelf->_passWordTextField.text;
             self.inAppSetting.curloginNo=[NSString stringWithFormat:@"%@",loginObject.loginNo];
             self.inAppSetting.curuserId=[NSString stringWithFormat:@"%@",loginObject.userId];
             self.inAppSetting.curusername=[NSString stringWithFormat:@"%@",loginObject.username];
             
             [self bandingAliAccout:userName];
             //NSLog(@"登陆完成，打开页面");
             [self opeanTabView];
         }
      failure:^(NSError *error)
     {
         [weakSelf->_HUD hide:YES];
         [MBProgressHUD showQuickTipWIthTitle:@"网络错误" withText:@"请检查网络再尝试"];
         weakSelf.autoLoginButton.selected=NO;
         weakSelf.inAppSetting.autoLoginState=NO;
         
         NSLog(@"***userInfo***:%@", error.userInfo);
         // NSLog(@"***userInfo.allKeys***:%@", error.userInfo.allKeys);
         
     }];
}


- (void)saveUserName:(NSString *)username
{
    NSMutableArray *userNameList = [self.inAppSetting.usernameList mutableCopy];
    
    if ([userNameList containsObject:username])
    {
        return;
    }
    
    if (userNameList.count == 5)
    {
        NSMutableArray *newUserNameList = [NSMutableArray arrayWithObjects:username, nil];
        for (int i = 0; i < 4; i++)
        {
            [newUserNameList addObject:userNameList[i]];
        }
        userNameList = newUserNameList;
    }
    else
    {
        NSMutableArray *newUserNameList = [NSMutableArray arrayWithObjects:username, nil];
        for (NSString *string in userNameList)
        {
            [newUserNameList addObject:string];
        }
        userNameList = newUserNameList;
    }
    self.inAppSetting.usernameList = userNameList;
}
- (IBAction)loginButtonDidPush:(id)sender {
    [self.userNameTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    NSString *userName = _userNameTextField.text;
    NSString *password = _passWordTextField.text;
    [self startLoginByLoginNo:userName andPassword:password];
}
- (IBAction)usernameListButtonDo:(id)sender {
    if (isOpenNameList) {
        if (_selectionComboBox.hidden) {
            _selectionComboBox.hidden=NO;
            [_selectionComboBox showInView:self.view];
        }else
        {
            _selectionComboBox.hidden=YES;
            [_selectionComboBox removeFromSuperview];
        }
    }else
    {
        //        CGRect usernameList = CGRectMake(CGRectGetMinX(_userNameView.frame) + 40,
        //                                     CGRectGetMaxY(_userNameView.frame),
        //                                     CGRectGetWidth(_userNameView.frame) - 40,
        //                                     100);
        CGRect usernameList = CGRectMake(CGRectGetMinX(_userNameView.frame) + 40,
                                         CGRectGetMaxY(_userNameView.frame),
                                         CGRectGetWidth(_userNameView.frame) - 40-IPXMargin,
                                         100);
        
        NSArray *array = self.inAppSetting.usernameList;
        if (array.count != 0)
        {
            _selectionComboBox = [[SelectionComboBox alloc] initWithFrame:usernameList
                                                          withStringArray:array];
            _selectionComboBox.delegate = self;
            [_selectionComboBox showInView:self.view];
        }
        isOpenNameList=YES;
    }
}

// 视图被销毁
- (void)dealloc {
    NSLog(@"登陆界面销毁");
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)opeanTabView{
    
//    UITabBarController *rootTabBarController = [[TabBarViewController alloc] init];
//    [self presentViewController:rootTabBarController animated:YES completion:nil];
    self.inAppSetting.HadLogin=true;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ClickServerButton:(id)sender {
    [self showServerPopView];
}

- (IBAction)ClickChangeButton:(id)sender {
    //修改语言
//    NSString *language = [SwichLanguage userLanguage];
//
//    if ([language isEqualToString:@"en"]) {
//        [SwichLanguage setUserlanguage:@"zh-Hans"];
//    }else{
//        [SwichLanguage setUserlanguage:@"en"];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage"object:self];
    
    [self showPopView];
}
//更新语言，刷新见面
-(void)updateView
{
     //   [_changeButton setTitle:[[SwichLanguage bundle] localizedStringForKey:@"button"value:nil table:@"English"] forState:UIControlStateNormal];
    [_changeButton setTitle:[SwichLanguage getString:@"languageswitch"] forState:UIControlStateNormal];
    [_serverButton setTitle:[SwichLanguage getString:@"servertitle"] forState:UIControlStateNormal];
    [_loginButton setTitle:[SwichLanguage getString:@"login"] forState:UIControlStateNormal];
    [_label1 setText:[SwichLanguage getString:@"ck1"]];
    [_label2 setText:[SwichLanguage getString:@"ck2"]];
    [_userNameTextField setPlaceholder:[SwichLanguage getString:@"hit1"]];
    [_passWordTextField setPlaceholder:[SwichLanguage getString:@"hit2"]];
}

//显示语言选择框
-(void)showPopView
{
    SwLanguagePop * mSwLanguagePop = [[SwLanguagePop alloc]init];
    mSwLanguagePop.delegate=self;
    [mSwLanguagePop showInView:[UIApplication sharedApplication].keyWindow];
}

//显示服务器选择框
-(void)showServerPopView
{
    SwServerPop * mSwSeverPop = [[SwServerPop alloc]init];
    [mSwSeverPop showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - customPickerViewDelegate
- (void)didSelectedAtNormalRow:(int)row
{
    NSLog(@"didSelectedAtNormalRow=%d",row);
}

//绑定一下阿里推送的账号别名
-(void)bandingAliAccout:(NSString*)maccout
{
    if(maccout==nil)
    {
        return;
    }
    if (maccout.length>0) {
//        [CloudPushSDK bindAccount:maccout withCallback:^(CloudPushCallbackResult *res) {
//            if (res.success) {
//                NSLog(@"bindAccount  success");
//            } else {
//                NSLog(@"bindAccount  failed, error: %@", res.error);
//            }
//
//        }];//aika test
//        NSLog(@"isPushOk 2=%d",self.inAppSetting.isPushOk);
        if (self.inAppSetting.isPushOk) {
//            NSLog(@"isPush type =%@",self.inAppSetting.type);
//            NSLog(@"isPush loginNo =%@",self.inAppSetting.loginNo);
//            NSLog(@"isPush userId =%@",self.inAppSetting.userId);
//            NSLog(@"isPush userLanguageType =%d",[SwichLanguage userLanguageType]);
//            NSLog(@"isPush deviceid =%@",[CloudPushSDK getDeviceId]);
            
            NSDictionary *bodyData = @{@"osType":@"2",
                                       @"loginType":self.inAppSetting.type,
                                       @"loginNo":self.inAppSetting.loginNo,
                                       @"userId":self.inAppSetting.userId,
                                       @"pushId":[CloudPushSDK getDeviceId],
                                       @"language":[NSString stringWithFormat:@"%d",[SwichLanguage userLanguageType]],
                                       @"pushMode":@"1"
                                        };
            NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:800
                                                                withParameters:bodyData];
            [NetWorkModel POST:ServerURL
                    parameters:parameters
                       success:^(ResponseObject *messageCenterObject)
             {
                 NSDictionary *ret = messageCenterObject.ret;
                NSLog(@"800返回=%@",ret);
                int mretcode=[[ret objectForKey:@"retCode" ] intValue];
                 if (mretcode==1) {

                     NSLog(@"绑定成功");
                 }else
                 {
                     NSString* msgstr=(NSString *)[messageCenterObject.ret objectForKey:@"retMsg"];
                     if (msgstr.length==0) {
                         [MBProgressHUD showQuickTipWIthTitle:@"绑定推送服务失败" withText:nil];
                     }else
                     {
                         [MBProgressHUD showQuickTipWIthTitle:msgstr withText:nil];
                     }
                 }
             }
                       failure:^(NSError *error)
             {
                //[MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"绑定推送服务失败2"] withText:nil];
             }];
        }
    }
}
@end
