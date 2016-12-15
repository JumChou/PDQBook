//
//  CEInfoSubmitViewController.m
//  PDQBook
//
//  Created by Mr.Chou on 2016/12/12.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "CEInfoSubmitViewController.h"
#import "JCWebView.h"
#import "CEOrderConfirmViewController.h"

static NSString *const kWebSubmitMethodName = @"WebInfoSubmit";

@interface CEInfoSubmitViewController () <WKScriptMessageHandler, JCWebViewDelegate>

@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) JCWebView *webView;

@end

@implementation CEInfoSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_White;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webViewConfiguration.userContentController = [[WKUserContentController alloc] init];
    [self.webViewConfiguration.userContentController addScriptMessageHandler:self name:kWebSubmitMethodName];
    
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_CEInfoSubmitWebURL]];
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


#pragma mark - PrivateMethod
/**
 配置NavigationBar
 */
- (void)setUpNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setUpNaviTitle:@"信息填写"];
    [self setUpNaviBackBtn];
}


#pragma mark - EventAction
- (void)backBtnAction {
    [self.webViewConfiguration.userContentController removeScriptMessageHandlerForName:kWebSubmitMethodName]; // 移除JS调用OC的监听
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark WKScriptMessageHandler JS调用OC方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"JS - UserContentConroller:%@ 调用了 %@ 方法，传回参数 %@", userContentController, message.name, message.body);
    if ([message.name isEqualToString:kWebSubmitMethodName]) { // web点击提交
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认要提交吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            CEOrderConfirmViewController *orderConfirmVC = [CEOrderConfirmViewController new];
            [self.navigationController pushViewController:orderConfirmVC animated:YES];
        }]];
        [alert show];
    }
}




@end
