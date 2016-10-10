//
//  SuperViewController.h
//  PDQBook
//
//  ViewController基类
//  Created by Mr.Chou on 16/7/14.
//  Since v1.0.0
//  Copyright (c) 2016年 周 骏豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "CommonDefine.h"

@interface SuperViewController : UIViewController

/// 遮罩
@property (nonatomic, strong) UIButton *maskGuidBtn;

/// 遮罩key
@property (nonatomic, strong) NSString *maskKey;


#pragma mark - NavigationBar
/**
 *  设置标题
 */
- (void)setUpNaviTitle:(NSString *)title;

/**
 *  设置返回按钮
 */
- (void)setUpNaviBackBtn;

/**
 *  设置返回按钮
 *
 *  @param action 调用方法
 */
- (void)setUpNaviBackBtnWithAction:(SEL)action;

/**
 *  设置右侧按钮
 *
 *  @param btns 按钮们
 */
- (void)setUpNaviRightBarButtons:(NSArray<UIButton *> *)btns;



/**
 *  讨论组新消息通知处理
 */
- (void)RCIMReceiveMessageAction;

#pragma mark - Search
- (void)showSearchVC;

- (void)showSearchVCWithSearchText:(NSString *)searchText;


#pragma mark - MaskGuide
- (BOOL)isShowMaskWithKey:(NSString *)maskKey;

- (UIButton *)maskGuidBtnWithImage:(UIImage *)maskImage maskKey:(NSString *)maskKey;

- (void)maskBtnAction;



#pragma mark - ShowOrHideTabBar
- (void)showTabBarWithDuration:(CGFloat)duration;

- (void)hideTabBarWithDuration:(CGFloat)duration;



#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView;


#pragma mark - WKWebKit
- (void)clearWKWebCache;





@end
