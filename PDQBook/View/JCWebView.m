//
//  JCWebView.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/4.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "JCWebView.h"
#import "CommonDefine.h"
#import "UCZProgressView.h"
#import <QBPopupMenu/QBPlasticPopupMenu.h>

@interface JCWebView () <WKNavigationDelegate> {
    CGRect menuFrame;
}

@property (nonatomic, strong) UCZProgressView *progressView;
@property (nonatomic, strong) UILabel *reloadLab;
@property (nonatomic, strong) UIButton *reloadBtn;

@property (nonatomic, strong) QBPopupMenu *popupMenu;
@property (nonatomic, strong) UIView *outsideView;
@property (nonatomic, strong) NSTimer *menuTimer;

@property (nonatomic, strong) NSURLRequest *URLRequest;

@end

@implementation JCWebView

const float ProgressView_H = 3.0f;

- (id)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    NSString *JS = @"function getRectForSelectedText() { var selection = window.getSelection(); var range = selection.getRangeAt(0); var rect = range.getBoundingClientRect(); return \"{{\" + rect.left + \",\" + rect.top + \"}, {\" + rect.width + \",\" + rect.height + \"}}\";}    function getSelectedText() { return window.getSelection().toString();}";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:JS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    if (!configuration.userContentController) {
        configuration.userContentController = [[WKUserContentController alloc] init];
    }
    [configuration.userContentController addUserScript:wkUScript];
    
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        self.navigationDelegate = self;
        
        [self addSubview:self.reloadBtn];
        [self.reloadBtn makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(107);
            make.height.equalTo(38.5);
        }];
        
        [self addSubview:self.reloadLab];
        [self.reloadLab makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.reloadBtn.top);
            make.height.equalTo(50);
        }];
        
        [self addSubview:self.outsideView];
        [self.outsideView makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(self);
            make.leading.equalTo(self.trailing);
        }];
        
        [self setUpProgressView];
        // 添加progress的KVO监听
        [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}

- (void)dealloc {
    DebugLog(@"");
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
    [self removeObserverForMenuNotifications];
}


#pragma mark - OverWrite
- (UILabel *)reloadLab {
    if (!_reloadLab) {
        _reloadLab = [[UILabel alloc] init];
        _reloadLab.text = @"网络出错啦，请点击按钮重新加载。";
        _reloadLab.backgroundColor = [UIColor clearColor];
        _reloadLab.textColor = Color_TextLightGray;
        _reloadLab.font = [UIFont defaultFontWithSize:16];
        _reloadLab.textAlignment = NSTextAlignmentCenter;
        _reloadLab.alpha = 0;
    }
    
    return _reloadLab;
}

- (UIButton *)reloadBtn {
    if (!_reloadBtn) {
        _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadBtn setTitleColor:Color_TextLightGray forState:UIControlStateNormal];
        [_reloadBtn setTitleColor:Color_TextNavy forState:UIControlStateHighlighted];
        [_reloadBtn setBackgroundImage:[UIImage imageNamed:@"JCWebView_ReloadBtnBG"] forState:UIControlStateNormal];
        _reloadBtn.titleLabel.font = [UIFont defaultFontWithSize:14.f];
        _reloadBtn.alpha = 0;
        [_reloadBtn addTarget:self action:@selector(reloadBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _reloadBtn;
}

- (UIView *)outsideView {
    if (!_outsideView) {
        _outsideView = [[UIView alloc] init];
    }
    
    return _outsideView;
}

- (void)setIsNeedPaperSelectionMenu:(BOOL)isNeedPaperSelectionMenu {
    _isNeedPaperSelectionMenu = isNeedPaperSelectionMenu;
    if (_isNeedPaperSelectionMenu) {
        [self setUpPaperMenu];
        [self addObserverForMenuNotifications];
        
    } else {
        self.popupMenu = nil;
        [self removeObserverForMenuNotifications];
    }
}

- (UCZProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UCZProgressView alloc] initProgressTextStyle];
        _progressView.alpha = 0;
    }
    return _progressView;
}

- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request {
    self.URLRequest = request;
    self.progressView.alpha = 1;
    
    if ([self.delegate respondsToSelector:@selector(JCWebView:startLoadingRequest:)]) {
        [self.delegate JCWebView:self startLoadingRequest:request];
    }
    
    return [super loadRequest:request];
}


#pragma mark - UIMenuController
//- (void)setUpMenuController {
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    UIMenuItem *menuItemTranslation = [[UIMenuItem alloc] initWithTitle:@"翻译" action:@selector(menuItemTranslationAction:)];
//    [menuController setMenuItems:@[menuItemTranslation]];
//}
//
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
////    DebugLog(@"SEL:%@, Sender:%@", NSStringFromSelector(action), sender);
//    if (action == @selector(menuItemTranslationAction:)) {
//        return YES;
//    }
//    
//    return NO;
//}
//
//- (BOOL)canBecomeFirstResponder {
//    DebugLog(@"");
//    return YES;
//}
//
//- (BOOL)canResignFirstResponder {
//    DebugLog(@"");
//    return YES;
//}

