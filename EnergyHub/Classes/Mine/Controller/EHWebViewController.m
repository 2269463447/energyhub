//
//  EHWebViewController.m
//  EnergyHub
//
//  Created by cpf on 2017/8/20.
//  Copyright © 2017年 cpf. All rights reserved.
//

#import "EHWebViewController.h"
#import <WebKit/WebKit.h>

@interface EHWebViewController ()

@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, copy) NSString * source;

@property (nonatomic, copy) NSString * type;

@end

@implementation EHWebViewController

- (instancetype)initWithSource:(NSString *)source ofType:(NSString *)type {
    self = [super init];
    if (self) {
        _source = source;
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
//    [self.view addSubview:self.webView];
    [self configWebView];
    [self loadHTML];
}

- (void)configWebView {
    //WKWebViewConfiguration：为添加WKWebView配置信息
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent = @"EnergyHub";
    WKUserContentController * wkUController = [[WKUserContentController alloc] init];
    config.userContentController = wkUController;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:config];
    // UI代理
//    _webView.UIDelegate = self;
    // 导航代理
//    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"team.html" ofType:nil];
//    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    //加载本地html文件
//    [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    [self.view addSubview:_webView];
}

//- (UIWebView *)webView {
//    if (!_webView) {
//        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight - 64 - 10)];
//    }
//    return _webView;
//}

- (void)loadHTML {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:_source ofType:_type];
    
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
