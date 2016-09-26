//
//  JCHTTPSessionManager.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/5.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "JCHTTPSessionManager.h"
#import "CommonDefine.h"

@implementation JCHTTPSessionManager

+ (instancetype)sharedManager {
    static JCHTTPSessionManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    
    return manager;
}

- (id)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithSessionConfiguration:configuration];
    if (self) {
        self.requestSerializer.timeoutInterval = 10;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        self.securityPolicy.allowInvalidCertificates = YES;
        //[self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //[self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        //self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/javascript",@"text/json",@"text/html", nil];
        
        [self.requestSerializer setValue:@"fd0a97bd4bcb79b91c50b47c7fa8246d" forHTTPHeaderField:@"apikey"];
    }
    
    return self;
}

- (NSURLSessionDataTask *)requestWithMethod:(HTTPMethod)method
                                  URLString:(NSString *)URLString
                                 parameters:(id)parameters
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSURLSessionDataTask *task;
    switch (method) {
        case HTTP_GET:{
            task = [self GET:URLString
                  parameters:parameters
                    progress:nil
                     success:success
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (error.code == -1001) {
                             UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"网络请求超时" preferredStyle:UIAlertControllerStyleAlert];
                             [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 
                             }]];
                             [alert show];
                             
                             failure(task, nil);
                             
                         } else {
                             failure(task, error);
                         }
                     }];
            break;
        }
        case HTTP_POST:{
            task = [self POST:URLString
                   parameters:parameters
                     progress:nil
                      success:success
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          if (error.code == -1001) {
                              UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"网络请求超时" preferredStyle:UIAlertControllerStyleAlert];
                              [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                  
                              }]];
                              [alert show];
                              
                              failure(task, nil);
                              
                          } else {
                              failure(task, error);
                          }
                      }];
            break;
        }
        default:
            break;
    }
    
    return task;
}









@end
