//
//  SearchResult.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/12.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SearchResult.h"
#import "CommonDefine.h"

static NSString *const kNullString = @"无数据...";
static NSString *const kPaperDescDic_DescCNKey = @"Desc";
static NSString *const kPaperDescDic_DescENKey = @"DescEN";
static NSString *const kPaperDescDic_ParaIdKey = @"ParaId";

@interface SearchResult ()

/// 种类（XXX词典、文章）
@property (nonatomic, strong) NSString *typeCN;
@property (nonatomic, strong) NSString *typeEN;
/// 词条Title、文章Title
@property (nonatomic, strong) NSString *titleCN;
@property (nonatomic, strong) NSString *titleEN;
/// 词条解释描述、文章搜索相关内容(默认取paperDescAry首个内容)
@property (nonatomic, strong) NSString *descCN;
@property (nonatomic, strong) NSString *descEN;
/// 文章搜索相关内容们
@property (nonatomic, strong) NSMutableArray *paperDescAry;

/// CDR id
@property (nonatomic, strong) NSString *Sid;
/// 段落id(默认取paperDescAry首个内容)
@property (nonatomic, strong) NSString *paraId;
/// 搜索结果类型
@property (nonatomic, assign) SRType SRType;

@end

@implementation SearchResult

/**
 初始化SearchResult
 
 @param searchResultDic 数据字典
 
 @return SearchResult
 */
- (id)initWithDic:(NSDictionary *)searchResultDic {
    self = [self init];
    if (self) {
        self.language = SRLanguage_CN;
        
        self.Sid = [searchResultDic valueForKey:@"Sid"];
        
        NSString *typeCNStr = [searchResultDic valueForKey:@"TypeCN"];
        [self handleEmptyString:&typeCNStr];
        self.typeCN = typeCNStr;
        NSString *typeENStr = [searchResultDic valueForKey:@"Type"];
        [self handleEmptyString:&typeENStr];
        self.typeEN = typeCNStr;
        
        if ([self.typeCN isEqualToString:@"PDQ译文"]) {
            self.SRType = SRType_Paper;
        } else {
            self.SRType = SRType_Dictionary;
        }
        
        NSString *titleCNStr = [searchResultDic valueForKey:@"Title"];
        [self handleEmptyString:&titleCNStr];
        self.titleCN = titleCNStr;
        NSString *titleENStr = [searchResultDic valueForKey:@"TitleEN"];
        [self handleEmptyString:&titleENStr];
        self.titleEN = titleENStr;
        
        if (self.SRType == SRType_Dictionary) {
            NSString *descCNStr = [searchResultDic valueForKey:@"Description"];
            [self handleEmptyString:&descCNStr];
            self.descCN = descCNStr;
            NSString *descENStr = [searchResultDic valueForKey:@"DescriptionEN"];
            [self handleEmptyString:&descENStr];
            self.descEN = descENStr;
            
        } else if (self.SRType == SRType_Paper) {
            self.paperDescAry = [NSMutableArray arrayWithCapacity:10];
            NSArray *descList = [searchResultDic valueForKey:@"DescList"];
            for (int i = 0; i < descList.count; i++) {
                NSDictionary *paperDescDic = descList[i];
                NSString *descCNStr = [paperDescDic valueForKey:kPaperDescDic_DescCNKey];
                NSString *descENStr = [paperDescDic valueForKey:kPaperDescDic_DescENKey];
                [self handleEmptyString:&descCNStr];
                [self handleEmptyString:&descENStr];
                self.descCN = descCNStr;
                self.descEN = descENStr;
                self.paraId = [paperDescDic valueForKey:kPaperDescDic_ParaIdKey];
            }
        }
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SearchResult - [\nType:%@, \nTitle:%@, \nTitleCN:%@, \nTitleEN:%@, \nDesc:%@, \nDescEN:%@, \nDescCN:%@\n]", self.type, self.title, self.titleCN, self.titleEN, self.desc, self.descEN, self.descCN];
}

- (void)handleEmptyString:(NSString **)string {
    if (![NSString isNotEmptyOrNullString:*string]) {
        *string = kNullString;
    }
}


#pragma mark - GetValue
- (NSString *)type {
    switch (self.language) {
        case SRLanguage_CN:
            return self.typeCN;
        case SRLanguage_EN:
            if ([self.typeEN isEqualToString:kNullString]) {
                return self.typeCN;
            } else {
                return self.typeEN;
            }
    }
}

- (NSString *)title {
    switch (self.language) {
        case SRLanguage_CN:
            return self.titleCN;
        case SRLanguage_EN:
            if ([self.titleEN isEqualToString:kNullString]) {
                return self.titleCN;
            } else {
                return self.titleEN;
            }
    }
}

- (NSString *)desc {
    switch (self.language) {
        case SRLanguage_CN:
            return self.descCN;
        case SRLanguage_EN:
            if ([self.descEN isEqualToString:kNullString]) {
                return self.descCN;
            } else {
                return self.descEN;
            }
    }
}

- (NSString *)paperURL {
    return Get_PaperWebURL(self.Sid);
}

- (NSString *)paperParaURL {
    return Get_PaperParaWebURL(self.Sid, self.paraId);
}

- (NSString *)paperParaLanguageURL {
    return [self paperURL:[self paperParaURL] appendedLanguage:self.language];
}

- (NSString *)paperURL:(NSString *)URL appendedLanguage:(SRLanguage)language {
    NSString *languageStr;
    if (language == SRLanguage_CN) {
        languageStr = @"cn";
    } else if (language == SRLanguage_EN) {
        languageStr = @"en";
    }
    
    return [URL stringByAppendingPathComponent:languageStr];
}



@end
