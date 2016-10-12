//
//  AppDelegate.m
//  PDQBook
//
//  Created by Mr.Chou on 16/7/8.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ViewController.h"
#import "Cancer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initApp];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainViewController *mainVC = [MainViewController new];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    if ([naviController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        ((UINavigationController *)naviController).interactivePopGestureRecognizer.delegate = nil;
    }
    
    self.window.rootViewController = naviController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - InitApp
- (void)initApp {
//    [NSThread sleepForTimeInterval:0.3f];  // 延迟启动页展示
    [DBManager shareInstance];          // 初始化数据库操作
    
    [self initAFNetWorkingReachability];
    [self initCancleList];
    
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    DebugLog(@"AppLanguages:\n%@", appLanguages);
//    [UIApplication sharedApplication].idleTimerDisabled = YES; // 限制锁屏
}

- (void)initCancleList {
    NSDictionary *params = @{@"c":@"", @"x":@"", @"userId":@"", @"token":@"", @"keyword":@"胃癌"};
    [[JCHTTPSessionManager sharedManager] requestWithMethod:HTTP_GET URLString:URL_GetCancerList parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responeseObj = responseObject;
        DebugLog(@"%@", responeseObj);
        NSArray *cancerDics = [[responeseObj valueForKey:@"Data"] valueForKey:@"List"];
        NSMutableArray *cancers = [NSMutableArray array];
        for (NSDictionary *cancerDic in cancerDics) {
            [cancers addObject:[[Cancer alloc] initWithDic:cancerDic]];
        }
        
        if (cancers.count) {
            BOOL isSuccess = [[DBManager shareInstance] bulkInsertCancers:cancers];
            DebugLog(@"%zd", isSuccess);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)initAFNetWorkingReachability {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@  CurrentThread: %@", AFStringFromNetworkReachabilityStatus(status), [NSThread currentThread]);
        if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"网络好像出现问题了哦~" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alert show];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring]; // Reachability监听
}





@end
