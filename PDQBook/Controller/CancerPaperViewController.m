//
//  CancerDocViewController.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/4.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "CancerPaperViewController.h"
#import "JCWebView.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>
#import "JCSwitchLanguageBtn.h"

static NSString *const kWebSectionDidSelected = @"WebSectionDidSelected";

static const CGFloat kSwitchLanguageBtn_W = 60.f;
static const CGFloat kSwitchLanguageBtn_Padding = 46.f;

@interface CancerPaperViewController () <WKScriptMessageHandler, JCWebViewDelegate>

@property (nonatomic, strong) JCWebView *webView;
@property (nonatomic, strong) VBFPopFlatButton *sectionsBtn;
@property (nonatomic, strong) JCSwitchLanguageBtn *switchLanguageBtn;

@end

@implementation CancerPaperViewController

- (id)initWithPaperURL:(NSString *)paperURL {
    self = [super init];
    if (self) {
        self.paperURL = paperURL;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    webViewConfiguration.userContentController = [[WKUserContentController alloc] init];
    [webViewConfiguration.userContentController addScriptMessageHandler:self name:kWebSectionDidSelected];
    self.webView = [[JCWebView alloc] initWithFrame:CGRectZero configuration:webViewConfiguration];
    self.webView.backgroundColor = [UIColor lightGrayColor];
    self.webView.loadingFinishDelay = 2;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight+kNavBarHeight);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.paperURL]];
    [self.webView loadRequest:request];
    
    if (self.language == SRLanguage_EN) {
        self.switchLanguageBtn = [JCSwitchLanguageBtn buttonWithStatus:SwitchLanguageBtnStatus_EN];
    } else {
        self.switchLanguageBtn = [JCSwitchLanguageBtn buttonWithStatus:SwitchLanguageBtnStatus_CN];
    }
//    [self.switchLanguageBtn setBackgroundColor:Color_Blue];
//    self.switchLanguageBtn.layer.cornerRadius = (kSwitchLanguageBtn_W/2.f);
//    self.switchLanguageBtn.alpha = 0.8;
    self.switchLanguageBtn.alpha = 0;
    [self.switchLanguageBtn addTarget:self action:@selector(switchLanguageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchLanguageBtn];
    [self.switchLanguageBtn makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-kSwitchLanguageBtn_Padding);
        make.bottom.equalTo(self.view).offset(-kSwitchLanguageBtn_Padding);
        make.width.equalTo(kSwitchLanguageBtn_W);
        make.height.equalTo(kSwitchLanguageBtn_W);
    }];
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
    [self setUpNaviBackBtn];
    [self setUpNaviTitle:self.paperName];
    
    self.sectionsBtn = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)
                                                    buttonType:buttonMenuType
                                                   buttonStyle:buttonPlainStyle
                                         animateToInitialState:NO];
    self.sectionsBtn.lineThickness = 2;
    self.sectionsBtn.lineRadius = 2;
    self.sectionsBtn.tintColor = [UIColor whiteColor];
    [self.sectionsBtn addTarget:self action:@selector(sectionsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.switchLanguageBtn = [JCSwitchLanguageBtn buttonWithStatus:SwitchLanguageBtnStatus_CN];
//    [self.switchLanguageBtn addTarget:self action:@selector(switchLanguageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.switchLanguageBtn.frame = CGRectMake(0, 0, 30, 30);
    
    [self setUpNaviRightBarButtons:@[self.sectionsBtn]];
}


#pragma mark - EventAction
- (void)switchLanguageBtnAction:(id)sender {
    [self.webView evaluateJavaScript:@"slideLanguage()" completionHandler:^(id _Nullable memo, NSError * _Nullable error) {
        DebugLog(@"memo:%@", memo);
        DebugLog(@"error:%@", error);
    }];
}

- (void)sectionsBtnAction:(VBFPopFlatButton *)sender {
    if (sender.currentButtonType == buttonMenuType) {
        sender.currentButtonType = buttonCloseType;
        [self.webView evaluateJavaScript:@"PagePopover.showSelfMeau()" completionHandler:^(id _Nullable memo, NSError * _Nullable error) {
            DebugLog(@"memo:%@", memo);
            DebugLog(@"error:%@", error);
        }];
        
    } else if (sender.currentButtonType == buttonCloseType) {
        sender.currentButtonType = buttonMenuType;
        [self.webView evaluateJavaScript:@"PagePopover.HideSelfMeau()" completionHandler:^(id _Nullable memo, NSError * _Nullable error) {
            DebugLog(@"memo:%@", memo);
            DebugLog(@"error:%@", error);
        }];
    }
    /*
    if (sender.selected) {
        sender.selected = NO;
        [self.webView evaluateJavaScript:@"PagePopover.HideSelfMeau()" completionHandler:^(id _Nullable memo, NSError * _Nullable error) {
            DebugLog(@"memo:%@", memo);
            DebugLog(@"error:%@", error);
        }];
        
    } else {
        sender.selected = YES;
        [self.webView evaluateJavaScript:@"PagePopover.showSelfMeau()" completionHandler:^(id _Nullable memo, NSError * _Nullable error) {
            DebugLog(@"memo:%@", memo);
            DebugLog(@"error:%@", error);
        }];
    }
     */
}


#pragma mark - JCWebViewDelegate
- (void)JCwebView:(JCWebView *)webView startLoadingRequest:(NSURLRequest *)request {
    self.switchLanguageBtn.alpha = 0;
}

- (void)JCwebView:(JCWebView *)webView didCompletedNavigationWithIsSuccess:(BOOL)isSuccess {
    [UIView animateWithDuration:0.3f animations:^{
        self.switchLanguageBtn.alpha = 1;
    }];
}


#pragma mark - WKScriptMessageHandler JS调用OC方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"JS - UserContentConroller:%@ 调用了 %@ 方法，传回参数 %@", userContentController, message.name, message.body);
    if ([message.name isEqualToString:kWebSectionDidSelected]) { // web文章Section点击事件
        self.sectionsBtn.currentButtonType = buttonMenuType;
    }
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
