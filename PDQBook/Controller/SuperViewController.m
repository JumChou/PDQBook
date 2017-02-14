//
//  SuperViewController.h
//  PDQBook
//
//  ViewController基类
//  Created by Mr.Chou on 16/7/14.
//  Since v1.0.0
//  Copyright (c) 2016年 周 骏豪. All rights reserved.
//

#import "SuperViewController.h"
#import "DRNRealTimeBlurView.h"
#import "SearchViewController.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>
//#import "WHTabBarController.h"
//#import "UserGroupListViewController.h"
//#import "CWStatusBarNotification.h"

@interface SuperViewController () <UIWebViewDelegate>

@property (nonatomic, strong) DRNRealTimeBlurView *blurView;
@property (nonatomic, strong) UITextField *textField;
//@property (nonatomic, strong) CWStatusBarNotification *statusBarMsg;

@end

@implementation SuperViewController

#pragma mark - LifeCircle
- (id)init {
    self = [super init];
    if (self) {
//        self.statusBarMsg = [CWStatusBarNotification new];
//        
//        // set default blue color (since iOS 7.1, default window tintColor is black)
//        self.statusBarMsg.notificationLabelBackgroundColor = Color_TextYellow;
//        self.statusBarMsg.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
//        self.statusBarMsg.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RCIMReceiveMessageAction) name:Notifi_RCIMReceiveMessage object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationShortcutAction:) name:Notifi_ApplicationShortcut object:nil];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];  // 清理NSURLCache的CachedResponse
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notifi_ApplicationShortcut object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notifi_RCIMReceiveMessage object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = Color_Blue;
    self.navigationController.navigationBar.barTintColor = Color_NavigationBG;
    self.navigationController.navigationBar.barTintColor = Color_Navy;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navi_bar_normal"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    // 这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont defaultFontWithSize:19]}];
    
    [self setNeedsStatusBarAppearanceUpdate]; // 注：在navigation栈中会失效
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; // 设置statusBar
}



#pragma mark - StatusBar
/// 回调设置StatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}




#pragma mark - NavigationBar
/**
 *  设置标题
 */
- (void)setUpNaviTitle:(NSString *)title {
    self.navigationItem.title = title;
}

/**
 *  设置返回按钮
 */
- (void)setUpNaviBackBtn {
    [self setUpNaviBackBtnWithAction:@selector(naviBackBtnAction)];
}

/**
 *  设置返回按钮
 *
 *  @param action 调用方法
 */
- (void)setUpNaviBackBtnWithAction:(SEL)action {
    // 返回按钮
//    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnBack.frame = CGRectMake(0, 0, 13.5, 23.5);
//    [btnBack addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnBack setBackgroundImage:[UIImage imageNamed:@"Navi_Back"] forState:UIControlStateNormal];
//    UIBarButtonItem *btnBackItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    VBFPopFlatButton *backBtn = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)
                                                                 buttonType:buttonBackType
                                                                buttonStyle:buttonPlainStyle
                                                      animateToInitialState:NO];
    backBtn.lineThickness = 2;
    backBtn.lineRadius = 2;
    backBtn.tintColor = [UIColor whiteColor];
    [backBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem = backBtnItem;
}

- (void)naviBackBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpNaviRightBarButtons:(NSArray<UIButton *> *)btns {
    NSMutableArray *rightBarButtonItems = [NSMutableArray array];
    for (int i = 0; i < btns.count; i++) {
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:[btns objectAtIndex:i]];
        [rightBarButtonItems addObject:btnItem];
    }
    
    if (rightBarButtonItems.count) {
        self.navigationItem.rightBarButtonItems = rightBarButtonItems;
    }
}


#pragma mark - HandleNotification
/**
 *  讨论组新消息通知处理
 */
- (void)RCIMReceiveMessageAction {
//    [self.statusBarMsg displayNotificationWithMessage:@"讨论组收到新消息了哦，点击可查看~" forDuration:3.0f];
//    __weak typeof(self) weakSelf = self;
//    self.statusBarMsg.notificationTappedBlock = ^(void) {
////        [weakSelf.statusBarMsg dismissNotification]; // 通常需要先隐藏状态栏通知.
////        UserGroupListViewController * listView = [UserGroupListViewController new];
////        [weakSelf.navigationController pushViewController:listView animated:YES];
//    };
}

- (void)applicationShortcutAction:(NSDictionary *)userInfo {
    DebugLog(@"UserInfo:%@", userInfo);
    [self showSearchVC];
}


#pragma mark - Search
- (void)showSearchVC {
    [self showSearchVCWithSearchText:nil];
}

