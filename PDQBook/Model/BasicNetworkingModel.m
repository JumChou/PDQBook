//
//  BasicNetworkingModel.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/10.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "BasicNetworkingModel.h"


@interface BasicNetworkingModel ()

/// 存放所有网络请求task
@property (nonatomic, strong) NSMutableArray<NSURLSessionTask *> *networkingTasks;

@end

@implementation BasicNetworkingModel

- (id)init {
    self = [super init];
    if (self) {
        self.networkingTasks = [[NSMutableArray alloc] init];
    }
    
    return self;
}


/**
 封装了task管理网络请求

 @param method     HTTPMethod
 @param URLString  URL字符串
 @param parameters 参数
 @param success    成功block
 @param failure    失败block
 */
- (void)HTTPRequestWithMethod:(HTTPMethod)method
                    URLString:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSURLSessionDataTask *task = [[JCHTTPSessionManager sharedManager] requestWithMethod:method URLString:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.networkingTasks removeObject:task];
        success(task, responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.networkingTasks removeObject:task];
        failure(task, error);
    }];
    
    [self.networkingTasks addObject:task];
}


/**
 * cancel当前所有网络请求task
 */
- (void)cancelNetworkingTasks {
    @autoreleasepool {
        NSArray *tasks = [self.networkingTasks copy];
        for (NSURLSessionTask *task in tasks) {
            [task cancel];
            [self.networkingTasks removeObject:task];
        }
    }
}

@end
