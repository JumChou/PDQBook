//
//  SearchResults.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/16.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SearchResults.h"
#import "CommonDefine.h"

@interface SearchResults ()
/// 字典结果
@property (nonatomic, strong) NSMutableArray<NSArray *> *dictionaryResults;
/// 文章结果
@property (nonatomic, strong) NSMutableArray<SearchResult *> *paperResults;
/// 配置cell的block
@property (nonatomic, copy) ConfigureCellBlock configureCellBlock;

@end

@implementation SearchResults

- (id)init {
    self = [super init];
    if (self) {
        self.language = SRLanguage_CN;
        self.dictionaryResults = [NSMutableArray array];
        self.paperResults = [NSMutableArray array];
    }
    
    return self;
}

- (id)initWithConfigureCellBlock:(ConfigureCellBlock)configureCell {
    self = [self init];
    if (self) {
        self.configureCellBlock = configureCell;
    }
    
    return self;
}

/**
 OverWrite languageSetter（将所有数据SearchResult.language改变）

 @param language SRLanguage参数
 */
- (void)setLanguage:(SRLanguage)language {
    _language = language;
    
    if (self.dictionaryResults.count) {
        for (NSArray *typeGroup in self.dictionaryResults) {
            for (SearchResult *searchResult in typeGroup) {
                searchResult.language = language;
            }
        }
    }
    
    #warning 文章语言切换
    /* 文章搜索结果暂不切换语言
    if (self.paperResults.count) {
        for (SearchResult *searchResult in self.paperResults) {
            searchResult.language = language;
        }
    }
     */
}


#pragma mark - Method
/**
 获得所有数据count

 @return 数据count
 */
- (NSInteger)getDataCount {
//    ■
    return (self.dictionaryResults.count + self.paperResults.count);
}


/**
 根据indexPath获取搜索结果数据（词典数据组Ary、文章）
 
 @param indexPath indexPath
 
 @return 搜索结果二级数据
 */
- (id)getDataWithIndexPath:(NSIndexPath *)indexPath {
    if ([self getDataSRTypeWithIndexPath:indexPath] == SRType_Dictionary) { // 获取数据为字典结果
        return self.dictionaryResults[indexPath.section];
        
    } else if ([self getDataSRTypeWithIndexPath:indexPath] == SRType_Paper) { // 获取数据为文章结果
        NSInteger index = indexPath.section - self.dictionaryResults.count;
        return self.paperResults[index];
        
    } else {
        return nil;
    }
}

/**
 判断indexPath数据的SRType类型
 
 @param indexPath indexPath索引
 
 @return SRType
 */
- (SRType)getDataSRTypeWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.dictionaryResults.count) { // 数据为字典结果
        return SRType_Dictionary;
        
    } else if (self.dictionaryResults.count <= indexPath.section && (indexPath.section-self.dictionaryResults.count) < self.paperResults.count) { // 数据为文章结果
        return SRType_Paper;
        
    } else {
        return SRType_Paper;
        
    }
}

/**
 根据indexPath获取搜索结果当前语言SRLanguage

 @param indexPath indexPath索引

 @return SRLanguage
 */
- (SRLanguage)getDataSRLanguageWithIndexPath:(NSIndexPath *)indexPath {
    SearchResult *sr;
    id data = [self getDataWithIndexPath:indexPath];
    if ([data isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)data count]) {
            sr = [(NSArray *)data objectAtIndex:0];
        }
        
    } else if ([data isKindOfClass:[SearchResult class]]) {
        sr = data;
    }
    
    return sr.language;
}

/**
 根据indexPath设置搜索结果语言SRLanguage

 @param indexPath indexPath索引
 */
