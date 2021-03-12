//
//  CarListViewController.m
//  domilink
//
//  Created by 马真红 on 2020/2/12.
//  Copyright © 2020 aika. All rights reserved.
//

#import "CarListViewController.h"
#import "LoginViewController.h"
#import "CarListTableCell.h"
#import "UnitModel.h"
#import "DeviceDetailViewController.h"
#import "SettingViewController.h"
#import "HistoryTrackViewController.h"
#import "BDDynamicTreeNode.h"
#import "AppleHistoryTrackController.h"
#import "SettingPlusController.h"
@interface CarListViewController ()
{
    NSString *strall;
    NSString *stronline;
    NSString *stroffline;
    NSString *sstatus;//选择的状态
    NSString *strbt1;
    NSString *strbt2;
    NSString *strbt3;
    int _pagesize;
    int _pageno;
    BOOL isloadcardata;//是否加载后台数据中
    NSTimer *_refreshTimer;
    Boolean isSearch;//是否搜索中，是就不自动刷新
    
    BDDynamicTree *_dynamicTree;//树状tableview
    UIView* TreeView;//树状tableview的父容器
    MBProgressHUD * _HUD_userlist;//加载用户下级列表的等待框
    Boolean NeedLoadView;
}
@end

@implementation CarListViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateView) name:@"changeLanguage" object:nil];
        sstatus=@"-1";
        isSearch=false;
        NeedLoadView=true;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_carlistTableView registerNib:[UINib nibWithNibName:@"CarListTableCell" bundle:nil] forCellReuseIdentifier:@"CarListTableCell"];
    [_carlistTableView setTableFooterView:[[UIView alloc] init]];
    [_carlistTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self ViewFit];
    [self initViewData];
    sstatus=@"-1";
    
    //后台预加载列表数据
    [self clickTitleButton:NULL];
}