- (void)showSearchVCWithSearchText:(NSString *)searchText {
    if ([Singleton shareInstance].isShowingSearchVC) {
        return;
    }
    
    SearchViewController *searchVC = [SearchViewController new];
    UINavigationController *searchNavi = [[UINavigationController alloc] initWithRootViewController:searchVC];
    if ([searchNavi respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        searchNavi.interactivePopGestureRecognizer.delegate = nil;
    }
    
    [self presentViewController:searchNavi animated:YES completion:^{
        if (searchText && searchText.length) {
            [searchVC searchWithText:searchText];
        }
    }];
}


/**
 废弃
 */
- (void)becomeSearchStatus {
    self.blurView = [[DRNRealTimeBlurView alloc] initWithFrame:self.view.frame tintColor:Color_GrayBig opacity:0.5 cornerRadius:0];
    self.blurView.alpha = 0;
    [self.view addSubview:self.blurView];
    [self.blurView setRenderStatic:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSearchStatus)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.blurView addGestureRecognizer:tapGestureRecognizer];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.navigationController.navigationBar.alpha = 0;
    
    self.textField = [UITextField new];
    self.textField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.textField.alpha = 0;
    [self.view addSubview:self.textField];
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.top);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(100);
    }];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.blurView.alpha = 1;
//        self.navigationController.navigationBar.alpha = 1;
        
    } completion:^(BOOL finished) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.textField becomeFirstResponder];
    }];
}

/**
 废弃
 */
- (void)cancelSearchStatus {
    [self.textField resignFirstResponder];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.blurView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self.blurView removeFromSuperview];
        [self.textField removeFromSuperview];
    }];
}



#pragma mark - MaskGuide
- (BOOL)isShowMaskWithKey:(NSString *)maskKey {
    NSDictionary *maskGuidDic = [NSDictionary dictionaryWithContentsOfFile:MaskGuidPlistPath];
    
    BOOL isShow = [[maskGuidDic valueForKey:maskKey] boolValue];
    return isShow;
}


- (UIButton *)maskGuidBtnWithImage:(UIImage *)maskImage maskKey:(NSString *)maskKey {
    UIButton *maskGuidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maskGuidBtn.backgroundColor = [UIColor clearColor];
    [maskGuidBtn setBackgroundImage:maskImage forState:UIControlStateNormal];
    maskGuidBtn.titleLabel.text = maskKey;
    [maskGuidBtn addTarget:self action:@selector(maskBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    return maskGuidBtn;
}


- (void)maskBtnAction {
    if (self.maskGuidBtn) {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskGuidBtn.alpha = 0;
            
        } completion:^(BOOL finished) {
            NSMutableDictionary *maskGuideDic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:MaskGuidPlistPath]];
            NSString *maskKey = self.maskGuidBtn.titleLabel.text;
            if (maskKey) {
                [maskGuideDic setValue:[NSNumber numberWithBool:NO] forKey:maskKey];
                [maskGuideDic writeToFile:MaskGuidPlistPath atomically:YES];
            }
            
            [self.maskGuidBtn removeFromSuperview];
            self.maskGuidBtn = nil;
        }];
    }
}


#pragma mark - ShowOrHideTabBar
- (void)showTabBarWithDuration:(CGFloat)duration {
//    [UIView animateWithDuration:duration animations:^{
//        WHTabBarController *tabBarController = (WHTabBarController *)self.tabBarController;
//        tabBarController.tabBar.transform = CGAffineTransformIdentity;
//        tabBarController.bgView.transform = CGAffineTransformIdentity;
//    } completion:nil];
}


- (void)hideTabBarWithDuration:(CGFloat)duration {
//    [UIView animateWithDuration:duration animations:^{
//        WHTabBarController *tabBarController = (WHTabBarController *)self.tabBarController;
//        tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0, kTabBarHeight);
//        tabBarController.bgView.transform = CGAffineTransformMakeTranslation(0, kTabBarHeight);
//    } completion:nil];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"]; // 关闭缓存（不必担心这个WebKitCacheModelPreferenceKey会一直保持为0。因为每一次UIWebView加载页面的时候，都会把此值设置为1）
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


#pragma mark - WKWebKit
- (void)clearWKWebCache {
    if (iOS9_OR_LATER) {
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                         completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                             for (WKWebsiteDataRecord *record in records) {
//                                 if ( [record.displayName containsString:@"baidu"]) {
                                 [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                           forDataRecords:@[record]
                                                                        completionHandler:^{
                                                                            NSLog(@"Cookies for %@ deleted successfully", record.displayName);
                                                                        }];
//                                 }
                             }
                         }];
        
    } else if (iOS8_OR_LATER) {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:nil];
    }
}





@end
