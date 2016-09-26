//
//  SearchRecords.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/15.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "RecentSearchRecords.h"
#import "CommonDefine.h"

@implementation RecentSearchRecords

const int kRecentCountLimit = 5;

- (id)init {
    self = [super init];
    if (self) {
        self.searchRecords = [[DBManager shareInstance] querySearchRecordsWithLimit:kRecentCountLimit];
    }
    
    return self;
}

- (SearchRecord *)getSearchRecordWithIndexPath:(NSIndexPath *)indexPath {
    if (0 <= indexPath.row && indexPath.row < self.searchRecords.count) {
        return self.searchRecords[indexPath.row];
    } else {
        return nil;
    }
}

- (void)saveSearchRecordWithText:(NSString *)searchText {
    NSString *timeStr = [[NSDate date] defaultFormatString];
    SearchRecord *searchRecord = [[SearchRecord alloc] init];
    searchRecord.searchText = searchText;
    searchRecord.searchTime = timeStr;
    
    if ([[DBManager shareInstance] insertSearchRecord:searchRecord]) {
        self.searchRecords = [[DBManager shareInstance] querySearchRecordsWithLimit:kRecentCountLimit];
    }
}

- (BOOL)clearSearchRecords {
    if ([[DBManager shareInstance] deleteAllSearchRecords]) {
        self.searchRecords = [[DBManager shareInstance] querySearchRecordsWithLimit:kRecentCountLimit];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = self.searchRecords.count ? self.searchRecords.count + 1 : 0;
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const cellIdentifier = @"RecentSearchRecordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = Color_Navy;
        UIView *line = [UIView new];
        line.backgroundColor = Color_Line;
        [cell addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.trailing.equalTo(cell);
            make.leading.equalTo(cell).offset(15.f);
            make.height.equalTo(0.5f);
        }];
    }
    
    if (indexPath.row < self.searchRecords.count) {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.text = [self getSearchRecordWithIndexPath:indexPath].searchText;
        cell.imageView.image = [UIImage imageNamed:@"SearchRecentIcon"];
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"清除搜索历史";
        cell.imageView.image = nil;
    }
    
    return cell;
}

@end
