//
//  FenceViewController.m
//  DM100
//
//  Created by 马真红 on 2021/10/11.
//  Copyright © 2021 aika. All rights reserved.
//

#import "FenceViewController.h"
#import "AddFenceViewController.h"
#import "FenceCell.h"
#import "FenceClass.h"
@interface FenceViewController ()
{
    NSString *_imei;
    NSString *_imeiname;
    UIButton *_liebiaoButton;
}
@end

@implementation FenceViewController
-(id)initWithImei:(NSString *)mimei andImeiName:(NSString *)mImeiName
{
    self = [super init];
    if (self)
    {
        _imei=mimei;
        _imeiname=mImeiName;
        [self setupView];
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
    [self tableViewSetting];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self get133CMD];
}
- (void)setupView
{
    _liebiaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_liebiaoButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_liebiaoButton setTitle:[SwichLanguage getString:@"add"] forState:UIControlStateNormal];
    [_liebiaoButton sizeToFit];
    [_liebiaoButton setFrame:CGRectMake(10,
                                        IOS7DELTA+IPXMargin,
                                        CGRectGetWidth(_liebiaoButton.frame),
                                        44)];
    [_liebiaoButton addTarget:self action:@selector(click_righttop_button) forControlEvents:UIControlEventTouchUpInside];
    [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"addfence"] withRightButton:_liebiaoButton];
    
}

-(void)click_righttop_button
{
    NSLog(@"click_righttop_button _imei=%@ _imeiname=%@",_imei,_imeiname);
    
    AddFenceViewController *mAddFenceViewController=[[AddFenceViewController alloc] initWithImei:_imei andImeiName:_imeiname andIsAdd:YES];
    [self.navigationController pushViewController:mAddFenceViewController animated:YES];
}


- (void)tableViewSetting
{
    self.messageCenterTableView.delegate = self;
    self.messageCenterTableView.dataSource = self;
    [self.messageCenterTableView setTableFooterView:[[UIView alloc] init]];
    [self.messageCenterTableView registerNib:[UINib nibWithNibName:@"FenceCell" bundle:nil] forCellReuseIdentifier:@"FenceCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    MJRefreshHeaderView * header = [MJRefreshHeaderView header];
    MJRefreshFooterView * footer = [MJRefreshFooterView footer];
    header.scrollView = self.messageCenterTableView;
    footer.scrollView = self.messageCenterTableView;
    self.messageCenterTableView.header = header;
    self.messageCenterTableView.footer = footer;
    

    self.messageArray = [NSMutableArray array];
    
}
-(void)get133CMD
{
    typeof(self) __weak weakSelf = self;
    NSDictionary *bodyData = @{@"deviceImei":_imei ,
                               @"updateUser":weakSelf.inAppSetting.loginNo};
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:133
                                                        withParameters:bodyData];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *messageCenterObject)
     {
         NSDictionary *ret = messageCenterObject.ret;
         NSArray *responseArray = (NSArray *)[ret objectForKey:@"msgList"];
             [weakSelf.messageArray removeAllObjects];//清空
             for (NSDictionary *dic in responseArray)
             {
                 FenceClass* mclass=[[FenceClass alloc]init];
                 mclass.fenceId= [[dic objectForKey:@"fenceId"] intValue];
                 mclass.isEnterAlarm= [[dic objectForKey:@"isEnterAlarm"] intValue];
                 mclass.isLeaveAlarm= [[dic objectForKey:@"isLeaveAlarm"] intValue];
                 mclass.latitude= [[dic objectForKey:@"latitude"] doubleValue];
                 mclass.longitude= [[dic objectForKey:@"longitude"] doubleValue];
                 mclass.radius= [[dic objectForKey:@"radius"] intValue];
                 mclass.fenceName=[NSString stringWithFormat:@"%@", [dic objectForKey:@"fenceName"]];
                 [weakSelf.messageArray addObject:mclass];
             }

         [weakSelf.messageCenterTableView reloadData];
     }
               failure:^(NSError *error)
     {
          [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"errorA100X"] withText:nil];
     }];
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
    static NSString * identifier = @"FenceCell";
    FenceCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    FenceClass *deviceInfo = [self.messageArray objectAtIndex:indexPath.row];
    cell.tv1.text=[NSString stringWithFormat:@"%@",deviceInfo.fenceName] ;
    cell.tv2.text=[NSString stringWithFormat:@"%@:%f",[SwichLanguage getString:@"fencecell1"],deviceInfo.latitude] ;
    cell.tv3.text=[NSString stringWithFormat:@"%@:%f", [SwichLanguage getString:@"fencecell2"],deviceInfo.longitude] ;
    cell.tv4.text=[NSString stringWithFormat:@"%@:%d", [SwichLanguage getString:@"fencecell3"],deviceInfo.radius] ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.navigationController pushViewController:orderingViewController animated:YES];
    FenceClass *deviceInfo = [self.messageArray objectAtIndex:indexPath.row];
    AddFenceViewController *mAddFenceViewController=[[AddFenceViewController alloc] initWithImei:_imei andImeiName:_imeiname andIsAdd:NO];
    [mAddFenceViewController setDataValueByFenceClss:deviceInfo];
    [self.navigationController pushViewController:mAddFenceViewController animated:YES];
}
@end
