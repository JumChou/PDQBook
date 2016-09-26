//
//  ViewController.m
//  PDQBook
//
//  Created by Mr.Chou on 16/7/8.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) NSURL *webURL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    webViewConfiguration.userContentController = [[WKUserContentController alloc] init];
    [webViewConfiguration.userContentController addScriptMessageHandler:self name:@"callAppMethod"];
    [webViewConfiguration.userContentController addScriptMessageHandler:self name:@"AppModel"];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webViewConfiguration];
    self.webView.backgroundColor = [UIColor yellowColor];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
//        UIView *topLayoutGuide = (UIView *)self.topLayoutGuide;
//        make.top.equalTo(topLayoutGuide.bottom);
        make.top.equalTo(self.view);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.alpha = 1;
    self.progressView.trackTintColor = [UIColor clearColor];
    [self.view addSubview:self.progressView];
    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight+kNavBarHeight);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(3);
    }];
    
//    webView.allowsBackForwardNavigationGestures = YES;
    // 添加progress的KVO监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    //self.webURL = [NSURL URLWithString:@"http://t.wehealth.mobi/web/app.html"];
    self.webURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test.html" ofType:nil]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.webURL]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setUpNaviBackBtn];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 29, 25);
    [btnBack addTarget:self action:@selector(callJSFunction) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnBack setTitleColor:Color_Blue forState:UIControlStateHighlighted];
    [btnBack setTitle:@"Go" forState:UIControlStateNormal];
//    [btnBack setBackgroundImage:[UIImage imageNamed:@"Navi_Back"] forState:UIControlStateNormal];
//    [btnBack setBackgroundImage:[UIImage imageNamed:@"icon_navi_back"] forState:UIControlStateHighlighted];
    
    UIButton *btnClearCache = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClearCache.frame = CGRectMake(0, 0, 60, 25);
    [btnClearCache addTarget:self action:@selector(clearWebCache) forControlEvents:UIControlEventTouchUpInside];
    [btnClearCache setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClearCache setTitleColor:Color_Blue forState:UIControlStateHighlighted];
    [btnClearCache setTitle:@"Clear" forState:UIControlStateNormal];
    
    UIButton *btnReload = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReload.frame = CGRectMake(0, 0, 60, 25);
    [btnReload addTarget:self action:@selector(reloadWeb) forControlEvents:UIControlEventTouchUpInside];
    [btnReload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnReload setTitleColor:Color_Blue forState:UIControlStateHighlighted];
    [btnReload setTitle:@"Reload" forState:UIControlStateNormal];
    
    UIBarButtonItem *btnBackItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    UIBarButtonItem *btnClearCacheItem = [[UIBarButtonItem alloc] initWithCustomView:btnClearCache];
    UIBarButtonItem *btnReloadItem = [[UIBarButtonItem alloc] initWithCustomView:btnReload];
//    self.navigationItem.rightBarButtonItem = btnBackItem;
    self.navigationItem.rightBarButtonItems = @[btnReloadItem, btnClearCacheItem, btnBackItem];
}


#pragma mark - Method
- (void)reloadWeb {
    [self.webView reload];
}

- (void)clearWebCache {
    if (iOS9_OR_LATER) {
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                         completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                             for (WKWebsiteDataRecord *record in records) {
//                                 if ( [record.displayName containsString:@"baidu"]) {
                                     [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                               forDataRecords:@[record]
                                                                            completionHandler:^{
                                                                                NSLog(@"Cookies for %@ deleted successfully", record.displayName);
                                                                            }];
//                                 }
                             }
                         }];
        
    } else if (iOS8_OR_LATER) {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

- (void)callJSFunction {
    // javaScriptString是JS方法名，completionHandler是异步回调block
    [self.webView evaluateJavaScript:@"test('111')" completionHandler:^(id _Nullable memo, NSError * _Nullable error) {
        DebugLog(@"memo:%@", memo);
        DebugLog(@"error:%@", error);
    }];
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"JS - UserContentConroller:%@ 调用了 %@ 方法，传回参数 %@", userContentController, message.name, message.body);
}


#pragma mark - WKNavigationDelegate
/*! @abstract Decides whether to allow or cancel a navigation. 请求事件
 @param webView The web view invoking the delegate method.
 @param navigationAction Descriptive information about the action
 triggering the navigation request.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
 @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    DebugLog(@"%@", navigationAction);
    decisionHandler(WKNavigationActionPolicyAllow);
}

/*! @abstract Decides whether to allow or cancel a navigation after its
 response is known. 请求response
 @param webView The web view invoking the delegate method.
 @param navigationResponse Descriptive information about the navigation
 response.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
 @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    DebugLog(@"%@", navigationResponse);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/*! @abstract Invoked when a main frame navigation starts. 页面开始加载
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    DebugLog(@"");
}

/*! @abstract Invoked when a server redirect is received for the main
 frame. 页面重定向
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    DebugLog(@"");
}

/*! @abstract Invoked when an error occurs while starting to load data for
 the main frame. 加载数据失败
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DebugLog(@"%@", error);
}

/*! @abstract Invoked when content starts arriving for the main frame. 页面内容已经到达？
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    DebugLog(@"");
}

/*! @abstract Invoked when a main frame navigation completes. 加载完毕
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    DebugLog(@"");
}

/*! @abstract Invoked when an error occurs during a committed main frame 加载页面失败？
 navigation.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DebugLog(@"%@", error);
}

/*! @abstract Invoked when the web view needs to respond to an authentication challenge.
 @param webView The web view that received the authentication challenge.
 @param challenge The authentication challenge.
 @param completionHandler The completion handler you must invoke to respond to the challenge. The
 disposition argument is one of the constants of the enumerated type
 NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
 the credential argument is the credential to use, or nil to indicate continuing without a
 credential.
 @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
 */
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *_Nullable credential))completionHandler {
//    
//}

/*! @abstract Invoked when the web view's web content process is terminated. 页面内容加载中断
 @param webView The web view whose underlying web content process was terminated.
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0) {
    DebugLog(@"");
}


#pragma mark - WKWebViewUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    DebugLog(@"");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:@"JS调用alert" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);
}



#pragma mark - WKWebView KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.webView) {
            NSLog(@"keyPath : %@", keyPath);
            NSLog(@"ofObject : %@", object);
            NSLog(@"change : %@", change);
            NSLog(@"context : %@", context);
            NSNumber *newValue = [change valueForKey:NSKeyValueChangeNewKey];
            NSLog(@"change.newValue : %@", newValue);
            
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:[newValue floatValue] animated:YES];
            
            if ([newValue floatValue] >= 1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
                
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



@end
