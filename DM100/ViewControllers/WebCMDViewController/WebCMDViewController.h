//
//  WebCMDViewController.h
//  CarConnection
//
//  Created by 马真红 on 17/11/21.
//  Copyright © 2017年 gemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface WebCMDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webview;
-(void)SetType:(int)settype andImei:(NSString*)mimei;
@end
