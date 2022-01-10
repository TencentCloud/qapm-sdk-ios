//
//  QAPMWKWebViewViewController.m
//  ApmDemo
//
//  Created by Cass on 2019/5/20.
//  Copyright © 2019 testcgd. All rights reserved.
//

#import "QAPMWKWebViewViewController.h"
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <QAPM/QAPM.h>
#import "UIButton+Utils.h"

@interface QAPMWKWebViewViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
{
    WKWebView *wkWebView;
    UIButton *jserrorBtn;
    UIButton *webViewBtn;
}

@end

@implementation QAPMWKWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat btnHeight = 50.;
    CGFloat btnWidth = 200.;
    CGFloat btnGap = 44.;
    CGFloat contentX = (self.view.frame.size.width - btnWidth) / 2;
    CGFloat contentY = 2 * btnGap;
    
    jserrorBtn = [UIButton genBigGreenButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [jserrorBtn addTarget:self action:@selector(entranceJserror) forControlEvents:UIControlEventTouchUpInside];
    [jserrorBtn setTitle:@"打开jserror的上报" forState:UIControlStateNormal];
    [self.view addSubview:jserrorBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    webViewBtn = [UIButton genBigGreenButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [webViewBtn addTarget:self action:@selector(entranceWebView) forControlEvents:UIControlEventTouchUpInside];
    [webViewBtn setTitle:@"打开webView的上报" forState:UIControlStateNormal];
    
    [self.view addSubview:jserrorBtn];
    
    [self.view addSubview:webViewBtn];
    
   
}

 
- (void)entranceWebView {

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc]init];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"vConsole.js" ofType:nil];
    NSString *filename = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:filename injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:script];
    
    wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    wkWebView.UIDelegate = self;
    wkWebView.navigationDelegate  = self;
    NSString *urlString = @"https://cloud.tencent.com/product/qapm";
    NSURL *url = [NSURL URLWithString:urlString];
    [wkWebView loadRequest:[NSURLRequest requestWithURL:url]];

     [self.view addSubview:wkWebView];
}

- (void)entranceJserror {

    //加入vConsole插件，方便客户端查看webview的上报日志
 
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc]init];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"vConsole.js" ofType:nil];
    NSString *filename = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:filename injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:script];
    
    wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    wkWebView.UIDelegate = self;
    wkWebView.navigationDelegate  = self;
    NSString *urlString = @"http://qapm-1253358381.cos.ap-guangzhou.myqcloud.com/new_monitor.html";
    NSURL *url = [NSURL URLWithString:urlString];
    [wkWebView loadRequest:[NSURLRequest requestWithURL:url]];

    [self.view addSubview:wkWebView];
}


- (void)dealloc {
    
    NSLog(@"WKWebView dealloc");
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:[QAPMWebViewProfile qapmBaseInfo:@"webview"] completionHandler:nil];
    [webView evaluateJavaScript:[QAPMWebViewProfile qapmJsStart] completionHandler:nil];
}
 
@end
