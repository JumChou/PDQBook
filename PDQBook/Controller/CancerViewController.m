//
//  CancerViewController.m
//  PDQBook
//
//  Created by Mr.Chou on 16/7/18.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "CancerViewController.h"
#import "JCTabBarView.h"
#import "CancerPaperViewController.h"
#import "JCWebView.h"

static NSString *const kWebDocListDidSelectedMethodName = @"WebDocListDidSelected";

static NSString *const kWebViewDicKey_WebView = @"WebView";
static NSString *const kWebViewDicKey_IsLoaded = @"IsLoaded";
static NSString *const kWebViewDicKey_WebViewIndex = @"WebViewIndex";


@interface CancerViewController () <UIScrollViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, JCTabBarViewDelegate>
{
    NSDictionary *cancerWebSection;
    NSArray *tabBarNames;
    BOOL isNaviToPaper;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) JCTabBarView *tabBarView;
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *webViewDics;
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;

@property (nonatomic, assign) BOOL isScrolledByTabBar;


@end

@implementation CancerViewController

#pragma mark - LifeCircle
- (id)initWithCancer:(Cancer *)cancer {
    self = [self init];
    if (self) {
//        cancerWebSection = @{@"0":@"Treatment", @"1":@"yanjiu", @"2":@"Prevention", @"3":@"Screening"};
//        tabBarNames = @[@"治疗", @"研究", @"预防", @"筛查"];
        cancerWebSection = @{@"0":@"Prevention", @"1":@"Screening", @"2":@"Treatment"};
        tabBarNames = @[@"预防", @"筛查", @"治疗"];
        
        self.webViewDics = [NSMutableArray array];
        self.cancer = cancer;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake((kStatusBarHeight+kNavBarHeight), 0, kTabBarHeight, 0));
    }];
    
    self.scrollContentView = [UIView new];
    [self.scrollView addSubview:self.scrollContentView];
    [self.scrollContentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    self.webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webViewConfiguration.userContentController = [[WKUserContentController alloc] init];
    [self.webViewConfiguration.userContentController addScriptMessageHandler:self name:kWebDocListDidSelectedMethodName];
//    [webViewConfiguration.userContentController addUserScript:wkUScript];
//    self.webViewConfiguration.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
    
    JCWebView *lastWebView;
    for (int i = 0; i < cancerWebSection.allKeys.count; i++) {
        JCWebView *webView = [[JCWebView alloc] initWithFrame:CGRectZero configuration:self.webViewConfiguration];
        webView.backgroundColor = [UIColor lightGrayColor];
        webView.loadingFinishDelay = 1;
        webView.UIDelegate = self;
        [self.scrollContentView addSubview:webView];
        [webView makeConstraints:^(MASConstraintMaker *make) {
            if (!lastWebView) {
                make.leading.equalTo(self.scrollContentView);
            } else {
                make.leading.equalTo(lastWebView.trailing);
            }
            make.top.bottom.equalTo(self.scrollContentView);
            make.width.equalTo(self.scrollView);
        }];
        lastWebView = webView;
        
        NSMutableDictionary *webViewDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:webView, kWebViewDicKey_WebView,
                                                                                            @NO, kWebViewDicKey_IsLoaded,
                                                                                            [NSNumber numberWithInt:i], kWebViewDicKey_WebViewIndex, nil];
        [self.webViewDics addObject:webViewDic];
    }
    [self loadWebViewWithIndex:0]; // 加载第一页
    
    [self.scrollContentView remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
        make.trailing.equalTo(lastWebView);
    }];
    
    self.tabBarView = [[JCTabBarView alloc] initWithTitles:tabBarNames btnBasicIMGName:@"CancerTabBarBtn"];
    self.tabBarView.delegate = self;
    [self.view addSubview:self.tabBarView];
    [self.tabBarView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(kTabBarHeight);
    }];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DebugLog(@"");
    [self clearWKWebCache];
}


#pragma mark - PrivateMethod
/**
 配置NavigationBar
 */