- (void)setUpPaperMenu {
    QBPopupMenuItem *itemCopy = [QBPopupMenuItem itemWithTitle:@"复制" target:self action:@selector(menuItemCopyAction)];
    QBPopupMenuItem *itemTranslate = [QBPopupMenuItem itemWithTitle:@"翻译" target:self action:@selector(menuItemTranslationAction)];
    QBPopupMenuItem *itemSearch = [QBPopupMenuItem itemWithTitle:@"搜索" target:self action:@selector(menuItemSearchAction)];
//    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithImage:[UIImage imageNamed:@"image"] target:self action:@selector(action:)];
    self.popupMenu = [[QBPlasticPopupMenu alloc] initWithItems:@[itemCopy, itemTranslate, itemSearch]];
}

- (void)addObserverForMenuNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillShowAction) name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidShowAction) name:UIMenuControllerDidShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHideAction) name:UIMenuControllerDidHideMenuNotification object:nil];
}

- (void)removeObserverForMenuNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
}

#pragma mark MenuMethod
- (void)copiedString {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPasteboardString) name:UIPasteboardChangedNotification object:nil];
    [[UIApplication sharedApplication] sendAction:@selector(copy:) to:nil from:self forEvent:nil];
}

- (void)getPasteboardString {
    NSString *copiedString = [UIPasteboard generalPasteboard].string;
    DebugLog(@"Copied String: %@",copiedString);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIPasteboardChangedNotification object:nil];
}

- (void)recursiveFindSubViewInView:(UIView*)inView {
    for (UIView *view in inView.subviews) {
        if([view isKindOfClass:[UITextView class]]) {
            DebugLog(@"Finded！！！！！！");
        } else {
            DebugLog(@"Finded View : %@", view);
            [self recursiveFindSubViewInView:view];
        }
    }
}

/**
 调用JS获得选择区域Rect

 @param completionHandler JS完成Block
 */
- (void)selectionRectInJSCompletionHandler:(void (^)(NSValue *rectValue))completionHandler {
    __block CGRect selectionRect = CGRectZero;
    [self evaluateJavaScript:@"getRectForSelectedText()" completionHandler:^(id _Nullable memo, NSError * _Nullable error) {
//        DebugLog(@"memo[%@]:%@", [NSThread currentThread], memo);
//        DebugLog(@"error[%@]:%@", [NSThread currentThread], error);
        selectionRect = CGRectFromString(memo);
        completionHandler([NSValue valueWithCGRect:selectionRect]);
    }];
}

- (void)selectionTextInJSCompletionHandler:(void (^)(NSString *selectionText))completionHandler {
    [self evaluateJavaScript:@"getSelectedText()" completionHandler:^(id _Nullable memo, NSError * _Nullable error) {
        DebugLog(@"memo[%@]:%@", [NSThread currentThread], memo);
        completionHandler(memo);
    }];
}

- (void)checkSelectionAndDealWithMenu {
    [self selectionRectInJSCompletionHandler:^(NSValue *rectValue) {
        CGRect selectionRect = [rectValue CGRectValue];
        if (CGRectEqualToRect(selectionRect, CGRectZero)) {
            [self dismissPopupMenuAndKillTimer];
        }
    }];
}

- (void)dismissPopupMenuAndKillTimer {
    [self.menuTimer invalidate];
    self.menuTimer = nil;
    if (self.popupMenu.visible) {
        DebugLog(@"Dismiss!");
        [self.popupMenu dismissAnimated:YES];
    }
}


#pragma mark MenuAction
- (void)menuItemCopyAction {
    [self selectionTextInJSCompletionHandler:^(NSString *selectionText) {
        DebugLog(@"SELECTION TEXT : %@", selectionText);
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = selectionText;
        if ([self.delegate respondsToSelector:@selector(JCWebView:didTappedMenuWithText:menuType:)]) {
            [self.delegate JCWebView:self didTappedMenuWithText:selectionText menuType:JCWebViewMenuType_Copy];
        }
    }];
}

- (void)menuItemTranslationAction {
    [self selectionTextInJSCompletionHandler:^(NSString *selectionText) {
        DebugLog(@"SELECTION TEXT : %@", selectionText);
        if ([self.delegate respondsToSelector:@selector(JCWebView:didTappedMenuWithText:menuType:)]) {
            [self.delegate JCWebView:self didTappedMenuWithText:selectionText menuType:JCWebViewMenuType_Translation];
        }
    }];
}

