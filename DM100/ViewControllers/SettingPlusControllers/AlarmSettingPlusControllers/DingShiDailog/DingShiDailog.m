//
//  DingShiDailog.m
//  CarConnection
//
//  Created by 马真红 on 2020/10/23.
//  Copyright © 2020 gemo. All rights reserved.
//

#import "DingShiDailog.h"
#import "DSView.h"
#import "DSViewCell.h"
#import "AKTimePicker.h"
#import "DingShiPicker.h"
@interface DingShiDailog ()<UITableViewDataSource,UITableViewDelegate,DSViewCellItemDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *imeilabel;
@end

@implementation DingShiDailog
{
    UIView *_backgroundView;
    BOOL isopenKeyboard;
    NSString* tIMEI;
    int tshowtype;
    NSString* sday;
    NSString* _strshowday;
    
    int mpoit;//记录位置 默认1
}
- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"DingShiDailog"
                                          owner:self
                                        options:nil] firstObject];
    if (self)
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0f;
        
        sday=@"01";
        [self.cancelbutton addTarget:self
                       action:@selector(clickcancelbutton)
             forControlEvents:UIControlEventTouchUpInside];
        //[self.cancelbutton setBackgroundColor:[UIColor colorWithHexString:@"#00B7EE"]];
        
        
        [self.sendbutton addTarget:self
                       action:@selector(askthebutton)
             forControlEvents:UIControlEventTouchUpInside];
        //[self.sendbutton setBackgroundColor:[UIColor colorWithHexString:@"#00B7EE"]];
        
        //[title setBackgroundColor:[UIColor colorWithHexString:@"#00B7EE"]];
        isopenKeyboard=false;
        
        _dataSource=[[NSMutableArray alloc] init];
        [self initTabelView];
    }
    return self;
}

- (void)initTabelView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH-40, DSCellH*2) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.tableView setTableHeaderView:[[UIView alloc] init]];
    //[self.tableView registerClass:[DSViewCell class] forCellReuseIdentifier:@"DSViewCell"];

    [self addSubview:self.tableView];
    [self.tiplabel setHidden:YES];
    
    [_sendbutton setTitle:[SwichLanguage getString:@"send"] forState:UIControlStateNormal];
    [_cancelbutton setTitle:[SwichLanguage getString:@"cancel"] forState:UIControlStateNormal];
    _strshowday=[SwichLanguage getString:@"day"];
}

- (void)showInView:(UIView *)view andIMEI:(NSString*)mimti andShowType:(int)mtype
{
    tIMEI=mimti;
    tshowtype=mtype;
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
    
    [self UIAutoInit];
}

//UI创建
-(void)UIAutoInit
{
    //初始化动态配置UI界面
    CGFloat mY=20;//标旗位置
    //CGFloat mW=VIEWWIDTH-40;
    CGFloat mW=280;
    CGFloat mMagin=20;//内嵌长度
    //配置标题
    UILabel * titlelabel= [[UILabel alloc]initWithFrame:CGRectMake(0, mY, mW, 30)];
    titlelabel.font = [UIFont systemFontOfSize:15];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    
    if (tshowtype==0) {
        titlelabel.text=[SwichLanguage getString:@"offline2"];
        mpoit=0;
        [_dataSource addObject:@"00:00"];
    }else
    {
        titlelabel.text=[SwichLanguage getString:@"offline5"];
        mpoit=1;
        [_dataSource addObject:@"1"];
        [_dataSource addObject:@"00:00"];
    }
    
    
    titlelabel.textColor=[UIColor blackColor];
    [self addSubview:titlelabel];
    mY=mY+titlelabel.frame.size.height+10;
    
    //配置imei label
    _imeilabel= [[UILabel alloc]initWithFrame:CGRectMake(mMagin, mY, mW-mMagin*2, 20)];
    _imeilabel.font = [UIFont systemFontOfSize:15];
    _imeilabel.text=[NSString stringWithFormat:@"%@:%@",[SwichLanguage getString:@"device"],tIMEI];
    _imeilabel.textColor=[UIColor blackColor];
    [self addSubview:_imeilabel];
    mY=mY+_imeilabel.frame.size.height+10;
    
    //配置上报周期
    [self tableViewHadChage];
    //参考：https://github.com/canwhite/QCPopView/blob/master/QCPopView2017/QCPopView.m
    
}

