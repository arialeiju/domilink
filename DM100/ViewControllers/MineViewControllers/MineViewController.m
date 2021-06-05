//
//  MineViewController.m
//  domilink
//
//  Created by 马真红 on 2020/2/12.
//  Copyright © 2020 aika. All rights reserved.
//

#import "MineViewController.h"
#import "mineFuctionsTableViewCell.h"
#import "SwLanguagePop.h"
#import "ServerInformationViewController.h"
#import "AppVersionViewController.h"
#import "LoginViewController.h"
#import "ChangePasswordViewController.h"
#import "SwMapPop.h"
@interface MineViewController ()
{
    NSMutableArray * _mineFunctionsArray;
}
@end

@implementation MineViewController
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
    // tableView
    [_mineFunctionTableView registerNib:[UINib nibWithNibName:@"mineFuctionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"mineFuctionsTableViewCell"];
    [_mineFunctionTableView setTableFooterView:[[UIView alloc] init]];
    //self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self UpdateView];
}

-(void)UpdateView
{
    _mineFunctionsArray = [[NSMutableArray alloc] initWithObjects:
                           [SwichLanguage getString:@"page4item1"],
                           [SwichLanguage getString:@"page4item6"],
                           [SwichLanguage getString:@"page4item2"],
                           [SwichLanguage getString:@"page4item3"],
                           [SwichLanguage getString:@"page4item4"],
                           [SwichLanguage getString:@"page4item5"],
                           nil];
    [_mineFunctionTableView reloadData];
}
#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.mineFunctionTableView){
        return [_mineFunctionsArray count];
    }
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * identifier = @"mineFuctionsTableViewCell";
    mineFuctionsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.titleImageView.image = [UIImage imageNamed:@"page4item1.png"];
            break;
        case 1://修改密码
            cell.titleImageView.image = [UIImage imageNamed:@"page4item6.png"];
            break;
            
        case 2:
            cell.titleImageView.image = [UIImage imageNamed:@"page4item2.png"];
            break;
        case 3:
            cell.titleImageView.image = [UIImage imageNamed:@"page4item3.png"];
            break;
        case 4:
            cell.titleImageView.image = [UIImage imageNamed:@"page4item4.png"];
            break;
        case 5:
            cell.titleImageView.image = [UIImage imageNamed:@"page4item5.png"];
            break;
            
            
        default:
            break;
    }
    cell.accessoryType = YES;
    cell.titleLabel.text = [_mineFunctionsArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            SwLanguagePop * mSwLanguagePop = [[SwLanguagePop alloc]init];
            [mSwLanguagePop showInView:[UIApplication sharedApplication].keyWindow];
        }
            break;
       case 1:{
                SwMapPop * mSwMapPop = [[SwMapPop alloc]init];
                [mSwMapPop showInView:[UIApplication sharedApplication].keyWindow];
            }
                break;
        case 2:
        {
            ChangePasswordViewController * changePasswordViewController = [[ChangePasswordViewController alloc] initWithImei:self.inAppSetting.loginNo WithDeviceType:@"0" AndShowType:0];
            [self.navigationController pushViewController:changePasswordViewController animated:YES];
        }
            break;
        case 3:
        {
            ServerInformationViewController * serverInformationViewController = [[ServerInformationViewController alloc] init];
            [serverInformationViewController addBackButtonTitleWithTitle:[_mineFunctionsArray objectAtIndex:indexPath.row] withRightButton:nil];
            [self.navigationController pushViewController:serverInformationViewController animated:YES];
        }
            break;
        
        case 4:{
            //意见反馈
            AppVersionViewController * mAppVersionViewController = [[AppVersionViewController alloc] init];
            [mAppVersionViewController addBackButtonTitleWithTitle:[_mineFunctionsArray objectAtIndex:indexPath.row] withRightButton:nil];
            [self.navigationController pushViewController:mAppVersionViewController animated:YES];
        }
           break;
           
        case 5:{
            [self.inAppSetting loginOut];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.modalPresentationStyle=0;
            [self presentViewController:loginVC animated:NO completion:^{
                [self.tabBarController setSelectedIndex:0];
                }];
        }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 视图被销毁
- (void)dealloc {
    NSLog(@"MineViewController界面销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
