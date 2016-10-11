//
//  TranslationResult.h
//  PDQBook
//
//  Created by Mr.Chou on 2016/10/11.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "BasicModel.h"

@interface TranslationResult : BasicModel

/// 内容
@property (nonatomic, strong) NSString *content;
/// 翻译内容
@property (nonatomic, strong) NSString *translateContent;
/// 类型(word)
@property (nonatomic, strong) NSString *tag;
/// 翻译来源(service、youdao)
@property (nonatomic, strong) NSString *source;



@end