//tableview 有变化
-(void)tableViewHadChage
{
    CGFloat tableH=DSCellH*self.dataSource.count;
    
    CGRect newtableframe=CGRectMake(_imeilabel.frame.origin.x, CGRectGetMaxY(_imeilabel.frame),_imeilabel.frame.size.width, tableH);
    [self.tableView setFrame:newtableframe];
    //[self.tableView setBackgroundColor:[UIColor redColor]];
    [self bringSubviewToFront:self.tableView];
    [self.tableView reloadData];
    
//    CGRect newbvframe=self.buttomview.frame;
//    newbvframe.origin.y=CGRectGetMaxY(newtableframe);
//    newbvframe.origin.x=newtableframe.origin.x;
//    newbvframe.size.width=newtableframe.size.width;
//    [self.buttomview setFrame:newbvframe];
//    [self bringSubviewToFront:self.buttomview];
    //配置新宽度
    CGRect mcontent=self.bounds;
    mcontent.size.width=_imeilabel.frame.size.width+60;
    mcontent.size.height=CGRectGetMaxY(self.tableView.frame)+84;
    [self setFrame:mcontent];
    [self setCenter:CGPointMake(VIEWWIDTH/2, VIEWHEIGHT/2)];
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
    NSLog(@"askthebutton");
    if ([self.delegate respondsToSelector:@selector(SureButtonDingShiAction:)]) {
        NSMutableString *mstrs=[[NSMutableString alloc] init];
        
        if(mpoit==0)
        {
            [mstrs appendFormat:@"Mode,21"];
        }else
        {
            [mstrs appendFormat:@"Mode,1"];
        }
        
        for (int i=mpoit; i<self.dataSource.count; i++) {
            NSString* mmain=[self.dataSource objectAtIndex:i];
            NSArray *array = [mmain componentsSeparatedByString:@":"];
            if (array.count>1) {
                [mstrs appendFormat:@",%@%@",array[0],array[1]];
            }
        }
        
        if (mpoit==1) {//闹铃上报才匹配日期
            if (sday.length<2) {
                sday=[NSString stringWithFormat:@"0%@",sday];
            }
            [mstrs appendFormat:@",%@",sday];
        }
        
        NSString* mcmd=mstrs;
        [self.delegate SureButtonDingShiAction:mcmd];
    }
    [self hide];
}

- (IBAction)DoNewAddAction:(id)sender {
    if (self.dataSource.count<(mpoit+5)) {
        [self.dataSource addObject:@"00:00"];
        [self tableViewHadChage];
    }else
    {
        [self.tiplabel setHidden:NO];
    }
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
     }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //DSViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DSViewCell" forIndexPath:indexPath];
    DSViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DSViewCell"];
     if (cell == nil) {
         cell = [[[NSBundle mainBundle]loadNibNamed:@"DSViewCell" owner:self options:nil] lastObject];
     }
    NSString * buttonStr = self.dataSource[indexPath.row];
    if (mpoit!=0&&indexPath.row==0) {
        cell.titlelabel.text=[SwichLanguage getString:@"uploadtime"];
        cell.contentlabel.text=[NSString stringWithFormat:@"%@%@",buttonStr,_strshowday];
        [cell.lastbutton setHidden:YES];
    }else if(indexPath.row==mpoit)
    {
        cell.titlelabel.text=[SwichLanguage getString:@"popt2"];
        cell.contentlabel.text=buttonStr;
        if (self.dataSource.count==2) {
            [cell.lastbutton setHidden:YES];
        }else
        {
            [cell.lastbutton setHidden:NO];
        }
    }else
    {
        cell.titlelabel.text=[SwichLanguage getString:@"popt2"];
        cell.contentlabel.text=buttonStr;
        [cell.lastbutton setHidden:NO];
    }
    cell.tag=indexPath.row;
    cell.delegate=self;
    return cell;
    
    
    
}
#pragma mark - UITableViewDelagate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DSCellH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if ([self.QCPopViewDelegate respondsToSelector:@selector(getTheButtonTitleWithIndexPath:)]) {
//        [self.QCPopViewDelegate getTheButtonTitleWithIndexPath:indexPath];
//    }
    NSLog(@"didSelectRowAtIndexPath=%ld",(long)indexPath.row);
}
- (void)DoMinusAction:(NSInteger)SectionItem
{
    //NSLog(@"SectionItem=%ld",(long)SectionItem);
    if (self.dataSource.count>(mpoit+1)) {
        [self.dataSource removeObjectAtIndex:SectionItem];
        [self tableViewHadChage];
    }
}

- (void)DoSelectTime:(NSInteger)SectionItem
{
    NSLog(@"SectionItem=%ld",(long)SectionItem);
    if (SectionItem>(mpoit-1)) {
        AKTimePicker *pickerView = [[AKTimePicker alloc]initDatePackerWithStartHour:@"00" endHour:@"25" period:1 showtype:1 response:^(NSString *str) {
            NSString *mstring = str;
            //NSLog(@"str = %@",mstring);
            [self.dataSource replaceObjectAtIndex:SectionItem withObject:mstring];
            //cell刷新
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:SectionItem inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [pickerView show];
    }else
    {
        DingShiPicker *pickerView = [[DingShiPicker alloc]initDatePackerWithStartHour:sday response:^(NSString *str) {
            NSString *mstring = str;
            sday=mstring;
            //NSLog(@"sday = %@",mstring);
            [self.dataSource replaceObjectAtIndex:SectionItem withObject:mstring];
            //cell刷新
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:SectionItem inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [pickerView show];
    }
}
@end
