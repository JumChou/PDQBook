//
//  BasicNetworkingModel.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/10.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "BasicModel.h"
#import "CommonDefine.h"

@interface BasicNetworkingModel : BasicModel



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
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 * cancel当前所有网络请求task
 */
- (void)cancelNetworkingTasks;



@end