- (void)menuItemSearchAction {
    [self selectionTextInJSCompletionHandler:^(NSString *selectionText) {
        DebugLog(@"SELECTION TEXT : %@", selectionText);
        if ([self.delegate respondsToSelector:@selector(JCWebView:didTappedMenuWithText:menuType:)]) {
            [self.delegate JCWebView:self didTappedMenuWithText:selectionText menuType:JCWebViewMenuType_Search];
        }
    }];
}


#pragma mark UIMenuControllerNotification
- (void)menuWillShowAction {
    DebugLog(@"");
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIMenuController sharedMenuController].menuVisible = NO;
    });
    
//    menuFrame = [UIMenuController sharedMenuController].menuFrame;
//    DebugLog(@"MenuFrame:%@", NSStringFromCGRect(menuFrame));
//    [[UIMenuController sharedMenuController] setTargetRect:CGRectMake(kScreenWidth, kScreenHeight, 100, 100) inView:self];
//    [[UIMenuController sharedMenuController] update];
    
//    if (!self.popupMenu.isVisible) {
    
    if (self.popupMenu.isVisible) {
        [self.popupMenu dismissAnimated:NO];
    }
    
        [self selectionRectInJSCompletionHandler:^(NSValue *rectValue) {
            CGRect selectiongRect = [rectValue CGRectValue];
//            CGRect testRect = CGRectMake(selectiongRect.origin.x, selectiongRect.origin.y + 50, selectiongRect.size.width, selectiongRect.size.height);
            [self.popupMenu showInView:self targetRect:selectiongRect animated:YES];
            
            if (!self.menuTimer) {
                self.menuTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(checkSelectionAndDealWithMenu) userInfo:nil repeats:YES];
            }
        }];
//    }
}

- (void)menuDidShowAction {
    DebugLog(@"");
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        DebugLog(@"%@", [NSThread currentThread]);
//        [UIMenuController sharedMenuController].menuVisible = YES;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHideAction) name:UIMenuControllerDidHideMenuNotification object:nil];
//    });
}

- (void)menuDidHideAction {
    DebugLog(@"");
//    if (self.popupMenu.visible) {
//        DebugLog(@"Dismiss!");
//        [self.popupMenu dismissAnimated:YES];
//        //        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
//    }
}

- (void)menuChangeFrameAction {
    DebugLog(@"");
}



#pragma mark - PrivateMethod
- (void)setUpProgressView {
    WeakSelf(ws);
    self.progressView.animationDidStopBlock = ^{
        if ([ws.delegate respondsToSelector:@selector(JCWebView:didCompletedNavigationWithIsSuccess:)]) {
            [ws.delegate JCWebView:ws didCompletedNavigationWithIsSuccess:ws.isLoadingRequestSuccess];
        }
        ws.progressView = nil;
    };
    [self addSubview:self.progressView];
    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
}

- (void)finishNavigationWithIsSuccess:(BOOL)isSuccess {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_loadingFinishDelay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.progressView.progress = 1;
    });
    
    if (!isSuccess) {
        self.reloadBtn.alpha = 1;
        self.reloadLab.alpha = 1;
        self.isLoadingRequestSuccess = NO;
        
    } else {
        self.isLoadingRequestSuccess = YES;
        
    }
}

- (void)reloadBtnAction {
    self.reloadBtn.alpha = 0;
    self.reloadLab.alpha = 0;
    [self setUpProgressView];
    [self loadRequest:self.URLRequest];
}

- (float)randomFloatBetween:(float)num1 andLargerFloat:(float)num2 {
    int startVal = num1*10000;
    int endVal = num2*10000;
    
    int randomValue = startVal +(arc4random()%(endVal - startVal));
    float a = randomValue;
    
    return(a /10000.0);
}


#pragma mark - WKWebView KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self) {
            /*
            NSLog(@"keyPath : %@", keyPath);
            NSLog(@"ofObject : %@", object);
            NSLog(@"change : %@", change);
            NSLog(@"context : %@", context);
            */
            NSNumber *newValue = [change valueForKey:NSKeyValueChangeNewKey];
            CGFloat topValue = [self randomFloatBetween:0.81 andLargerFloat:0.95];
            if ([newValue floatValue] >= topValue) {
                self.progressView.progress = topValue;
            } else {
                self.progressView.progress = [newValue floatValue];
            }
            
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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
    [self finishNavigationWithIsSuccess:NO];
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
    [self finishNavigationWithIsSuccess:YES];
}

/*! @abstract Invoked when an error occurs during a committed main frame 加载页面失败？
 navigation.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DebugLog(@"%@", error);
    [self finishNavigationWithIsSuccess:NO];
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





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
