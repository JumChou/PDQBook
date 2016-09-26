//
//  SRPaperCell.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/20.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SRBasicCell.h"
#import "SearchResult.h"

@interface SRPaperCell : SRBasicCell


#pragma mark - Mehtod
- (void)setUpViewsWithData:(SearchResult *)searchResult;


#pragma mark - ClassMethod
/**
 通过数据计算完整高
 
 @param searchResult 展示数据
 
 @return 完整高
 */
+ (CGFloat)calculateFullHeightWithData:(SearchResult *)searchResult;

@end
