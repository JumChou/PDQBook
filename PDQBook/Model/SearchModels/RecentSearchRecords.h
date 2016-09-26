//
//  RecentSearchRecords.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/15.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "BasicModel.h"
#import "SearchRecord.h"

@interface RecentSearchRecords : BasicModel <UITableViewDataSource>

@property (nonatomic, strong) NSArray<SearchRecord *> *searchRecords;


- (SearchRecord *)getSearchRecordWithIndexPath:(NSIndexPath *)indexPath;

- (void)saveSearchRecordWithText:(NSString *)searchText;

- (BOOL)clearSearchRecords;

@end
