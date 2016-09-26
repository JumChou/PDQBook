//
//  DBManager.h
//  PDQBook
//
//  Created by Mr.Chou on 16/7/21.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchRecord.h"
#import "Cancer.h"

@interface DBManager : NSObject

/**
 *  @author zhoujunhao, 2016-07-21 16:26:00
 *  @since  v1.0.0
 *
 *  单例
 *
 *  @return DBManager
 */
+ (DBManager *)shareInstance;

#pragma mark - 搜索记录
/**
 *  @author zhoujunhao, 2016-07-21 17:21:00
 *  @since  v1.0.0
 *
 *  插入搜索记录
 *
 *  @param searchRecord SearchRecord
 *
 *  @return bool
 */
- (BOOL)insertSearchRecord:(SearchRecord *)searchRecord;


/**
 *  @author zhoujunhao, 2016-07-21 17:49:00
 *  @since  v1.0.0
 *
 *  查询固定数量的搜索记录
 *
 *  @param limit 查询记录数(NSIntegerMax则查询全部记录)
 *
 *  @return 搜索记录结果数组
 */
- (NSArray<SearchRecord *> *)querySearchRecordsWithLimit:(NSInteger)limit;


/**
 *  @author zhoujunhao, 2016-07-22 11:24:00
 *  @since  v1.0.0
 *
 *  删除所有搜索记录
 *
 *  @return bool
 */
- (BOOL)deleteAllSearchRecords;


#pragma mark - Cancers
- (BOOL)bulkInsertCancers:(NSArray<Cancer *> *)cancers;

- (NSArray<Cancer *> *)queryAllCancers;

- (Cancer *)queryCancerWithId:(NSInteger)cancerId;



@end
