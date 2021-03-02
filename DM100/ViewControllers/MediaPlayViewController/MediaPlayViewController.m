//
//  MediaPlayViewController.m
//  CarConnection
//
//  Created by 马真红 on 2018/8/31.
//  Copyright © 2018年 gemo. All rights reserved.
//

#import "MediaPlayViewController.h"
#import "MediaPlayCell.h"
#import "CarAlarmMapViewController.h"
#import "AppleAlarmMapViewController.h"
#import "OnlinePopView.h"
@interface MediaPlayViewController ()
{
    HJAudioBubbleConfig *bubbleConfig;
    MBProgressHUD * _HUD;
    NSTimer* _refreshTimer;
    
    NSString *_imei;
    NSString *_devicetype;
    NSString *_imeiname;
}

@end

@implementation MediaPlayViewController
-(id)initWithImei:(NSString *)mimei anddevicetype:(NSString*)mdevicetype andImeiName:(NSString *)mImeiName
{
    self = [super init];
    if (self)
    {
        _imei=mimei;
        _devicetype=mdevicetype;
        _imeiname=mImeiName;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(10, IOS7DELTA,
                                     80, 44)];
    [rightButton setTitle:[SwichLanguage getString:@"cmd"] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(submitButtonDidPush) forControlEvents:UIControlEventTouchUpInside];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"setitem6"] withRightButton:rightButton];
    if(KIsiPhoneX)
    {
        CGRect newfame=self.messageCenterTableView.frame;
        newfame.origin.y=newfame.origin.y+IPXMargin;
        newfame.size.height=newfame.size.height-IPXMargin;
        [self.messageCenterTableView setFrame:newfame];
    }
    [self tableViewSetting];
    bubbleConfig=kHJAudioBubbleConfig;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"进入前台");
    [self GetCMD115Data];
    [self startNSTimer];
    [super viewWillAppear:animated];
}

//视图将要消失
- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"viewWillDisappear");
    [bubbleConfig myPause];
    [self stopNSTimer];
    [super viewWillDisappear:animated];
}

- (void)tableViewSetting
{
    self.messageCenterTableView.delegate = self;
    self.messageCenterTableView.dataSource = self;
    [self.messageCenterTableView setTableFooterView:[[UIView alloc] init]];
    [self.messageCenterTableView registerNib:[UINib nibWithNibName:@"MediaPlayCell" bundle:nil] forCellReuseIdentifier:@"MediaPlayCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    MJRefreshHeaderView * header = [MJRefreshHeaderView header];
    header.scrollView = self.messageCenterTableView;
    self.messageCenterTableView.header = header;
    
    
    self.messageArray = [NSMutableArray array];
    
    self.messageCenterTableView.header.beginRefreshingBlock = ^(MJRefreshBaseView * refreshView)
    {
        [self GetCMD115Data];
    };
    
   // [self.messageCenterTableView.header beginRefreshing];//刷新加载
}


- (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
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
    return 136;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MediaPlayCell";
    MediaPlayCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.timelabel.text=[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"sendTime"];
    cell.voicelenthlabel.text=[[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"timeLength"] stringByAppendingString:@"\""];
    
    cell.urlname=[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"url"];
    
    NSString* mmsgid=[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"msgId"];
    cell.msgId=mmsgid;
    
    cell.longPressCallBack = ^{
        //删除语音
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[SwichLanguage getString:@"deletemedia"]
                                                             message:mmsgid
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:[SwichLanguage getString:@"cancel"],[SwichLanguage getString:@"sure"], nil
                                   ];
        alertView.alertViewStyle=UIAlertViewStyleDefault;
        alertView.tag=0;
        [alertView show];
    };
    
    if (bubbleConfig.isPlayIng) {
        NSString* mmsgid=[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"msgId"];
        if ([mmsgid isEqualToString:bubbleConfig.msgId]) {
            cell.playIconV.image=bubbleConfig.voiceDefaultImage2;
        }else
        {
            cell.playIconV.image=bubbleConfig.voiceDefaultImage;
        }
    }else
    {
        cell.playIconV.image=bubbleConfig.voiceDefaultImage;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString* sendtime=[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"sendTime"];
    NSString* lalo=[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"position"];
    NSArray *array = [lalo componentsSeparatedByString:@","];
    NSLog(@"didSelectRowAtIndexPath array0=%@ array1=%@",array[0],array[1]);
    if (array.count>1) {
    
    
     NSDictionary *bodyData = @{@"time":sendtime,
                                @"str":[SwichLanguage getString:@"mediaalarm"],
                                @"imei":_imei,
                                @"name":_imeiname,
                                @"source":@"",
                                @"course":@"",
                                @"speed":@"",
                                @"longitude":array[1],
                                @"latitude":array[0],
                                @"accsts":@"",
                                @"deviceSts":@""};
    
    
       if (self.inAppSetting.mapType==1) {
            CarAlarmMapViewController *carAlarmMapViewController = [[CarAlarmMapViewController alloc] initWithType:bodyData];
            [self.navigationController pushViewController:carAlarmMapViewController animated:YES];
        }else
        {
             AppleAlarmMapViewController *mAppleAlarmMapViewController = [[AppleAlarmMapViewController alloc] initWithType:bodyData];
            [self.navigationController pushViewController:mAppleAlarmMapViewController animated:YES];
        }
        
    }else
    {
        NSLog(@"语音报警格式有问题，position不对");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GetCMD115Data
{
    typeof(self) __weak weakSelf = self;
    //_HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    NSDictionary *bodyData = @{@"imei":_imei,
                               @"type":_devicetype,
                               @"startTime":@"",
                               @"endTime":@"",
                               @"isAll":@"0",
                               };
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:115
                                                        withParameters:bodyData];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *messageCenterObject)
     {
         
         // [_HUD hide:YES];
         NSDictionary *ret = messageCenterObject.ret;
       // NSLog(@"ret=%@",ret);
             NSArray *responseArray = (NSArray *)[ret objectForKey:@"msgList"];
             [weakSelf.messageArray removeAllObjects];//清空
             for (NSDictionary *dic in responseArray)
             {
                 [weakSelf.messageArray addObject:dic];
             }
         
         [weakSelf.messageCenterTableView reloadData];
         [weakSelf.messageCenterTableView.header endRefreshing];
         if(weakSelf.messageArray.count>1)
         {
         [weakSelf.messageCenterTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(weakSelf.messageArray.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
         }
         
     }
               failure:^(NSError *error)
     {
         // [_HUD hide:YES];
         [MBProgressHUD showQuickTipWIthTitle:[SwichLanguage getString:@"tips"] withText:[SwichLanguage getString:@"errorA100X"]];
     }];
}

//点击指令按钮动作
-(void)submitButtonDidPush
{
    OnlinePopView* _timeSelectionView = [[OnlinePopView alloc] init];
    [_timeSelectionView showInView:[UIApplication sharedApplication].keyWindow andImei:_imei andImeiName:_imeiname];
}


-(void)stopNSTimer
{
    if (_refreshTimer != nil)
    {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
    }
}
-(void)startNSTimer
{
    [self stopNSTimer];
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                     target:self
                                                   selector:@selector(refreshaction)
                                                   userInfo:nil
                                                    repeats:YES];
}
-(void)refreshaction
{
    [self GetCMD115Data];
}



