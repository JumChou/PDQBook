//
//  SearchResultsView.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/15.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsView : UIView

@property (nonatomic, strong) UITableView *tableView;


- (void)reloadViews;

@end
