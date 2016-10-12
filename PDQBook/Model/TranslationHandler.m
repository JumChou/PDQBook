//
//  TranslationHandler.m
//  PDQBook
//
//  Created by Mr.Chou on 2016/10/11.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "TranslationHandler.h"
#import "CommonDefine.h"

@implementation TranslationHandler


#pragma mark - Method
/**
 翻译文本
 
 @param content 需翻译的文本
 @param success 成功 返回翻译结果
 @param failure 失败
 */
- (void)translateContent:(NSString *)content
                 success:(void (^)(TranslationResult *transResult))success
                 failure:(void (^)(void))failure {
    // 先查询数据库
    TranslationResult *transLocalResult = [[DBManager shareInstance] queryTranslationResultWithContent:content];
    if(transLocalResult != nil) {
        success(transLocalResult);
        return;
    }
    
    [self HTTPRequestTranslationWithContent:content success:^(TranslationResult *transResult) {
        [[DBManager shareInstance] bulkInsertTranslationResults:@[transResult]]; // 结果存入数据库
        success(transResult);
        
    } failure:^{
        failure();
        
    }];
}


#pragma mark - HTTPRequest
- (void)HTTPRequestTranslationWithContent:(NSString *)content
                                  success:(void (^)(TranslationResult *transResult))success
                                  failure:(void (^)(void))failure {
    [self HTTPRequestWithMethod:HTTP_GET URLString:Get_YoudaoTranslationURL(content) parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responeseObj = responseObject;
        DebugLog(@"%@", responeseObj);
        if ([[responeseObj valueForKey:@"errorCode"] integerValue] != 0) {
            failure();
            return;
        }
        TranslationResult *transResult = [[TranslationResult alloc] init];
        transResult.content = content;
        transResult.translateContent = [responeseObj JSONString];
        transResult.source = @"youdao";
        
        success(transResult);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure();
    }];
}

@end
