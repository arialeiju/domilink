//
//  ZhouQiDailgo.m
//  CarConnection
//
//  Created by 马真红 on 2020/10/23.
//  Copyright © 2020 gemo. All rights reserved.
//

#import "ZhouQiDailog.h"
#import "AKTimePicker.h"
@implementation ZhouQiDailog
{
    UIView *_backgroundView;
    BOOL isopenKeyboard;
    NSString* tIMEI;
    NSString* dstr;
}
- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ZhouQiDailog"
                                          owner:self
                                        options:nil] firstObject];
    if (self)
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0f;
        
        
        [self.cancelbutton addTarget:self
                       action:@selector(clickcancelbutton)
             forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.sendbutton addTarget:self
                       action:@selector(askthebutton)
             forControlEvents:UIControlEventTouchUpInside];
        
        dstr=@"00:05";
        isopenKeyboard=false;
        //[UIColor colorWithHexString:@"#F7F7F7"]//淡灰色
        self.houslabel.layer.borderColor = [[UIColor blackColor] CGColor];
        self.houslabel.layer.borderWidth = 1.0f;//设置边框粗细
        self.houslabel.layer.masksToBounds = YES;
        self.minlabel.layer.borderColor = [[UIColor blackColor] CGColor];
        self.minlabel.layer.borderWidth = 1.0f;//设置边框粗细
        self.minlabel.layer.masksToBounds = YES;
        
        //绘画T字灰色边框线
        CGFloat mY=self.sendbutton.frame.origin.y;
        CGFloat mW=self.frame.size.width;
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, mY-1, mW, 1)];
        [line1 setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];
        [self addSubview:line1];
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(mW/2-0.5, mY, 1, self.sendbutton.frame.size.height)];
        [line2 setBackgroundColor:[UIColor colorWithHexString:@"#F7F7F7"]];
        [self addSubview:line2];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[SwichLanguage getString:@"zhouqitip1"]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(1,str.length-1)];
        self.tiplabel.attributedText = str;
        
        //配置时间选择触发事件
        UIButton *timeButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, mW, mY-2)];
        [timeButton addTarget:self
                       action:@selector(showTimePickerView)
             forControlEvents:UIControlEventTouchUpInside];
        [timeButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:timeButton];
    }
    return self;
}


- (void)showInView:(UIView *)view andIMEI:(NSString*)mimti
{
    tIMEI=mimti;
    [self addNotification];
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
    [self updateLagView];
    // animitaion
    [UIView animateWithDuration:0.25
                     animations:^
     {
         _backgroundView.layer.opacity = 1.0f;
         _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
         self.center = CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2);
     }];
}

//更新语言
-(void)updateLagView
{
    [_sendbutton setTitle:[SwichLanguage getString:@"send"] forState:UIControlStateNormal];
    [_cancelbutton setTitle:[SwichLanguage getString:@"cancel"] forState:UIControlStateNormal];
    [_titlelabel setText:[SwichLanguage getString:@"offline3"]];
    [_label1 setText:[SwichLanguage getString:@"hour"]];
    [_label2 setText:[SwichLanguage getString:@"min"]];
}

-(void)clickbackgroud
{
    if (isopenKeyboard==true) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
}
-(void)clickcancelbutton
{
    [self hide];
}

-(void)askthebutton
{
    NSLog(@"askthebutton imei=%@",tIMEI);
    if ([self.delegate respondsToSelector:@selector(SureButtonAction:)]) {
        NSArray *array = [dstr componentsSeparatedByString:@":"];
        NSString* shours=array[0];
        NSString* smin=array[1];
        int sme=[shours intValue]*60+[smin intValue];
        NSString* mcmd=[NSString stringWithFormat:@"Mode,3,%dM",sme];
        [self.delegate SureButtonAction:mcmd];
    }
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
-(void)showTimePickerView {
    
    AKTimePicker *pickerView = [[AKTimePicker alloc]initDatePackerWithStartHour:@"00" endHour:@"07" period:1 showtype:0 response:^(NSString *str) {
        NSString *string = str;
        if ([string isEqualToString:@"00:00"]||[string isEqualToString:@"00:01"]||[string isEqualToString:@"00:02"]||[string isEqualToString:@"00:03"]||[string isEqualToString:@"00:04"]) {
            string=@"00:05";//最小为5分钟
        }
        dstr=string;
        NSLog(@"showTimePickerView str = %@",string);
        NSArray *array = [string componentsSeparatedByString:@":"];
        if (array.count>1) {
            _houslabel.text=array[0];
            _minlabel.text=array[1];
        }
    }];
    [pickerView setShowRow:dstr];
    [pickerView show];
}
@end
