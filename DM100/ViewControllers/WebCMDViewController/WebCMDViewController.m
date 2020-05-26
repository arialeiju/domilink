//
//  WebCMDViewController.m
//  CarConnection
//
//  Created by 马真红 on 17/11/21.
//  Copyright © 2017年 gemo. All rights reserved.
//

#import "WebCMDViewController.h"
#import "WYWebProgressLayer.h"
#import "AESCrypt.h"
@interface WebCMDViewController ()<UIWebViewDelegate>
{
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
    float webviewheight;
    float webviewwidth;
    NSString *jscmd;
    int SettypeId;
    NSString* _imei;
}
@end

@implementation WebCMDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//   // NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
//      NSString *encodedString = [@"http://www.yidiyitian.cn:8080/AppServer/html/verify.html" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url= [NSURL URLWithString:encodedString];
    
//    self.webview.delegate=self;
//    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    
    //[self webViewDidFinishLoadCompletely];
    webviewheight=self.webview.frame.size.height;
    webviewwidth=self.webview.frame.size.width;
    if(KIsiPhoneX)
    {
        CGRect newfame=_webview.frame;
        newfame.origin.y=newfame.origin.y+IPXMargin;
        newfame.size.height=newfame.size.height-IPXMargin;
        [_webview setFrame:newfame];
    }
}

-(void)SetType:(int)settype andImei:(NSString*)mimei
{
    SettypeId=settype;
    _imei=mimei;
    //1下发指令 2支付宝支付页面 3 订单查询
    NSURL *url;
    NSLog(@"setttpe=%d",settype);
    switch (settype) {
        case 1:
            url= [NSURL URLWithString:@"http://plat.basegps.com:8088/AppServer/html/verify.html"];
            [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"setitem3"]];
            jscmd=@"verify";
            break;
        case 4:
            url= [NSURL URLWithString:@"http://plat.basegps.com:8088/AppServer/html/verifyOffline.html"];
            [self addBackButtonTitleWithTitle:[SwichLanguage getString:@"setitem4"]];
            jscmd=@"verifyOffline";
            break;
        default:
            break;
    }
    self.webview.delegate=self;
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
      NSLog(@"开始");
    if (KIsiPhoneX) {
        _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 65+IPXMargin, SCREEN_WIDTH, 2)];
    }else
    {
        _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 2)];
    }
    [self.view.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
//    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *alerjs=@"alert('test')";
//    [context evaluateScript:alerjs];
    
    if (!webView.isLoading) {
        NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
        BOOL complete = [readyState isEqualToString:@"complete"];
         NSLog(@"%@", NSStringFromSelector(_cmd));
        if (complete) {
            [_progressLayer finishedLoad];
            [self webViewDidFinishLoadCompletely];
        } else {
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"1=%@", NSStringFromSelector(_cmd));
    [_progressLayer finishedLoad];
}

- (void)dealloc {
    NSLog(@"i am dealloc");
    [self cleanCacheAndCookie];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL * url = [request URL];
    if ([[url scheme] isEqualToString:@"js"]) {
//        NSArray *params =[url.query componentsSeparatedByString:@"&"];
//        
//        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
//        for (NSString *paramStr in params) {
//            NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
//            if (dicArray.count > 1) {
//                NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                [tempDic setObject:decodeValue forKey:dicArray[0]];
//            }
//        }
        NSString * urlStr = [url absoluteString];
        NSString * handStr=@"js://webview?";
        NSString* orderString=[urlStr substringFromIndex:handStr.length];
        // NOTE: 调用支付结果开始支付
        NSString *appScheme = @"chesafe";
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"orderString = %@",orderString);
//            [self HanleThePayResult:resultDic];
//        }];
        //NSLog(@"tempDic:%@",tempDic);
        return NO;
    }
    
    return YES;
}

//真正加载完成处理，自动调用js登录
- (void)webViewDidFinishLoadCompletely {
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];//获取时间戳
    
    NSString *imei= [AESCrypt encryptAES:_imei key:timeString];
    
    NSLog(@"imei=%@  timeString=%@",imei,timeString);
    
    
//    NSString *sendcmd=[NSString stringWithFormat:@"verify('%@','%@')",timeString,imei];
//    NSString *test=@"verify('1511917471','37efb2f01c3ff61d9c5ea8f86672358f')";
//    NSLog(@"sendcmd=%@",sendcmd);
//    NSLog(@"test=%@",test);
    
     NSString *sendcmd=[NSString stringWithFormat:@"%@('%@','%@','%f','%f')",jscmd,timeString,imei,webviewwidth,webviewheight];
     NSLog(@"sendcmd=%@",sendcmd);
        JSContext *context=[self.webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        [context evaluateScript:sendcmd];
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

@end
