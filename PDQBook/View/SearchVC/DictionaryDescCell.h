//
//  DictionaryDescCell.h
//  PDQBook
//
//  Created by Mr.Chou on 16/9/6.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"

@interface DictionaryDescCell : UITableViewCell


#pragma mark - ConfigureCell
- (void)configureWithData:(SearchResult *)dicResult;


#pragma mark - ClassMethod
/**
 通过数据计算完整高
 
 @param searchResult 展示数据
 
 @return 完整高
 */
+ (CGFloat)calculateFullHeightWithData:(SearchResult *)searchResult;


@end
