//
//  SearchResults.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/16.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "BasicNetworkingModel.h"
#import "SearchResult.h"
#import "SRDictionaryCell.h"
#import "SRPaperCell.h"

typedef void (^ConfigureCellBlock)(UITableViewCell *cell, NSIndexPath *indexPath);

@interface SearchResults : BasicNetworkingModel <UITableViewDataSource>
/// 语言
@property (nonatomic, assign) SRLanguage language;


#pragma mark - Init
- (id)initWithConfigureCellBlock:(ConfigureCellBlock)configureCell;


#pragma mark - Method
/**
 获得所有数据count
 
 @return 数据count
 */
- (NSInteger)getDataCount;

/**
 根据indexPath获取搜索结果数据（词典数据组Ary、文章）
 
 @param indexPath indexPath索引
 
 @return 搜索结果二级数据
 */
- (id)getDataWithIndexPath:(NSIndexPath *)indexPath;

/**
 判断indexPath数据的SRType类型

 @param indexPath indexPath索引

 @return SRType
 */
- (SRType)getDataSRTypeWithIndexPath:(NSIndexPath *)indexPath;

/**
 根据indexPath获取搜索结果当前语言SRLanguage
 
 @param indexPath indexPath索引
 
 @return SRLanguage
 */
- (SRLanguage)getDataSRLanguageWithIndexPath:(NSIndexPath *)indexPath;

/**
 根据indexPath设置搜索结果语言SRLanguage
 
 @param indexPath indexPath索引
 */
- (void)switchDataSRLanguageWithIndexPath:(NSIndexPath *)indexPath;


#pragma mark - HTTPRequest
/**
 搜索接口请求
 
 @param searchText 搜索文本
 @param success    successBlock
 @param failure    failureBlock
 */
- (void)HTTPRequestSearchWithText:(NSString *)searchText
                          success:(void (^)(void))success
                          failure:(void (^)(NSError *error))failure;






@end
