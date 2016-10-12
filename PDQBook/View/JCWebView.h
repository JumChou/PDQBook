//
//  JCWebView.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/4.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <WebKit/WebKit.h>
@class JCWebView;

typedef NS_ENUM(NSInteger, JCWebViewMenuType) {
    JCWebViewMenuType_Copy,
    JCWebViewMenuType_Translation,
    JCWebViewMenuType_Search
};

@protocol JCWebViewDelegate <NSObject>

@optional
/**
 webView开始请求

 @param webView JCWebView
 @param request NSURLRequest
 */
- (void)JCWebView:(JCWebView *)webView startLoadingRequest:(NSURLRequest *)request;

/**
 webView完成了跳转

 @param webView   JCWebView
 @param isSuccess 是否成功
 */
- (void)JCWebView:(JCWebView *)webView didCompletedNavigationWithIsSuccess:(BOOL)isSuccess;

/**
 WebView选择Menu点击事件

 @param webView  JCWebView
 @param text     选择的文本
 @param menuType 类型
 */
- (void)JCWebView:(JCWebView *)webView didTappedMenuWithText:(NSString *)text menuType:(JCWebViewMenuType)menuType;

@end

@interface JCWebView : WKWebView

/// delegate
@property (nonatomic, weak) id<JCWebViewDelegate> delegate;
/// 加载延迟(单位s)
@property (nonatomic, assign) NSInteger loadingFinishDelay;
/// 是否已加载成功
@property (nonatomic, assign) BOOL isLoadingRequestSuccess;
/// 是否需要文章长按选择menu
@property (nonatomic, assign) BOOL isNeedPaperSelectionMenu;


#pragma mark - 使用Menu需在VC生命周期管理
- (void)addObserverForMenuNotifications;
- (void)removeObserverForMenuNotifications;
- (void)dismissPopupMenuAndKillTimer;


@end