-(void)adapteCalistView
{
    CGFloat originY=_viewtitle.frame.origin.y+_viewtitle.frame.size.height;//设置tableview的起点
    CGRect framenew= CGRectMake(0,
                                originY,
                                VIEWWIDTH,
                                CGRectGetHeight(self.view.frame)-originY-TABBARHEIGHT-IPXMargin);
    [_carlistTableView setFrame:framenew];
}
- (void)viewWillAppear:(BOOL)animated
{
    if (NeedLoadView) {
        //第一次打开界面的刷新
        [self adapteCalistView];
        NeedLoadView=false;
        [self setTreeContentView];
    }
    
    if(self.inAppSetting.HadLogin==false)
    {
        LoginViewController * loginViewController = [[LoginViewController alloc]init];
        loginViewController.modalPresentationStyle=0;
        [self presentViewController:loginViewController animated:NO completion:nil];
        //[self.navigationController pushViewController:loginViewController animated:NO];
        return;
    }else
    {
        NSLog(@"已经登陆，启动定时器");
        NSLog(@"username=%@",self.inAppSetting.username);
        if (![self.tvtitle.text isEqualToString:self.inAppSetting.curusername]) {//有改变，刷新
            [self setTitleAndFitView:self.inAppSetting.curusername];
        }
        
        [self startNSTimer];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [self stopNSTimer];
}
// 视图被销毁
- (void)dealloc {
    NSLog(@"CarListViewController界面销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//界面适配刘海
-(void)ViewFit{
    
    if(KIsiPhoneX)
    {
        CGRect mframe= CGRectMake(0,
                                  30,
                                  VIEWWIDTH,
                                  _viewtitle.frame.size.height);
        [_viewtitle setFrame:mframe];
    }
    float theheight=_viewseach.frame.size.height/8;
    [_viewseach.layer setMasksToBounds:YES];
    [_viewseach.layer setCornerRadius:theheight];
    
    //设置 全部 按钮左圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_btall.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _btall.bounds;
    maskLayer.path = maskPath.CGPath;
    _btall.layer.mask = maskLayer;
    _btall.layer.borderColor = [[UIColor colorWithHexString:@"#4f6db7"]CGColor];//设置边框颜色
    _btall.layer.borderWidth = 1.0f;
    //设置 离线 按钮画右圆角
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:_btoffline.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = _btoffline.bounds;
    maskLayer1.path = maskPath1.CGPath;
    _btoffline.layer.mask = maskLayer1;
    _btoffline.layer.borderColor = [[UIColor colorWithHexString:@"#4f6db7"]CGColor];//设置边框颜色
    _btoffline.layer.borderWidth = 1.0f;
    
    _btonline.layer.borderColor = [[UIColor colorWithHexString:@"#4f6db7"]CGColor];//设置边框颜色
    _btonline.layer.borderWidth = 1.0f;
    
    [_btall setBackgroundImage:[UIColor createImageWithColor:[UIColor colorWithHexString:@"#4f6db7"]] forState:UIControlStateSelected];
    [_btoffline setBackgroundImage:[UIColor createImageWithColor:[UIColor colorWithHexString:@"#4f6db7"]] forState:UIControlStateSelected];
    [_btonline setBackgroundImage:[UIColor createImageWithColor:[UIColor colorWithHexString:@"#4f6db7"]] forState:UIControlStateSelected];
    _btall.selected=true;
    
}
//设置顶部账号名称的同时需要适配位置
-(void)setTitleAndFitView:(NSString*)mstr{
    _tvtitle.text=mstr;
    [_tvtitle sizeToFit];
    CGRect framenew= CGRectMake((VIEWWIDTH-_tvtitle.frame.size.width)/2,
                                16,
                                _tvtitle.frame.size.width,
                                _tvtitle.frame.size.height);
    [_tvtitle setFrame:framenew];
    CGRect frameimg= CGRectMake(framenew.origin.x-25,
                                6+_tvtitle.frame.size.height/2,
                                20,
                                20);
    [_imgtitle setFrame:frameimg];
}
//初始化一些参数
-(void)initViewData{
    [_etseach setPlaceholder:[SwichLanguage getString:@"searchhit"]];
    [_btseach setTitle:[SwichLanguage getString:@"search"] forState:UIControlStateNormal];
    strall=[SwichLanguage getString:@"all"];
    stronline=[SwichLanguage getString:@"online"];
    stroffline=[SwichLanguage getString:@"offline"];
    strbt1=[SwichLanguage getString:@"details"];
    strbt2=[SwichLanguage getString:@"setting"];
    strbt3=[SwichLanguage getString:@"playback"];
    [_btall setTitle:strall forState:UIControlStateNormal];
    [_btonline setTitle:stronline forState:UIControlStateNormal];
    [_btoffline setTitle:stroffline forState:UIControlStateNormal];
}
-(void)UpdateView
{
    [self initViewData];
    [_carlistTableView reloadData];
}
#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count=%lu",(unsigned long)[self.inAppSetting.user_itemList count]);
    return [self.inAppSetting.user_itemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * identifier = @"CarListTableCell";
    CarListTableCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    //不能复用，必须刷新
    [cell.bt1 setTitle:strbt1 forState:UIControlStateNormal];
    [cell.bt2 setTitle:strbt2 forState:UIControlStateNormal];
    [cell.bt3 setTitle:strbt3 forState:UIControlStateNormal];
    
    
    [cell.bt1 addTarget:self action:@selector(onTouchBtnDetailInCell:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.bt2 addTarget:self action:@selector(onTouchBtnSettingInCell:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.bt3 addTarget:self action:@selector(onTouchBtnTrayInCell:) forControlEvents:(UIControlEventTouchUpInside)];
    
    cell.bt1.tag=indexPath.row;
    cell.bt2.tag=indexPath.row;
    cell.bt3.tag=indexPath.row;
    
    //数据刷新
    UnitModel *detail = [self.inAppSetting.user_itemList objectAtIndex:indexPath.row];
    cell.tvname.text=[detail getShowName];
    StsShowModel* mStsShowModel=[detail getShowStatu];
    cell.tvtime.text=mStsShowModel.TimeStr;
    cell.tvstatus.text=mStsShowModel.Sts;
    
    if([detail.logoType isEqualToString:@"23"])//23 为摩托车
    {
            switch (mStsShowModel.StsId) {
                case 1:
                    [cell.imgstatus setImage:[UIImage imageNamed:@"dy_list_static.png"]];
                    break;
                case 2:
                    [cell.imgstatus setImage:[UIImage imageNamed:@"dy_list_move.png"]];
                    break;
                case 0:
                case 3:
                default:
                    [cell.imgstatus setImage:[UIImage imageNamed:@"dy_list_offline.png"]];
                    break;
            }
    }else
    {
        switch (mStsShowModel.StsId) {
            case 0:
                [cell.imgstatus setImage:[UIImage imageNamed:@"car_expire.png"]];
                break;
            case 1:
                [cell.imgstatus setImage:[UIImage imageNamed:@"car_static.png"]];
                break;
            case 2:
                [cell.imgstatus setImage:[UIImage imageNamed:@"car_moving.png"]];
                break;
            case 3:
                [cell.imgstatus setImage:[UIImage imageNamed:@"car_offline.png"]];
                break;
            default:
                [cell.imgstatus setImage:[UIImage imageNamed:@"car_offline.png"]];
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.inAppSetting.selectid=indexPath.row;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotopage2"object:self];//发送全局改变广播
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)onTouchBtnDetailInCell:(UIButton *)sender
{
    NSLog(@"点击了第%ld个详情按钮",(long)sender.tag);
    UnitModel *detail = [self.inAppSetting.user_itemList objectAtIndex:sender.tag];
    DeviceDetailViewController *mDeviceDetailViewController = [[DeviceDetailViewController alloc]initWithImei:[detail getImei] andName:[detail getName] andplateNumber:[detail getCarNumber]];
    [self.navigationController pushViewController:mDeviceDetailViewController animated:YES];
}
-(void)onTouchBtnSettingInCell:(UIButton *)sender
{
    NSLog(@"点击了第%ld个设置按钮",(long)sender.tag);
    UnitModel *detail = [self.inAppSetting.user_itemList objectAtIndex:sender.tag];
//    SettingViewController *mSettingViewController = [[SettingViewController alloc]initWithImei:[detail getImei] anddevicetype:detail.devType];
//    [self.navigationController pushViewController:mSettingViewController animated:YES];
    
    SettingPlusController *mSettingPlusController = [[SettingPlusController alloc]initWithImei:[detail getImei] anddevicetype:detail.devType andImeiName:[detail getShowName]];
    [self.navigationController pushViewController:mSettingPlusController animated:YES];
}
-(void)onTouchBtnTrayInCell:(UIButton *)sender
{
    NSLog(@"点击了第%ld个回放按钮",(long)sender.tag);
    UnitModel *detail = [self.inAppSetting.user_itemList objectAtIndex:sender.tag];
    CLLocationCoordinate2D mdeviceCoor=CLLocationCoordinate2DMake([detail getLat], [detail getLot]);
    if (self.inAppSetting.mapType==1) {
        HistoryTrackViewController *historyTrackVC = [[HistoryTrackViewController alloc] initWithImei:[detail getImei] Withlalo:mdeviceCoor];
        [self.navigationController pushViewController:historyTrackVC animated:YES];
    }else
    {
        AppleHistoryTrackController *APhistoryTrackVC = [[AppleHistoryTrackController alloc] initWithImei:[detail getImei] Withlalo:mdeviceCoor];
        [self.navigationController pushViewController:APhistoryTrackVC  animated:YES];
    }
}
- (IBAction)clickbtall:(UIButton*)sender {
    _btall.selected=true;
    _btonline.selected=false;
    _btoffline.selected=false;
    sstatus=@"-1";
    [self reStartNSTimer];
    //[self reloadCarListby111withtype:self.inAppSetting.type loginNo:self.inAppSetting.curloginNo pageno:1 status:@"-1"];
}

- (IBAction)clickbtonline:(UIButton*)sender {
    _btall.selected=false;
    _btonline.selected=true;
    _btoffline.selected=false;
    sstatus=@"1";
    [self reStartNSTimer];
    //[self reloadCarListby111withtype:self.inAppSetting.type loginNo:self.inAppSetting.curloginNo pageno:1 status:@"1"];
}

- (IBAction)clickbtoffline:(UIButton*)sender {
    _btall.selected=false;
    _btonline.selected=false;
    _btoffline.selected=true;
    sstatus=@"0";
    [self reStartNSTimer];
    //[self reloadCarListby111withtype:self.inAppSetting.type loginNo:self.inAppSetting.curloginNo pageno:1 status:@"0"];
}

- (IBAction)clickSearchButton:(id)sender {
    NSString *ssearch=self.etseach.text;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (ssearch.length<2) {
        [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"searchhit"] withText:nil];
        return;
    }
    [self reloadCarListby502withtype:self.inAppSetting.type loginNo:self.inAppSetting.curloginNo pageno:1 status:@"-1" keyword:ssearch];
}

//加载111协议 －分页加载  isadd:yes为添加 no 为重置覆盖
-(void)reloadCarListby111withtype:(NSString*)type loginNo:(NSString*)loginNo pageno:(int)pageno status:(NSString*)queryType
{
    //NSLog(@"type=%@ ,loginNo=%@ ,status=%@",type,loginNo,queryType);
    typeof(self) __weak weakSelf = self;
    //_HUD = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    isloadcardata=true;
    isSearch=false;
    //sstatus=queryType;
    NSDictionary *bodyData = @{@"loginType":type,
                               @"loginNo":loginNo,
                               @"pageNo":[NSString stringWithFormat:@"%d",pageno],
                               @"queryType":queryType};//-1  全局 0在线 1离线
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:501
                                                        withParameters:bodyData];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *messageCenterObject)
     {
         //[_HUD hide:YES];
         self->isloadcardata=false;
         NSArray *detailArray = (NSArray *)[messageCenterObject.ret objectForKey:@"imeiList"];
         
//         NSString *test=[detailArray componentsJoinedByString:@""];
//         NSLog(@"101list:%@",test);
         self->_pagesize = [[messageCenterObject.ret objectForKey:@"pageSize"] intValue];
         
         self->_pageno = [[messageCenterObject.ret objectForKey:@"pageNo"] intValue];
         NSLog(@"imeiList:%lu onlineCount:%d",(unsigned long)detailArray.count,[[messageCenterObject.ret objectForKey:@"onlineCount"] intValue]);
         
        [self.inAppSetting.user_itemList removeAllObjects];
         
         
         for (NSDictionary *dic in detailArray)
         {
             //DeviceDetailObject *object = [[DeviceDetailObject alloc] initWithJSON:dic];
             UnitModel *object = [[UnitModel alloc] init];
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
             
             object.devImei= [dic objectForKey:@"devImei"];
             
             object.carNumber= [dic objectForKey:@"carNumber"];
             object.devSts= [dic objectForKey:@"devSts"];
             object.devName= [dic objectForKey:@"devName"];
             object.devType= [dic objectForKey:@"devType"];
             object.useSts= [dic objectForKey:@"useSts"];
             object.sigTime= [dic objectForKey:@"sigTime"];
             NSString* mspeed=[NSString stringWithFormat:@"%@",[dic objectForKey:@"speed"] ];
             object.speed= [mspeed floatValue];
             object.locTime= [dic objectForKey:@"locTime"];
             object.logoType= [dic objectForKey:@"logoType"];
             object.la= [dic objectForKey:@"la"];
             object.lo= [dic objectForKey:@"lo"];
             object.course= [dic objectForKey:@"course"];
             
             //object.logoType=@"2";
             
             [self.inAppSetting.user_itemList addObject:object];
             //[_deviceArray addObject:object];
             //[_allArray addObject:object];
             
         }
         int allcount=[[messageCenterObject.ret objectForKey:@"allCount"] intValue];
         int onlinecount=[[messageCenterObject.ret objectForKey:@"onlineCount"] intValue];
         int outlinecount=allcount-onlinecount;
         
         [weakSelf.btall setTitle:[NSString stringWithFormat:@"%@（%d）",self->strall, allcount] forState:UIControlStateNormal];
         [weakSelf.btonline setTitle:[NSString stringWithFormat:@"%@（%d）",self->stronline, onlinecount] forState:UIControlStateNormal];
         [weakSelf.btoffline setTitle:[NSString stringWithFormat:@"%@（%d）",self->stroffline, outlinecount] forState:UIControlStateNormal];
         
         [weakSelf.carlistTableView reloadData];
     }
               failure:^(NSError *error)
     {
         //[_HUD hide:YES];
         NSString *test=[NSString stringWithFormat:@"%@",error];
         NSLog(@"error=%@",test);
         [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA107X"] withText:nil];
         self->isloadcardata=false;
     }];
    
}

//加载502协议 －搜索全部包括子级 的设备
-(void)reloadCarListby502withtype:(NSString*)type loginNo:(NSString*)loginNo pageno:(int)pageno status:(NSString*)queryType keyword:(NSString*)mkeyword
{
    typeof(self) __weak weakSelf = self;
    //_HUD = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    isSearch=true;
    sstatus=queryType;
    NSDictionary *bodyData = @{@"loginType":type,
                               @"loginNo":loginNo,
                               @"pageNo":[NSString stringWithFormat:@"%d",pageno],
                               @"queryType":queryType,
                               @"hasLower":@"1",
                               @"key":mkeyword};//-1  全局 0在线 1离线
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:502
                                                        withParameters:bodyData];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *messageCenterObject)
     {
         //[_HUD hide:YES];
         NSArray *detailArray = (NSArray *)[messageCenterObject.ret objectForKey:@"imeiList"];
         
         //         NSString *test=[detailArray componentsJoinedByString:@""];
         //         NSLog(@"101list:%@",test);
         self->_pagesize = [[messageCenterObject.ret objectForKey:@"pageSize"] intValue];
         
         self->_pageno = [[messageCenterObject.ret objectForKey:@"pageNo"] intValue];
         NSLog(@"imeiList:%lu onlineCount:%d",(unsigned long)detailArray.count,[[messageCenterObject.ret objectForKey:@"onlineCount"] intValue]);
         
         [self.inAppSetting.user_itemList removeAllObjects];
         
         
         for (NSDictionary *dic in detailArray)
         {
             //DeviceDetailObject *object = [[DeviceDetailObject alloc] initWithJSON:dic];
             UnitModel *object = [[UnitModel alloc] init];
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
             
             object.devImei= [dic objectForKey:@"devImei"];
             
             object.carNumber= [dic objectForKey:@"carNumber"];
             object.devSts= [dic objectForKey:@"devSts"];
             object.devName= [dic objectForKey:@"devName"];
             object.devType= [dic objectForKey:@"devType"];
             object.useSts= [dic objectForKey:@"useSts"];
             object.sigTime= [dic objectForKey:@"sigTime"];
             NSString* mspeed=[NSString stringWithFormat:@"%@",[dic objectForKey:@"speed"] ];
             object.speed= [mspeed floatValue];
             object.locTime= [dic objectForKey:@"locTime"];
             object.logoType= [dic objectForKey:@"logoType"];
             object.la= [dic objectForKey:@"la"];
             object.lo= [dic objectForKey:@"lo"];
             object.course= [dic objectForKey:@"course"];
             
             [self.inAppSetting.user_itemList addObject:object];
             //[_deviceArray addObject:object];
             //[_allArray addObject:object];
             
         }
         int allcount=[[messageCenterObject.ret objectForKey:@"allCount"] intValue];
         int onlinecount=[[messageCenterObject.ret objectForKey:@"onlineCount"] intValue];
         int outlinecount=allcount-onlinecount;
         
         [weakSelf.btall setTitle:[NSString stringWithFormat:@"%@（%d）",self->strall, allcount] forState:UIControlStateNormal];
         [weakSelf.btonline setTitle:[NSString stringWithFormat:@"%@（%d）",self->stronline, onlinecount] forState:UIControlStateNormal];
         [weakSelf.btoffline setTitle:[NSString stringWithFormat:@"%@（%d）",self->stroffline, outlinecount] forState:UIControlStateNormal];
         
         [weakSelf.carlistTableView reloadData];
     }
               failure:^(NSError *error)
     {
         //[_HUD hide:YES];
         NSString *test=[NSString stringWithFormat:@"%@",error];
         NSLog(@"error=%@",test);
         [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA107X"] withText:nil];
         self->isloadcardata=false;
     }];
    
}
/**
 *  page1 定时器
 */
-(void)stopNSTimer
{
    NSLog(@"stopNSTimer");
    if (_refreshTimer != nil)
    {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
}
-(void)startNSTimer
{
    [self stopNSTimer];
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:nstimers
                                                     target:self
                                                   selector:@selector(refreshaction)
                                                   userInfo:nil
                                                    repeats:YES];
    [_refreshTimer fire];
    NSLog(@"startNSTimer");
}
-(void)reStartNSTimer
{
    self.etseach.text=@"";
    isSearch=false;
    if (_refreshTimer==nil) {
        [self startNSTimer];
    }else
    {
        [_refreshTimer fire];
    }
}
//定时器触发
-(void)refreshaction
{
    //下级搜索中，不自动更新
    if (isSearch) {
        return;
    }
    NSLog(@"refreshaction");
    [self reloadCarListby111withtype:self.inAppSetting.type loginNo:self.inAppSetting.curloginNo pageno:1 status:sstatus];
}
- (IBAction)clickTitleButton:(id)sender {
    if ([self.inAppSetting.type isEqualToString:@"1"]) {
        NSLog(@"SN号登陆，不需要使用该功能，不处理");
        return;
    }
    if (TreeView.hidden) {
        //显示
        [TreeView setHidden:NO];
        if (self.inAppSetting.dict==nil) {
            self.inAppSetting.dict=[NSMutableArray array];
            [self reloadCarListby110withtype:self.inAppSetting.type loginNo:self.inAppSetting.curloginNo];
        }
    }else
    {
        [TreeView setHidden:YES];
    }
}
-(void)setTreeContentView
{
    if (TreeView==nil) {
        
        CGFloat originY=_viewtitle.frame.origin.y+_viewtitle.frame.size.height;//设置tableview的起点
        CGRect framenew= CGRectMake(0,
                                    originY,
                                    VIEWWIDTH,
                                    CGRectGetHeight(self.view.frame)-originY-TABBARHEIGHT-IPXMargin);
        [_carlistTableView setFrame:framenew];
        
        TreeView=[[UIView alloc]init];
        CGFloat originTreeY=_viewtitle.frame.origin.y+ _viewseach.frame.origin.y;
        CGRect frameTree= CGRectMake(0,
                                     originTreeY,
                                     VIEWWIDTH,
                                     CGRectGetHeight(self.view.frame)-originTreeY-TABBARHEIGHT-IPXMargin);
        [TreeView setFrame:frameTree];
        [TreeView setHidden:YES];
        [self.view addSubview:TreeView];
        [self.view bringSubviewToFront:TreeView];
    }
}
-(void)setuptheTreeTableView:(NSArray*)myarray
{
    CGRect newfame=TreeView.bounds;
    _dynamicTree = [[BDDynamicTree alloc] initWithFrame:newfame nodes:myarray];
    _dynamicTree.delegate = self;
    [TreeView addSubview:_dynamicTree];
}

//加载110协议
-(void)reloadCarListby110withtype:(NSString*)type loginNo:(NSString*)loginNo
{
    typeof(self) __weak weakSelf = self;
    //_HUD_userlist = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    NSDictionary *bodyData = @{@"type":type,
                               @"loginNo":loginNo};
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:110
                                                        withParameters:bodyData];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *messageCenterObject)
     {
         //[_HUD_userlist hide:YES];
         
         NSArray *detailArray = (NSArray *)[messageCenterObject.ret objectForKey:@"userList"];
         
         //NSString *test=[detailArray componentsJoinedByString:@""];
         //NSLog(@"list:%@",test);
         
         
         if ([detailArray isEqual:[NSNull null]]) {
             detailArray=[NSArray array];
         }
         
         //BDDynamicTreeNode *root = [[BDDynamicTreeNode alloc] init];
         for (NSDictionary *dic in detailArray)
         {
             // loginNoObject *object = [[loginNoObject alloc] initWithJSON:dic];
             //root.isDepartment = [object.isParent isEqual:@"1"]==TRUE?YES:NO;
             BDDynamicTreeNode *root = [[BDDynamicTreeNode alloc] init];
             root.isDepartment=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"isParent"]] isEqual:@"1"]?YES:NO;
             
             //设置寻找根节点
             if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]] isEqual:self.inAppSetting.userId]) {
                 root.fatherNodeId=nil;
                 root.originX=20.0f;
             }else
             {
                 root.fatherNodeId =[NSString stringWithFormat:@"%@",[dic objectForKey:@"parentId"]];
             }
             
             root.nodeId =[NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]];
             root.name =[NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
             root.loginNo =[NSString stringWithFormat:@"%@",[dic objectForKey:@"loginNo"]];
             
             // NSLog(@"name:%@",root.name);
             
             [self.inAppSetting.dict addObject:root];
             
         }
         //         NSArray *myarray=[myDelegate.dict copy];
         //         _dynamicTree = [[BDDynamicTree alloc] initWithFrame:CGRectMake(0,85,VIEWWIDTH,100) nodes:myarray];
         //         _dynamicTree.delegate = self;
         //         [self.view addSubview:_dynamicTree];
         [self setuptheTreeTableView:self.inAppSetting.dict];
     }
               failure:^(NSError *error)
     {
         //[_HUD_userlist hide:YES];
         [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA107X"] withText:nil];
     }];
    
    
}
- (void)dynamicTree:(BDDynamicTree *)dynamicTree didSelectedRowWithNode:(BDDynamicTreeNode *)node
{
    _pageno=1;
    _pagesize=0;
    sstatus=@"-1";
    [self reStartNSTimer];
    [TreeView setHidden:YES];
    [self setTitleAndFitView:self.inAppSetting.curusername];
}
@end
