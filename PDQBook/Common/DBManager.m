//
//  DBManager.m
//  PDQBook
//
//  Created by Mr.Chou on 16/7/21.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "DBManager.h"
#import "CommonDefine.h"

#define DBFileName  @"Data.sqlite"

@interface DBManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation DBManager

/**
 *  @author zhoujunhao, 2016-07-21 16:26:00
 *  @since  v1.0.0
 *
 *  单例
 *
 *  @return DBManager
 */
+ (DBManager *)shareInstance {
    static DBManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        [self checkDBFileAndVersion];
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:DBFilePath];
    }
    return  self;
}


- (void)checkDBFileAndVersion {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *bundleDBFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBFileName];
    
    if (![fileManager fileExistsAtPath:DBFilePath]) { // 不存在数据库
        BOOL copyResult = [fileManager copyItemAtPath:bundleDBFilePath toPath:DBFilePath error:&error];
        if (!copyResult) {
            DebugLog(@"ERROR ON COPYING DB FILE: %@ -> %@", bundleDBFilePath, DBFilePath);
            DebugLog(@"%@", error);
            
        } else {
            DebugLog(@"复制%@数据库成功", DBFileName);
            [[NSUserDefaults standardUserDefaults] setObject:kDBVersion forKey:UD_DBVersion]; // 设置数据库为新版本
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } else { // 存在数据库对比版本
        NSString *localDBVersion = [[NSUserDefaults standardUserDefaults] stringForKey:UD_DBVersion];
        NSString *newDBVersion = kDBVersion;
        DebugLog(@"数据库存在,本地版本:%@,——————当前版本:%@", localDBVersion, newDBVersion);
        if (![localDBVersion isEqualToString:newDBVersion]) {
            DebugLog(@"版本号不一致, 开始复制新数据库");
            if ([fileManager removeItemAtPath:DBFilePath error:&error] == YES) {
                BOOL success = [fileManager copyItemAtPath:bundleDBFilePath toPath:DBFilePath error:nil];
                if (!success) {
                    DebugLog(@"ERROR ON COPYING DB FILE: %@ -> %@", bundleDBFilePath, DBFilePath);
                    DebugLog(@"%@", error);
                    
                } else {
                    DebugLog(@"复制%@数据库成功", DBFileName);
                    [[NSUserDefaults standardUserDefaults] setObject:kDBVersion forKey:UD_DBVersion]; // 设置数据库为新版本
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            } else {
                DebugLog(@"%@", error);
            }
        }
    }
    
}


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
- (BOOL)insertSearchRecord:(SearchRecord *)searchRecord {
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"insert or replace into tab_search_record(search_text, search_time) values (?, ?)";
        result = [db executeUpdate:sql, searchRecord.searchText, searchRecord.searchTime];
    }];
    
    return result;
}


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
- (NSArray<SearchRecord *> *)querySearchRecordsWithLimit:(NSInteger)limit {
    NSMutableArray *results = [NSMutableArray array];
    NSString *sql;
    if (limit == NSIntegerMax) {
        sql = @"select * from tab_search_record order by search_time desc";
    } else {
        sql = [NSString stringWithFormat:@"select * from tab_search_record order by search_time desc limit 0,%zd", limit];
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            SearchRecord *searchRecord = [[SearchRecord alloc] init];
            searchRecord.searchText = [resultSet stringForColumn:@"search_text"];
            searchRecord.searchTime = [resultSet stringForColumn:@"search_time"];
            [results addObject:searchRecord];
        }
        [resultSet close];
    }];
    
    return results;
}


/**
 *  @author zhoujunhao, 2016-07-22 11:24:00
 *  @since  v1.0.0
 *
 *  删除所有搜索记录
 *
 *  @return bool
 */
- (BOOL)deleteAllSearchRecords {
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"delete from tab_search_record";
        result = [db executeUpdate:sql];
    }];
    
    return result;
}


#pragma mark - Cancers
- (BOOL)bulkInsertCancers:(NSArray<Cancer *> *)cancers {
    __block BOOL result = YES;
    NSString *sql = @"REPLACE INTO tab_cancer(id, name, type, description, icon) VALUES(?, ?, ?, ?, ?)";
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (int i = 0; i < cancers.count; i++) {
            result = result && [db executeUpdate:sql, [NSString stringWithFormat:@"%zd", cancers[i].cancerId], cancers[i].name, cancers[i].type, cancers[i].desc, cancers[i].icon];
        }
    }];
    
    return result;
}


- (NSArray<Cancer *> *)queryAllCancers {
    NSMutableArray *results = [NSMutableArray array];
    NSString *sql = @"select * from tab_cancer order by id asc";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            Cancer *cancer = [[Cancer alloc] init];
            cancer.cancerId = [resultSet intForColumn:@"id"];
            cancer.name = [resultSet stringForColumn:@"name"];
            cancer.type = [resultSet stringForColumn:@"type"];
            cancer.desc = [resultSet stringForColumn:@"description"];
            cancer.icon = [resultSet stringForColumn:@"icon"];
            
            [results addObject:cancer];
        }
        [resultSet close];
    }];
    
    return results;
}


- (Cancer *)queryCancerWithId:(NSInteger)cancerId {
    NSString *sql = @"select * from tab_cancer where id=?";
    __block Cancer *cancer;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sql, [NSNumber numberWithInteger:cancerId]];
        while ([resultSet next]) {
            cancer = [[Cancer alloc] init];
            cancer.cancerId = [resultSet intForColumn:@"id"];
            cancer.name = [resultSet stringForColumn:@"name"];
            cancer.type = [resultSet stringForColumn:@"type"];
            cancer.desc = [resultSet stringForColumn:@"description"];
            cancer.icon = [resultSet stringForColumn:@"icon"];
        }
    }];
    
    return cancer;
}






@end
