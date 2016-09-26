//
//  JCWebView.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/4.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <WebKit/WebKit.h>
@class JCWebView;

@protocol JCWebViewDelegate <NSObject>

@optional
/**
 webView开始请求

 @param webView JCWebView
 @param request NSURLRequest
 */
- (void)JCwebView:(JCWebView *)webView startLoadingRequest:(NSURLRequest *)request;

/**
 webView完成了跳转

 @param webView   JCWebView
 @param isSuccess 是否成功
 */
- (void)JCwebView:(JCWebView *)webView didCompletedNavigationWithIsSuccess:(BOOL)isSuccess;

@end

@interface JCWebView : WKWebView

@property (nonatomic, assign) NSInteger loadingFinishDelay;
@property (nonatomic, weak) id<JCWebViewDelegate> delegate;
@property (nonatomic, assign) BOOL isLoadingRequestSuccess;


@end
