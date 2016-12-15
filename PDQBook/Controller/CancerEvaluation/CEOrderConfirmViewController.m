//
//  CEOrderConfirmViewController.m
//  PDQBook
//
//  Created by Mr.Chou on 2016/12/12.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "CEOrderConfirmViewController.h"
#import "JCWebView.h"

@interface CEOrderConfirmViewController () <WKScriptMessageHandler, JCWebViewDelegate>

@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) JCWebView *webView;

@end

@implementation CEOrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_White;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webViewConfiguration.userContentController = [[WKUserContentController alloc] init];
//    [self.webViewConfiguration.userContentController addScriptMessageHandler:self name:kWebBookCheckUpMethodName];
    
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_CEOrderConfirmWebURL]];
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
    [self setUpNaviTitle:@"订单确认"];
    [self setUpNaviBackBtn];
}


#pragma mark - EventAction
- (void)backBtnAction {
//    [self.webViewConfiguration.userContentController removeScriptMessageHandlerForName:kWebBookCheckUpMethodName]; // 移除JS调用OC的监听
    [self.navigationController popViewControllerAnimated:YES];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
