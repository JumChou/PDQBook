//
//  CEPointSelectWebViewController.m
//  PDQBook
//
//  Created by Mr.Chou on 2016/12/6.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "CEPointSelectWebViewController.h"
#import "JCWebView.h"
#import "CEResultViewController.h"
#import "CEInfoSubmitViewController.h"

static NSString *const kWebBookCheckUpMethodName = @"webBookCheckUp";

@interface CEPointSelectWebViewController () <WKScriptMessageHandler, JCWebViewDelegate>

@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) JCWebView *webView;

@end

@implementation CEPointSelectWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_White;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webViewConfiguration.userContentController = [[WKUserContentController alloc] init];
    [self.webViewConfiguration.userContentController addScriptMessageHandler:self name:kWebBookCheckUpMethodName];
    
    self.webView = [[JCWebView alloc] initWithFrame:CGRectZero configuration:self.webViewConfiguration];
    self.webView.loadingFinishDelay = 0;
    self.webView.isNeedPaperSelectionMenu = NO;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight+kNavBarHeight);
//        make.top.equalTo(self.view);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_CEPointSelectWebURL]];
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DebugLog(@"");
}


#pragma mark - PrivateMethod
/**
 配置NavigationBar
 */
- (void)setUpNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setUpNaviTitle:@"癌症筛查体检点选择"];
    [self setUpNaviBackBtn];
}


#pragma mark - EventAction
- (void)backBtnAction {
    [self.webViewConfiguration.userContentController removeScriptMessageHandlerForName:kWebBookCheckUpMethodName]; // 移除JS调用OC的监听
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark WKScriptMessageHandler JS调用OC方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"JS - UserContentConroller:%@ 调用了 %@ 方法，传回参数 %@", userContentController, message.name, message.body);
    if ([message.name isEqualToString:kWebBookCheckUpMethodName]) { // web点击预约
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"BiuBiuBiu~~~" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }]];
//        [alert show];
        CEInfoSubmitViewController *infoVC = [CEInfoSubmitViewController new];
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}






@end
