//
//  SwSeverPop.m
//  DM100
//
//  Created by 马真红 on 2021/8/2.
//  Copyright © 2021 aika. All rights reserved.
//

#import "SwServerPop.h"

@implementation SwServerPop
{
    __weak IBOutlet UILabel *label1;
    __weak IBOutlet UILabel *label2;
    __weak IBOutlet UILabel *title;
    UIView *_backgroundView;
    BOOL isopenKeyboard;
}
- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SwServerPop"
                                          owner:self
                                        options:nil] firstObject];
    if (self)
    {
        isopenKeyboard=false;
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [self addNotification];
    [self UpdateView];
    if (_backgroundView == nil)
    {
        _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        _backgroundView.layer.opacity = 0.0f;
        
        UITapGestureRecognizer *tagGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickbackgroud)];
        [_backgroundView addGestureRecognizer:tagGes];
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

-(void)UpdateView
{
    [_surebutton setTitle:[SwichLanguage getString:@"sure"] forState:UIControlStateNormal];
    [_cancelbutton setTitle:[SwichLanguage getString:@"cancel"] forState:UIControlStateNormal];
    [title setText:[SwichLanguage getString:@"servertitle"]];
    [label1 setText:[SwichLanguage getString:@"server1"]];
    [label2 setText:[SwichLanguage getString:@"server2"]];
    
    NSString *language = self.inAppSetting.mServerURL;
    if ([language isEqualToString:TServerURL1]) {
        _ck1button.selected=true;
        _ck2button.selected=false;
    }else{
        _ck1button.selected=false;
        _ck2button.selected=true;
    }
}
-(void)clickbackgroud
{
    if (isopenKeyboard==true) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
}
- (IBAction)clickSureButton:(id)sender {
    NSLog(@"clicksurebutton");
    if (_ck1button.selected) {
        //self.inAppSetting.mServerURL=TServerURL1;
        
        [self.inAppSetting setMServerURL:TServerURL1];
    }else
    {
        //self.inAppSetting.mServerURL=TServerURL2;
        [self.inAppSetting setMServerURL:TServerURL2];
    }
    
    [self hide];
}
- (IBAction)clickCancelButton:(id)sender {
    [self hide];
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

- (IBAction)clickCk1:(id)sender {
    _ck1button.selected=true;
    _ck2button.selected=false;
}
- (IBAction)clickCk2:(id)sender {
    _ck1button.selected=false;
    _ck2button.selected=true;
}
@end