-(int)getPointInMessageArrayWithMsgId:(NSString*)mmsgid
{
    int theId=0;
    for (NSDictionary *dic in self.messageArray)
    {
        if ([[dic objectForKey:@"msgId"] isEqualToString:mmsgid]) {
            return theId;
        }else
        {
            theId++;
        }
    }
    
    return -1;
}

#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag==0) {
         NSLog(@"点击确定 alertView=%@",alertView.message);
        [self GetCMD116DataWithMsgId:alertView.message withIsAll:@"1"];
    }
}

/*
    116  删除对应msgID的录音（平台和app都要删除）
    请求命令字：116
    传入参数：imei、msgId、isAll
    返回内容：{“result”:”-1/0/1”,"msgId":"传入的msgId"}
    说明：
    1.isAll：0删除对应imei全部，1查指定msgID
    3.result：1为成功，-1,为不存在对应记录导致删除失败；0为其他因素导致删除失败
 */
-(void)GetCMD116DataWithMsgId:(NSString*)mmsgid withIsAll:(NSString*)misall
{
    typeof(self) __weak weakSelf = self;
    [_HUD show:YES];
    NSDictionary *bodyData = @{@"imei":_imei,
                               @"msgId":mmsgid,
                               @"isAll":misall,
                               };
    NSDictionary *parameters = [PostXMLDataCreater createXMLDicWithCMD:116
                                                        withParameters:bodyData];
    [NetWorkModel POST:ServerURL
            parameters:parameters
               success:^(ResponseObject *messageCenterObject)
     {
         
          [_HUD hide:YES];
         NSDictionary *ret = messageCenterObject.ret;
         NSString* mresult=(NSString*)[ret objectForKey:@"result"];
         if ([mresult isEqualToString:@"1"]) {
             [weakSelf ShowTheResultDailog:NULL Title:[SwichLanguage getString:@"mediar1"]];
             NSString* mmsgid=(NSString*)[ret objectForKey:@"msgId"];
             int mId=[weakSelf getPointInMessageArrayWithMsgId:mmsgid];
             if(mId>-1)
             {
                 NSIndexPath *mindexPath = [NSIndexPath indexPathForRow:mId inSection:0];

                 [weakSelf.messageArray removeObjectAtIndex:mId];
                 [weakSelf.messageCenterTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:mindexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             }
         } else if([mresult isEqualToString:@"-1"]) {
             [weakSelf ShowTheResultDailog:NULL Title:[SwichLanguage getString:@"mediar2"]];
         }else
         {
             [weakSelf ShowTheResultDailog:NULL Title:[SwichLanguage getString:@"mediar3"]];
         }
         
     }
               failure:^(NSError *error)
     {
          [_HUD hide:YES];
          [weakSelf ShowTheResultDailog:NULL Title:[SwichLanguage getString:@"errorA100X"]];
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
