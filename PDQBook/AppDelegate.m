//
//  AppDelegate.m
//  PDQBook
//
//  Created by Mr.Chou on 16/7/8.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "MainViewController.h"
#import "ViewController.h"
#import "Cancer.h"
#import "ASTouchVisualizer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark - ApplicationLifeCircle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DebugLog(@"LaunchOptions:%@", launchOptions);
    
    [self initApp];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *rootVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:UD_WelcomeShowedCount] > kWelcomeShowLimit) {
        rootVC = [MainViewController new];
    } else {
        rootVC = [WelcomeViewController new];
    }
    
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    if ([naviController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        ((UINavigationController *)naviController).interactivePopGestureRecognizer.delegate = nil;
    }
    
    self.window.rootViewController = naviController;
    [self.window makeKeyAndVisible];
    
    // 演示用 可添加点击效果
//    [ASTouchVisualizer install];
    
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

- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler {
    DebugLog(@"%@", shortcutItem);
    [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_ApplicationShortcut object:nil userInfo:@{@"ShortcutItem":shortcutItem}];
}


#pragma mark OpenURL
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
    DebugLog(@"OpenURL Calling Application Bundle ID: %@", sourceApplication);
    DebugLog(@"URL:%@", [url absoluteString]);
    DebugLog(@"URL scheme:%@", [url scheme]);
    DebugLog(@"URL query: %@", [url query]);
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    DebugLog(@"OpenURL Calling Application Bundle ID: %@", nil);
    DebugLog(@"URL:%@", [url absoluteString]);
    DebugLog(@"URL scheme:%@", [url scheme]);
    DebugLog(@"URL resourceSpecifier: %@", [url resourceSpecifier]);
    DebugLog(@"URL query: %@", [url query]);
    DebugLog(@"Options: %@", options);
    
    return YES;
}


#pragma mark URLSession
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(nonnull void (^)(void))completionHandler {
    
}


#pragma mark - InitApp
- (void)initApp {
//    [UIApplication sharedApplication].idleTimerDisabled = YES; // 限制锁屏
//    [NSThread sleepForTimeInterval:0.3f];  // 延迟启动页展示
    
//    [self printLanguageAndFontFamily];
//    [self initFlurry];
    [DBManager shareInstance];          // 初始化数据库操作
    [self initAFNetWorkingReachability];
    [self initCancleList];
    
    /**
     Test Thread
     */
    /*
    NSString *isolationQueueName = [NSString stringWithFormat:@"%@.%p.isolation", [self class], self];
    dispatch_queue_t isolationQ = dispatch_queue_create([isolationQueueName UTF8String], DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(isolationQ, ^{
        DebugLog(@"Do something here.");
        DebugLog(@"Error: Method needs to be called on the main thread. %@", [NSThread callStackSymbols]);
    });
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.summer.concurrent", DISPATCH_QUEUE_CONCURRENT);
    //    for (int i = 0; i < 2000; i++) {
    dispatch_async(concurrentQueue, ^{
        //            NSLog(@"%d, for in dispatch_async concurrentQueue1, current thread = %@", i, [NSThread currentThread]);
        NSLog(@"for in dispatch_async concurrentQueue1, current thread = %@", [NSThread currentThread]);
        
    });
    //    }
     */
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
            [Singleton shareInstance].isHTTPRequestedCancers = YES;
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

/**
 初始化Flurry
 */
- (void)initFlurry {
    // Flurry Debug模式
    //[Flurry setDebugLogEnabled:YES];
    
    FlurrySessionBuilder *builder = [[[[[FlurrySessionBuilder new] withLogLevel:FlurryLogLevelDebug]
                                      withCrashReporting:YES]
                                      withSessionContinueSeconds:30]
                                      withAppVersion:kAppVersion];
    
    [Flurry setEventLoggingEnabled:YES];
    [Flurry setBackgroundSessionEnabled:NO];
    [Flurry startSession:Flurry_APIKey withSessionBuilder:builder];
}


- (void)printLanguageAndFontFamily {
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    DebugLog(@"AppLanguages:\n%@", appLanguages);
    
    DebugLog(@"\n-------------");
    for(NSString *fontfamilyname in [UIFont familyNames])
    {
        DebugLog(@"family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        DebugLog(@"-------------");
    }
}





@end
