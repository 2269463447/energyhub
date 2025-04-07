//
//  EHTeamWithdrawViewController.m
//  EnergyHub
//
//  Created by gaojuyan on 2019/10/24.
//  Copyright © 2019 EnergyHub. All rights reserved.
//

#import "EHTeamWithdrawViewController.h"
#import <WebKit/WebKit.h>
#import "EHMineService.h"

@interface EHTeamWithdrawViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) EHMineService *service;
@property (nonatomic, strong) NSDictionary *withdrawData;

@end

@implementation EHTeamWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户详情-提现";
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self startLoadData];
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
    // [wkUController addScriptMessageHandler:self name:@"updateSum"];
    [wkUController addScriptMessageHandler:self name:@"withdrawAction"];
    config.userContentController = wkUController;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) configuration:config];
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"teamWithdraw.html" ofType:nil];
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载本地html文件
    [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    [self.view addSubview:_webView];
}

- (void)startLoadData {
    
    DefineWeakSelf
    [self.service withdrawDetailWithParam:@{@"customerId": [EHUserInfo sharedUserInfo].Id ? : @"0"} successBlock:^(NSDictionary *res) {
        if ([res[@"returnCode"] isEqualToString:@"SUCCESS"]) {
            weakSelf.withdrawData = res[@"returnObj"];
            [weakSelf configWebView];
        }else {
            [MBProgressHUD showError:res[@"returnMsg"] toView:weakSelf.view];
        }
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.msg toView:weakSelf.view];
    }];
}

- (void)withdrawActionWithAccount:(NSString *)alipayAccount {
    EHLog(@"withdrawAction from js");
    if (alipayAccount && alipayAccount.length <= 0) {
        [MBProgressHUD showError:@"提现账户不能为空" toView:self.view];
        return;
    }
    // 提现
    DefineWeakSelf
    NSDictionary *params = @{@"customerId": [EHUserInfo sharedUserInfo].Id, @"aliPayAccount": alipayAccount, @"cashOutAmount": self.withdrawData};
    [self.service withdrawWithParam:params successBlock:^(NSDictionary *res) {
        if ([res[@"returnCode"] isEqualToString:@"SUCCESS"]) {
            [MBProgressHUD showSuccess:@"提现成功" toView:weakSelf.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else {
            [MBProgressHUD showError:res[@"returnMsg"] toView:weakSelf.view];
        }
    } errorBlock:^(EHError *error) {
        [MBProgressHUD showError:error.description toView:weakSelf.view];
    }];
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();//此处的completionHandler()就是调用JS方法时，`evaluateJavaScript`方法中的completionHandler
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    EHLog(@"message:::%@, body=%@", message.name, message.body);
    //  body是js中传入的参数
    if ([message.name isEqualToString:@"withdrawAction"]) {
        [self withdrawActionWithAccount:message.body];
    }
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    //EHLog(@"didStartProvisionalNavigation:::%@", webView.backForwardList.backItem.URL);
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    [self.progressView setProgress:0.0f animated:NO];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    EHLog(@"didFinishNavigation:::%@", webView.backForwardList.backItem.URL);
    NSString *withdrawJS = [NSString stringWithFormat:@"setData('%@元')", self.withdrawData];
    [self.webView evaluateJavaScript:withdrawJS completionHandler:^(id _Nullable s, NSError * _Nullable error) {
        EHLog(@"js invoke result::::%@", error.description);
    }];
}
//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    [self.progressView setProgress:0.0f animated:NO];
}
// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
}
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 首次打开teamWithdraw.html时
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - getter

- (EHMineService *)service {
    if (!_service) {
        _service = [[EHMineService alloc]init];
    }
    return _service;
}


#pragma mark - dealloc

- (void)dealloc {
    // handler可能导致内存无法释放的问题，所以dealloc时要将handler移除
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"withdrawAction"];
}

@end
