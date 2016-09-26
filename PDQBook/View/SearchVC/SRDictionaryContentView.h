//
//  SRDictionaryContentView.h
//  PDQBook
//
//  Created by Mr.Chou on 16/9/2.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"

@interface SRDictionaryContentView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<SearchResult *> *dicSearchResultAry;


#pragma mark - Method
- (void)configureWithData:(NSArray<SearchResult *> *)dicSearchResultAry;

- (void)remakeMaskLayer;

@end
