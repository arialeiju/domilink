//
//  AppVersionViewController.m
//  domilink
//
//  Created by 马真红 on 2020/2/15.
//  Copyright © 2020 aika. All rights reserved.
//

#import "AppVersionViewController.h"

@interface AppVersionViewController ()
{
    
    __weak IBOutlet UILabel *tv1;
    __weak IBOutlet UILabel *tv2;
    __weak IBOutlet UILabel *tvversion;
    __weak IBOutlet UILabel *tvname;
}

@end

@implementation AppVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateView];
}

-(void)updateView{
    [tv1 setText:[SwichLanguage getString:@"mfeedback"]];
    [tv2 setText:[SwichLanguage getString:@"mversion"]];
    [tvname setText:[SwichLanguage getString:@"ztinfo"]];
    NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
    NSString *localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
    [tvversion setText:localVersion];
}

@end
