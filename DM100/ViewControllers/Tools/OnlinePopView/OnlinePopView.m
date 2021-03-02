//
//  OnlinePopView.m
//  HolyConsultCircle
//
//  Created by 马真红 on 15/8/5.
//  Copyright (c) 2015年 zxd. All rights reserved.
//

#import "OnlinePopView.h"
#import "OnlineCMDService.h"
@implementation OnlinePopView
{
    UIView *_backgroundView;
    __weak IBOutlet UIButton *sendbutton;
    __weak IBOutlet UIButton *cancelbutton;
    __weak IBOutlet UILabel *title;
    __weak IBOutlet UILabel *devicename;
    __weak IBOutlet UITextField *second_text;
    __weak IBOutlet UITextField *password_text;
    NSString* _imei;
    NSString* _imeiname;
    BOOL isopenKeyboard;
    MBProgressHUD * _HUD;
    __weak IBOutlet UILabel *tv1;
    __weak IBOutlet UILabel *tv2;
    __weak IBOutlet UILabel *tv3;
}
- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"OnlinePopView"
                                          owner:self
                                        options:nil] firstObject];
    if (self)
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0f;
        
        [cancelbutton addTarget:self
                          action:@selector(hide)
                forControlEvents:UIControlEventTouchUpInside];
        [cancelbutton setBackgroundColor:[UIColor colorWithHexString:@"#00B7EE"]];
        
        [sendbutton addTarget:self
                         action:@selector(sendbutton)
               forControlEvents:UIControlEventTouchUpInside];
        [sendbutton setBackgroundColor:[UIColor colorWithHexString:@"#00B7EE"]];
        
        [title setBackgroundColor:[UIColor colorWithHexString:@"#00B7EE"]];
        isopenKeyboard=false;
        
        second_text.keyboardType=UIKeyboardTypeNumberPad;
        second_text.delegate=self;
        [second_text addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];//限制输入长度的方法//最优
    }
    return self;
}


- (void)showInView:(UIView *)view andImei:(NSString*)mimei andImeiName:(NSString*)mimeiname{
    [self addNotification];
    if (_backgroundView == nil)
    {
        _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        _backgroundView.layer.opacity = 0.0f;
        
        UITapGestureRecognizer *tagGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickbackgroud)];
        [_backgroundView addGestureRecognizer:tagGes];
    }
    _imei=mimei;
    _imeiname=mimeiname;
    [self updatelangue];
    if (_imei==nil||[_imei isEqualToString:@""]) {
        devicename.text=[NSString stringWithFormat:@"%@:%@",[SwichLanguage getString:@"device"],_imei];
    }else
    {
        devicename.text=[NSString stringWithFormat:@"%@:%@",[SwichLanguage getString:@"device"],_imeiname];
    }
    self.center = CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2 + 100);
    [_backgroundView addSubview:self];
    [view addSubview:_backgroundView];
    
    // animitaion
    [UIView animateWithDuration:0.25
                     animations:^
     {
         _backgroundView.layer.opacity = 1.0f;
         _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
         self.center = CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2);
     }];
}

-(void)updatelangue
{
    [sendbutton setTitle:[SwichLanguage getString:@"send"] forState:UIControlStateNormal];
    [cancelbutton setTitle:[SwichLanguage getString:@"cancel"] forState:UIControlStateNormal];
    [tv1 setText:[SwichLanguage getString:@"jtdltv1"]];
    [tv2 setText:[SwichLanguage getString:@"jtdltv2"]];
    [tv3 setText:[SwichLanguage getString:@"jtdltv3"]];
    [title setText:[SwichLanguage getString:@"jtdltitle"]];
    [tv1 sizeToFit];
    [tv2 sizeToFit];
    tv3.adjustsFontSizeToFitWidth=YES;
}

