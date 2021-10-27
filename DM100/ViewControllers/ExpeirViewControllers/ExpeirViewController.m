//
//  ExpeirViewController.m
//  domilink
//
//  Created by 马真红 on 2020/2/12.
//  Copyright © 2020 aika. All rights reserved.
//

#import "ExpeirViewController.h"
#import "CarAlarmService.h"
#import "MessageCenterTableViewCell.h"
#import "CarAlarmMapViewController.h"
#import "AppleAlarmMapViewController.h"
@interface ExpeirViewController ()
{
    Boolean NeedLoadView;//优化保证只加载界面刷新一次
    
    MBProgressHUD * _HUD;
    int _pageno;
    int _pagesize;
    
    NSString *selectloginno;
    
    BOOL isCheckSN;
    NSString *SNloginno;
    NSString *mtype;
}
@end

@implementation ExpeirViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateView) name:@"changeLanguage" object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NeedLoadView=true;
    SNloginno=self.inAppSetting.loginNo;
    mtype=self.inAppSetting.type;
}
-(void)viewWillAppear:(BOOL)animated
{
    if (NeedLoadView) {
        NeedLoadView=false;
        [self InitALLView];
        [self.carAlarmTableView.header beginRefreshing];
    }
    
    NSLog(@"_pagen=%d",_pageno);
}
-(void)InitALLView{
    CGRect mframe=self.view.bounds;
    [_carAlarmTableView setFrame:CGRectMake(0,IPXLiuHai , mframe.size.width, mframe.size.height-IPXLiuHai*2-TABBARHEIGHT)];
    [self tableViewSetting];
}
-(void)UpdateView
{
   [_carAlarmTableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tableViewSetting{
    self.carAlarmTableView.delegate = self;
    self.carAlarmTableView.dataSource = self;
    [self.carAlarmTableView setTableFooterView:[[UIView alloc] init]];
    [self.carAlarmTableView registerNib:[UINib nibWithNibName:@"MessageCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageCenterTableViewCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // header & footer
    MJRefreshHeaderView * header = [MJRefreshHeaderView header];
    MJRefreshFooterView * footer = [MJRefreshFooterView footer];
    header.scrollView = self.carAlarmTableView;
    footer.scrollView = self.carAlarmTableView;
    self.carAlarmTableView.header = header;
    self.carAlarmTableView.footer = footer;
    
    //headerRefresh
    self.carAlarmTableView.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        [CarAlarmService CarAlarmWithType:[self getType]
                                  loginNo:[self getLoginNo]
                                 language:[NSString stringWithFormat:@"%d",[SwichLanguage userLanguageType]]
                                   pageno:@"1"
                                  succeed:^(CarAlarmObject *carAlarmObject)
         {
             _pageno = [carAlarmObject.pageno intValue];
             _pagesize = [carAlarmObject.pagesize intValue];
             self.carAlarmInformationArray = [NSMutableArray arrayWithArray:carAlarmObject.msg];
             [self.carAlarmTableView reloadData];
             [self.carAlarmTableView.header endRefreshing];
         }
                                  failure:^(NSError *error)
         {
             [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA107X"] withText:nil];
             [self.carAlarmTableView.header endRefreshing];
             NSLog(@"23 error = %@",error);
         }];
    };
    
    //footerRefresh
    self.carAlarmTableView.footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        if (_pageno == _pagesize) {
            [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"nodata"] withText:nil];
            [self.carAlarmTableView.footer endRefreshing];
        }
        else
        {
            [CarAlarmService CarAlarmWithType:[self getType]
                                      loginNo:[self getLoginNo]
                                     language:[NSString stringWithFormat:@"%d",[SwichLanguage userLanguageType]]
                                       pageno:[NSString stringWithFormat:@"%d",_pageno + 1]
                                      succeed:^(CarAlarmObject *carAlarmObject) {
                                          _pageno = [carAlarmObject.pageno intValue];
                                          [self.carAlarmInformationArray addObjectsFromArray:carAlarmObject.msg];
                                          [self.carAlarmTableView reloadData];
                                          [self.carAlarmTableView.footer endRefreshing];
                                      }
                                      failure:^(NSError *error) {
                                          [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA107X"] withText:nil];
                                          [self.carAlarmTableView.footer endRefreshing];
                                          NSLog(@"23 error = %@",error);
                                      }];
        }
    };
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return (CGRectGetHeight([[UIScreen mainScreen] bounds]) - 64)/10;
    return 71;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carAlarmInformationArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MessageCenterTableViewCell";
    MessageCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    self.carAlarmInformationDictionary = [self.carAlarmInformationArray objectAtIndex:indexPath.row];
    cell.messageLabel.text = [self.carAlarmInformationDictionary objectForKey:@"str"];
    cell.nameLabel.text = [self.carAlarmInformationDictionary objectForKey:@"name"];
    cell.timeLabel.text = [self.inAppSetting ChangeGMT8toSysTime:[self.carAlarmInformationDictionary objectForKey:@"time"]];
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.carAlarmInformationDictionary = [self.carAlarmInformationArray objectAtIndex:indexPath.row];
    if (self.inAppSetting.mapType==1) {
        CarAlarmMapViewController *carAlarmMapViewController = [[CarAlarmMapViewController alloc] initWithType:self.carAlarmInformationDictionary];
        [self.navigationController pushViewController:carAlarmMapViewController animated:YES];
    }else
    {
        NSLog(@"苹果报警地图");
         AppleAlarmMapViewController *mAppleAlarmMapViewController = [[AppleAlarmMapViewController alloc] initWithType:self.carAlarmInformationDictionary];
        [self.navigationController pushViewController:mAppleAlarmMapViewController animated:YES];
    }

}
-(NSString*)getType
{
    //NSLog(@"getType=%@",isCheckSN?@"是":@"否");
    return mtype;
}

-(NSString*)getLoginNo
{
    return SNloginno;
}
@end
