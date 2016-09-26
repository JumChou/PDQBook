//
//  SearchResult.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/12.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "BasicModel.h"

typedef NS_ENUM(NSInteger, SRType) {
    SRType_Dictionary,
    SRType_Paper
};

typedef NS_ENUM(NSInteger, SRLanguage) {
    SRLanguage_CN,
    SRLanguage_EN
};

@interface SearchResult : BasicModel

@property (nonatomic, assign) SRLanguage language;
@property (nonatomic, assign, readonly) SRType SRType;


/**
 初始化SearchResult

 @param searchResultDic 数据字典

 @return SearchResult
 */
- (id)initWithDic:(NSDictionary *)searchResultDic;

- (NSString *)type;

- (NSString *)title;

- (NSString *)desc;

- (NSString *)paperURL;

- (NSString *)paperParaURL;

- (NSString *)paperParaLanguageURL;

- (NSString *)paperURL:(NSString *)URL appendedLanguage:(SRLanguage)language;


@end