- (void)setUpNavigationBar {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setTitle:self.cancer.name];
    [self setUpNaviBackBtnWithAction:@selector(backBtnAction)];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 20, 19.6);
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"Navi_SearchBtn"] forState:UIControlStateNormal];
    
    UIButton *descBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    descBtn.frame = CGRectMake(0, 0, 15, 20.5);
    [descBtn addTarget:self action:@selector(descBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [descBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [descBtn setBackgroundImage:[UIImage imageNamed:@"Navi_CancerDescBtn"] forState:UIControlStateNormal];
    
    [self setUpNaviRightBarButtons:@[searchBtn]];
}

/**
 根据索引值加载webView

 @param index 索引
 */
- (void)loadWebViewWithIndex:(NSUInteger)index {
    if (self.webViewDics && self.webViewDics.count && index < self.webViewDics.count) {
        if (![[self.webViewDics[index] valueForKey:kWebViewDicKey_IsLoaded] boolValue]) {
            NSString *cancerIdStr = [NSString stringWithFormat:@"%zd", self.cancer.cancerId];
            NSString *sectionIndexStr = [NSString stringWithFormat:@"%zd", index];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:Get_CancerWebURL(cancerIdStr, [cancerWebSection valueForKey:sectionIndexStr])]];
//            if (index == 1) {
//                request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//            }
            JCWebView *webView = [[self.webViewDics objectAtIndex:index] valueForKey:kWebViewDicKey_WebView];
            [webView loadRequest:request];
            
            [self.webViewDics[index] setValue:@YES forKey:kWebViewDicKey_IsLoaded];
            
        }
    }
}


#pragma mark - EventAction
- (void)backBtnAction {
    #warning Web目录点击修改
    if (isNaviToPaper) { // 返回文章目录
//        [self.webView evaluateJavaScript:@"test('111')" completionHandler:^(id _Nullable memo, NSError * _Nullable error) {
//            DebugLog(@"memo:%@", memo);
//            DebugLog(@"error:%@", error);
//        }];
        
    } else { // 返回MainVC
        [self.webViewConfiguration.userContentController removeScriptMessageHandlerForName:kWebDocListDidSelectedMethodName];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)searchBtnAction {
    [self showSearchVC];
}

- (void)descBtnAction {
    
}


#pragma mark - JCTabBarViewDelegate
- (void)tabBarView:(JCTabBarView *)tabBarView didSelectedIndex:(NSUInteger)selectedIndex {
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = selectedIndex * kScreenWidth;
    self.isScrolledByTabBar = YES;
    [self.scrollView setContentOffset:contentOffset animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    DebugLog(@"----------------------\nOffSet:%f", scrollView.contentOffset.x);
    if (!self.isScrolledByTabBar) { // 用户滑动操作滚动
        CGFloat xOffsetRatio = scrollView.contentOffset.x / (cancerWebSection.count * kScreenWidth);   // 滚动比例
        NSUInteger index = scrollView.contentOffset.x / kScreenWidth;           // 当前滚到的index
        CGFloat remainder = fmodf(scrollView.contentOffset.x, kScreenWidth);    // 当前index多的余数
        
        [self.tabBarView changeMarkerWithXOffsetRatio:xOffsetRatio];
        if (remainder > kScreenWidth/2) {
            [self.tabBarView changeToSelectedIndex:index + 1];
        } else {
            [self.tabBarView changeToSelectedIndex:index];
        }
        
    } else { // tabBar点击操作产生的滚动
        
    }
}


/**
 用户操作滚动停止

 @param scrollView scrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    DebugLog(@"OffSet:%f", scrollView.contentOffset.x);
    NSUInteger selectedIndex = scrollView.contentOffset.x/kScreenWidth;
    [self.tabBarView changeToSelectedIndex:selectedIndex];
    [self loadWebViewWithIndex:selectedIndex];
}

/**
 代码动画滚动停止

 @param scrollView scrollView
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.isScrolledByTabBar = NO;
    NSUInteger selectedIndex = scrollView.contentOffset.x/kScreenWidth;
    [self loadWebViewWithIndex:selectedIndex];
}


#pragma mark - WKScriptMessageHandler JS调用OC方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"JS - UserContentConroller:%@ 调用了 %@ 方法，传回参数 %@", userContentController, message.name, message.body);
    if ([message.name isEqualToString:kWebDocListDidSelectedMethodName]) { // web文章列表点击事件
        NSString *paperURLStr = [[message.body valueForKey:@"body"] valueForKey:@"link"];
        NSString *paperName = [[message.body valueForKey:@"body"] valueForKey:@"title"];
        DebugLog(@"%@ = '%@'", paperName, paperURLStr);
        CancerPaperViewController *paperVC = [[CancerPaperViewController alloc] initWithPaperURL:paperURLStr];
        paperVC.paperName = paperName;
        [self.navigationController pushViewController:paperVC animated:YES];
        
        #warning Web目录点击修改
    }
}

/*
#pragma mark - WKWebView KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
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
}
*/










@end
