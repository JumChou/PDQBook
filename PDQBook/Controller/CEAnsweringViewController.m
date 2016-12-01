//
//  CEAnsweringViewController.m
//  PDQBook
//
//  Created by Mr.Chou on 2016/11/29.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "CEAnsweringViewController.h"
#import "JCWebView.h"
#import "CEResultViewController.h"

@interface CEAnsweringViewController () <WKScriptMessageHandler, JCWebViewDelegate>

@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) JCWebView *webView;

@end

@implementation CEAnsweringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_White;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webViewConfiguration.userContentController = [[WKUserContentController alloc] init];
//    [self.webViewConfiguration.userContentController addScriptMessageHandler:self name:kWebSectionDidSelected];
    self.webView = [[JCWebView alloc] initWithFrame:CGRectZero configuration:self.webViewConfiguration];
    self.webView.backgroundColor = [UIColor lightGrayColor];
    self.webView.scrollView.bounces = NO;
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_CEWebURL]];
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
    [self setUpNaviTitle:@"癌症风险评估"];
    [self setUpNaviBackBtnWithAction:@selector(backBtnAction)];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    finishBtn.backgroundColor = Color_White;
    finishBtn.frame = CGRectMake(0, 0, 50, 50);
    finishBtn.titleLabel.font = [UIFont defaultFontWithSize:17.f];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setUpNaviRightBarButtons:@[finishBtn]];
}


#pragma mark - EvenAction
- (void)backBtnAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定要放弃此次评估吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        [self clearWKWebCache];
    }]];
    [alert show];
}

- (void)finishBtnAction {
    CEResultViewController *resultVC = [[CEResultViewController alloc] init];
    [self.navigationController pushViewController:resultVC animated:YES];
}


#pragma mark WKScriptMessageHandler JS调用OC方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"JS - UserContentConroller:%@ 调用了 %@ 方法，传回参数 %@", userContentController, message.name, message.body);
//    if ([message.name isEqualToString:kWebSectionDidSelected]) { // web文章Section点击事件
//        self.sectionsBtn.currentButtonType = buttonMenuType;
//    }
}






@end