- (void)switchDataSRLanguageWithIndexPath:(NSIndexPath *)indexPath {
    id data = [self getDataWithIndexPath:indexPath];
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray *dicResultAry = data;
        for (SearchResult *dicResult in dicResultAry) {
            if (dicResult.language == SRLanguage_CN) {
                dicResult.language = SRLanguage_EN;
            } else {
                dicResult.language = SRLanguage_CN;
            }
        }
        
    } else if ([data isKindOfClass:[SearchResult class]]) {
        SearchResult *paperResult = data;
        if (paperResult.language == SRLanguage_CN) {
            paperResult.language = SRLanguage_EN;
        } else {
            paperResult.language = SRLanguage_CN;
        }
    }
}


#pragma mark - PrivateMethod
/**
 配置数据
 
 @param dataList 接口数据
 */
- (void)setUpResultsWithDataList:(NSArray *)dataList {
    if (dataList) {
        [self.dictionaryResults removeAllObjects];
        [self.paperResults removeAllObjects];
        
        for (NSDictionary *typeGroupDic in dataList) { // 循环分组
            NSString *categoryName = [typeGroupDic valueForKey:@"CategoryName"];
            NSArray *searchResultList = [typeGroupDic valueForKey:@"List"];
            
//            if ([categoryName isEqualToString:@"PDQ中文"]) {
            if ([categoryName hasPrefix:@"PDQ"]) { // 文章数据
                for (NSDictionary *searchResultDic in searchResultList) { // 循环分组中结果
                    SearchResult *searchResult = [[SearchResult alloc] initWithDic:searchResultDic];
#warning 文章语言切换
//                    searchResult.language = self.language;
                    [self.paperResults addObject:searchResult];
                }
                
            } else { // 词典数据
                NSMutableArray<SearchResult *> *typeGroup = [NSMutableArray array];
                
                for (NSDictionary *searchResultDic in searchResultList) { // 循环分组中结果
                    SearchResult *searchResult = [[SearchResult alloc] initWithDic:searchResultDic];
                    searchResult.language = self.language;
                    [typeGroup addObject:searchResult];
                }
                
                [self.dictionaryResults addObject:typeGroup];
            }
        }
        
        DebugLog(@"%@", self.dictionaryResults);
    }
}


#pragma mark - HTTPRequest
/**
 搜索接口请求

 @param searchText 搜索文本
 @param success    successBlock
 @param failure    failureBlock
 */
- (void)HTTPRequestSearchWithText:(NSString *)searchText
                          success:(void (^)(void))success
                          failure:(void (^)(NSError *error))failure {
    NSDictionary *params = @{@"c":@"", @"x":@"", @"userId":@"", @"token":@"", @"keyword":searchText};
    [self HTTPRequestWithMethod:HTTP_GET URLString:URL_Search parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responeseObj = responseObject;
        BOOL isSuccess = [[responeseObj valueForKey:@"isSuccess"] boolValue];
        if (isSuccess) { // 成功
            NSArray *dataList = [[responeseObj valueForKey:@"Data"] objectForKey:@"List"];
            if (dataList) {
                [self setUpResultsWithDataList:dataList];
            }
            
        } else { // 接口error
            if (self.dictionaryResults.count) {
                [self.dictionaryResults removeAllObjects];
            }
        }
        
        success();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
        
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger dataCount = [self getDataCount];
    return dataCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DebugLog(@"IndexPath : %zd, %zd", indexPath.section, indexPath.row);
    NSString *const dicCellIdentifier = @"SRDictionaryCell";
    NSString *const paperCellIdentifier = @"SRPaperCell";
    
    UITableViewCell *cell;
    SRType cellType = [self getDataSRTypeWithIndexPath:indexPath];
    if (cellType == SRType_Dictionary) {
        cell = [tableView dequeueReusableCellWithIdentifier:dicCellIdentifier];
        if (!cell) {
            cell = [[SRDictionaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dicCellIdentifier];
        }
        
    } else if (cellType == SRType_Paper) {
        cell = [tableView dequeueReusableCellWithIdentifier:paperCellIdentifier];
        if (!cell) {
            cell = [[SRPaperCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:paperCellIdentifier];
        }
    }
    
    self.configureCellBlock(cell, indexPath);
    
    return cell;
}

// 实现了这个方法，开启滑动编辑按钮
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}




@end
