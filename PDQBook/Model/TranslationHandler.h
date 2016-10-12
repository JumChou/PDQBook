//
//  TranslationHandler.h
//  PDQBook
//
//  Created by Mr.Chou on 2016/10/11.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "BasicNetworkingModel.h"
#import "TranslationResult.h"

@interface TranslationHandler : BasicNetworkingModel

#pragma mark - Method
/**
 翻译文本

 @param content 需翻译的文本
 @param success 成功 返回翻译结果
 @param failure 失败
 */
- (void)translateContent:(NSString *)content
                 success:(void (^)(TranslationResult *transResult))success
                 failure:(void (^)(void))failure;


@end