-(void)clickbackgroud
{
    if (isopenKeyboard==true) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
}
-(void)sendbutton
{
    [self clickbackgroud];
    
    if (second_text.text.length==0) {
         [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"tips"] withText:[SwichLanguage getString:@"jtdlerror1"]];
        return;
    }
    int secondno=[[NSString stringWithFormat:@"%@" ,second_text.text ] intValue];
    if (secondno<3||secondno>300) {
        [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"tips"] withText:[SwichLanguage getString:@"jtdlerror2"]];
        return;
    }
    if (![password_text.text isEqualToString:self.inAppSetting.password]) {
        [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"tips"] withText:[SwichLanguage getString:@"jtdlerror3"]];
        return;
    }
    
    
    NSString* smscmd=[NSString stringWithFormat:@"JT,%@",second_text.text];
    
    [self SendTheCMDToDeviceby:smscmd];
    
    
}
- (void)hide
{
    [UIView animateWithDuration:0.25
                     animations:^
     {
         _backgroundView.layer.opacity = 0.0f;
         _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
         self.center = CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2+100);
     }
                     completion:^(BOOL finished)
     {
         [self removeFromSuperview];
         [_backgroundView removeFromSuperview];
         [self removeNotification];
     }];
}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         [self setCenter:CGPointMake(VIEWWIDTH/2,
                                                     VIEWHEIGHT-CGRectGetHeight(keyboardFrame)-CGRectGetHeight(self.frame)/2-20)];
                     }];
    isopenKeyboard=true;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         [self setCenter:CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2)];
                     }];
    isopenKeyboard=false;
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==second_text) {
        return [self validateNumber:string];
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (void)textFieldDidChange//限制输入长度的方法
{
    if (second_text.text.length > 4) {
            second_text.text = [second_text.text substringToIndex:3];
        }
}


-(void) SendTheCMDToDeviceby:(NSString*)cmd
{
    NSLog(@"SendTheCMDToDeviceby mcmd=%@",cmd);
    _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [OnlineCMDService
     setCMDwithImei:_imei withSmscmd:cmd succeed:^(OnlineCMDObject *onlineCMDObject) {
        [_HUD hide:YES];
         //[MBProgressHUD showQuickTipWithText:onlineCMDObject.smscmd];
         int resultCode= [onlineCMDObject.result intValue];
         NSLog(@"onlineCMDObject.result=%@",onlineCMDObject.result);
         NSLog(@"onlineCMDObject.content=%@",onlineCMDObject.content);

         switch (resultCode) {
             case 0:
                 [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror0"] Title:nil];
                 break;
             case 1:
                 if (onlineCMDObject.content.length>0) {
                     if([onlineCMDObject.smscmd isEqualToString:@"VERSION"])
                     {
                         NSString * newstr=[onlineCMDObject.content stringByReplacingOccurrencesOfString:@";" withString:@"\r\n"];
                         [self ShowTheResultDailog:newstr Title:[SwichLanguage getString:@"detailitem8"]];
                     }else if([onlineCMDObject.smscmd isEqualToString:@"PARAM"])
                     {
                         if([onlineCMDObject.content  rangeOfString:@"success:"].location !=NSNotFound)//_roaldSearchText
                         {
                             onlineCMDObject.content=[onlineCMDObject.content substringFromIndex:8];
                         }
                         //onlineCMDObject.content=[onlineCMDObject.content stringByReplacingOccurrencesOfString:@"success" withString:@""];
                         NSArray *array= [onlineCMDObject.content componentsSeparatedByString:@";"];
                         //NSLog(@"onlineCMDObject.content=%@",onlineCMDObject.content);
                         if (array.count>0) {
                             NSString* content=@"";
                             for (NSString *dic in array)
                             {
                                 //NSLog(@"dic=%@",dic);
                                 content=[content stringByAppendingString:[NSString stringWithFormat:@"%@\r\n",dic]];
                                 //NSLog(@"content=%@",content);
                             }
                             [self ShowTheResultDailog:content Title:[SwichLanguage getString:@"online2"]];
                         }else
                         {
                            [self ShowTheResultDailog:onlineCMDObject.content Title:[SwichLanguage getString:@"online2"]];
                         }
                     }else if([onlineCMDObject.smscmd isEqualToString:@"STATUS"])
                     {
                         if([onlineCMDObject.content  rangeOfString:@"success:"].location !=NSNotFound)//_roaldSearchText
                         {
                             onlineCMDObject.content=[onlineCMDObject.content substringFromIndex:8];
                         }
                         NSArray *array= [onlineCMDObject.content componentsSeparatedByString:@";"];
                         //NSLog(@"onlineCMDObject.content=%@",onlineCMDObject.content);
                         if (array.count>0) {
                             NSString* content=@"";
                             for (NSString *dic in array)
                             {
                                 //NSLog(@"dic=%@",dic);
                                 content=[content stringByAppendingString:[NSString stringWithFormat:@"%@\r\n",dic]];
                                 //NSLog(@"content=%@",content);
                             }
                             [self ShowTheResultDailog:content Title:[SwichLanguage getString:@"online3"]];
                         }else
                         {
                             [self ShowTheResultDailog:onlineCMDObject.content Title:[SwichLanguage getString:@"online3"]];
                         }
                     }else if([onlineCMDObject.smscmd isEqualToString:@"123"])
                     {
                         [self ShowTheResultDailog:onlineCMDObject.content Title:[SwichLanguage getString:@"online4"]];
                     }else if([onlineCMDObject.smscmd rangeOfString:@"CENTER"].location!=NSNotFound)
                     {
                         [self ShowTheResultDailog:onlineCMDObject.content Title:nil];
                     }else
                     {
                         [self ShowTheResultDailog:onlineCMDObject.content Title:nil];
                     }
                 }else
                 {
                     [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror1"] Title:nil];
                 }
                 break;
             case 2:
                   [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror2"] Title:nil];
                 break;
             case 3:
                  [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror3"] Title:nil];
                 break;
             case 4:
                 [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror4"] Title:nil];
                 break;
             case 5:
                 [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror5"] Title:nil];
                 break;
             case 6:
                 [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror6"] Title:nil];
                 break;
             default:
                 [self ShowTheResultDailog:[SwichLanguage getString:@"cmderror7"] Title:nil];
                 break;
         }
         
     }
     failure:^(NSError *error) {
         [_HUD hide:YES];
         [MBProgressHUD showQuickTipWithText:[SwichLanguage getString:@"networkerror"]];
     }];
}
#pragma mark - show the result dailog
-(void)ShowTheResultDailog:(NSString*)content Title:(NSString*)title
{
    //设置帐号
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:content
                                                        delegate:self
                                               cancelButtonTitle:[SwichLanguage getString:@"sure"]
                                               otherButtonTitles:nil, nil
                               ];
    alertView.alertViewStyle=UIAlertViewStyleDefault;
    alertView.tag=10;
    [alertView show];
}
@end
