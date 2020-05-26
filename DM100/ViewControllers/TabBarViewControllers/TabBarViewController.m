//
//  TabBarViewController.m
//  domilink
//
//  Created by 马真红 on 2020/2/12.
//  Copyright © 2020 aika. All rights reserved.
//

#import "TabBarViewController.h"
#import "TabBarFooterView.h"
#import "MainMapViewController.h"
#import "MineViewController.h"
#import "ExpeirViewController.h"
#import "CarListViewController.h"
#import "APMainMapViewController.h"
@interface TabBarViewController ()<TabBarFooterViewDelegate>

@end

@implementation TabBarViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupViewControllers];
        [self setupFooterView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView) name:@"changeLanguage" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotopage2) name:@"gotopage2" object:nil];
    }
    return self;
}

- (void)setupViewControllers
{
    CarListViewController *item1 = [[CarListViewController alloc] init];
    MainMapViewController *item2 = [[MainMapViewController alloc] init];
    ExpeirViewController *item3 = [[ExpeirViewController alloc] init];
    MineViewController *item4 = [[MineViewController alloc] init];
    APMainMapViewController *item5= [[APMainMapViewController alloc] init];
    [self setViewControllers:[NSArray arrayWithObjects:item1, item2, item3, item4,item5, nil]];
    
    [self setSelectedIndex:0];
}

- (void)setupFooterView
{
    // 隐藏原来的
    [self.tabBar setHidden:YES];
    
    CGRect footerFrame = CGRectMake(0,
                                    CGRectGetHeight(self.view.frame) - TABBARHEIGHT,
                                    CGRectGetWidth(self.view.frame),
                                    TABBARHEIGHT);
    _tabBarFooterView = [[TabBarFooterView alloc] initWithFrame:footerFrame];
    _tabBarFooterView.delegate = self;
    [_tabBarFooterView updateView];
    [self.view addSubview:_tabBarFooterView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if(selectedIndex==1)//点击地图页面，进行二次判断地图类型
    {
        if (self.inAppSetting.mapType==0) {
            [super setSelectedIndex:4];//替换到苹果地图
            [_tabBarFooterView setSelected:selectedIndex];//底部按钮高亮不变
            return;
        }
    }
    
    
    [super setSelectedIndex:selectedIndex];
    [_tabBarFooterView setSelected:selectedIndex];
}

#pragma mark - TabbarFooterViewDelegate
- (void)tabBarFooterViewButtonDidSelected:(NSInteger)index
{
    [self setSelectedIndex:index];
}
// 视图被销毁
- (void)dealloc {
    NSLog(@"TabBarViewController界面销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//更新语言，刷新见面
-(void)updateView
{
     [_tabBarFooterView updateView];
}

-(void)gotopage2
{
    NSLog(@"gotopage2触发,selectid=%d",self.inAppSetting.selectid);
    [_tabBarFooterView.carViewButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}
@end
