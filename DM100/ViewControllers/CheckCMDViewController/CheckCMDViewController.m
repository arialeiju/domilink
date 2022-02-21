//
//  CheckCMDViewController.m
//  CarConnection
//
//  Created by 马真红 on 17/5/8.
//  Copyright © 2017年 gemo. All rights reserved.
//

#import "CheckCMDViewController.h"
#import "CheckCMDTableViewCell.h"
@interface CheckCMDViewController ()
{
    int _pagesize;
    int _pageno;
    NSString *_imei;
}
@end

@implementation CheckCMDViewController
-(id)initWithImei:(NSString *)mimei
{
    self = [super init];
    if (self)
    {
        _imei=mimei;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(KIsiPhoneX)
    {
        CGRect newfame=self.messageCenterTableView.frame;
        newfame.origin.y=newfame.origin.y+IPXMargin;
        newfame.size.height=newfame.size.height-IPXMargin;
        [self.messageCenterTableView setFrame:newfame];
    }
    [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"setitem7"]];
    [self tableViewSetting];
}
- (void)tableViewSetting
{
    self.messageCenterTableView.delegate = self;
    self.messageCenterTableView.dataSource = self;
    [self.messageCenterTableView setTableFooterView:[[UIView alloc] init]];
    [self.messageCenterTableView registerNib:[UINib nibWithNibName:@"CheckCMDTableViewCell" bundle:nil] forCellReuseIdentifier:@"CheckCMDTableViewCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    MJRefreshHeaderView * header = [MJRefreshHeaderView header];
    MJRefreshFooterView * footer = [MJRefreshFooterView footer];
    header.scrollView = self.messageCenterTableView;
    footer.scrollView = self.messageCenterTableView;
    self.messageCenterTableView.header = header;
    self.messageCenterTableView.footer = footer;
    
    
    self.messageArray = [NSMutableArray array];
    
    self.messageCenterTableView.header.beginRefreshingBlock = ^(MJRefreshBaseView * refreshView)
    {
        typeof(self) __weak weakSelf = self;
        NSDictionary *bodyData = @{@"imei":_imei ,
                                   @"pageno":@"1"};
        NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:52
                                                            withParameters:bodyData];
        [NetWorkModel POST:ServerURL
                parameters:parameters
                   success:^(ResponseObject *messageCenterObject)
         {
             NSDictionary *ret = messageCenterObject.ret;
             
             NSString* _ret=(NSString *)[messageCenterObject.ret objectForKey:@"ret"];
             
             if ([_ret isEqualToString:@"1"]) {
                 NSArray *responseArray = (NSArray *)[ret objectForKey:@"cmdlist"];
                 [weakSelf.messageArray removeAllObjects];//清空
                 for (NSDictionary *dic in responseArray)
                 {
                     [weakSelf.messageArray addObject:dic];
                 }
                 //_pagesize = ceilf([[ret objectForKey:@"pagesize"] floatValue]/10);
                 _pagesize = [[ret objectForKey:@"pagesize"] intValue];
                 _pageno = [[ret objectForKey:@"pageno"] intValue];
                 NSLog(@"header:_pageno=%d,_pagesize=%d",_pageno,_pagesize);
             }else
             {
                 NSString* msgstr=(NSString *)[messageCenterObject.ret objectForKey:@"msg"];
                 if (msgstr.length==0) {
                     [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA100X"] withText:nil];
                 }else
                 {
                     [MBProgressHUD showQuickTipWIthTitle:msgstr withText:nil];
                 }
             }
             [weakSelf.messageCenterTableView reloadData];
             [weakSelf.messageCenterTableView.header endRefreshing];
         }
                   failure:^(NSError *error)
         {
             NSLog(@"error＝%@",error);
              [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA100X"] withText:nil];
             [weakSelf.messageCenterTableView.header endRefreshing];
         }];
        
    };
    
    self.messageCenterTableView.footer.beginRefreshingBlock = ^(MJRefreshBaseView * refreshView)
    {
        if (_pageno == _pagesize) {
             [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"nodata"] withText:nil];
            [self.messageCenterTableView.footer endRefreshing];
        }
        else
        {
            typeof(self) __weak weakSelf = self;
            NSDictionary *bodyData = @{@"imei":_imei,
                                       @"pageno":[NSString stringWithFormat:@"%d",_pageno + 1]};
            NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:52
                                                                withParameters:bodyData];
            [NetWorkModel POST:ServerURL
                    parameters:parameters
                       success:^(ResponseObject *messageCenterObject)
             {
                 NSDictionary *ret = messageCenterObject.ret;
                 NSString* _ret=(NSString *)[messageCenterObject.ret objectForKey:@"ret"];
                 
                 if ([_ret isEqualToString:@"1"]) {
                     NSArray *responseArray = (NSArray *)[ret objectForKey:@"cmdlist"];
                     //[weakSelf.messageArray removeAllObjects];//不清空
                     for (NSDictionary *dic in responseArray)
                     {
                         [weakSelf.messageArray addObject:dic];
                     }
                     //_pagesize = ceilf([[ret objectForKey:@"pagesize"] floatValue]/10);
                     _pagesize = [[ret objectForKey:@"pagesize"] intValue];
                     _pageno = [[ret objectForKey:@"pageno"] intValue];
                     
                     NSLog(@"footer:_pageno=%d,_pagesize=%d",_pageno,_pagesize);
                 }else
                 {
                     NSString* msgstr=(NSString *)[messageCenterObject.ret objectForKey:@"msg"];
                     if (msgstr.length==0) {
                         [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA100X"] withText:nil];
                     }else
                     {
                         [MBProgressHUD showQuickTipWIthTitle:msgstr withText:nil];
                     }
                 }
                 [weakSelf.messageCenterTableView reloadData];
                 [weakSelf.messageCenterTableView.footer endRefreshing];
             }
                       failure:^(NSError *error)
             {
                 [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA100X"] withText:nil];
                 [weakSelf.messageCenterTableView.footer endRefreshing];
             }];
        }
    };
    
    
    [self.messageCenterTableView.header beginRefreshing];//第一次加载。刷新
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.messageArray.count = %lu",(unsigned long)self.messageArray.count);
    return self.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"CheckCMDTableViewCell";
    CheckCMDTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary *deviceInfo = [self.messageArray objectAtIndex:indexPath.row];
    cell.order_name.text=[NSString stringWithFormat:@"%@", [deviceInfo objectForKey:@"order_name"]] ;
    cell.order_sts.text=[NSString stringWithFormat:@"%@", [deviceInfo objectForKey:@"order_sts"]] ;
//    cell.send_time.text=[NSString stringWithFormat:@"%@", [deviceInfo objectForKey:@"send_time"]] ;
//    cell.sts_time.text=[NSString stringWithFormat:@"%@", [deviceInfo objectForKey:@"sts_time"]] ;
    
    NSString* msendtime=[NSString stringWithFormat:@"%@", [deviceInfo objectForKey:@"send_time"]] ;
    NSString* mststime=[NSString stringWithFormat:@"%@", [deviceInfo objectForKey:@"sts_time"]] ;
    if ([msendtime isEqual:@"1970-01-01 00:00:00"]) {
        msendtime=@"";
    }
    if ([mststime isEqual:@"1970-01-01 00:00:00"]) {
        mststime=@"";
    }
    cell.send_time.text=msendtime;
    cell.sts_time.text=mststime;
    cell.result.text=[NSString stringWithFormat:@"%@", [deviceInfo objectForKey:@"result"]] ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.navigationController pushViewController:orderingViewController animated:YES];
    NSDictionary *deviceInfo = [self.messageArray objectAtIndex:indexPath.row];
    NSString * content=[NSString stringWithFormat:@"%@", [deviceInfo objectForKey:@"result"]] ;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[SwichLanguage getString:@"cmdtv5"]
                                                         message:content
                                                        delegate:self
                                               cancelButtonTitle:[SwichLanguage getString:@"sure"]
                                               otherButtonTitles:nil, nil
                               ];
    alertView.alertViewStyle=UIAlertViewStyleDefault;
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
