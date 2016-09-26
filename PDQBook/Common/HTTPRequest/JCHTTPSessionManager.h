//
//  JCHTTPSessionManager.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/5.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef enum {
    HTTP_GET,
    HTTP_POST,
    HTTP_PUT,
    HTTP_DELETE,
    HTTP_HEAD
} HTTPMethod;

@interface JCHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)requestWithMethod:(HTTPMethod)method
                                  URLString:(NSString *)URLString
                                 parameters:(id)parameters
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
