//
//  SRDictionaryDescView.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/17.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"

@interface SRDictionaryDescView : UIView

- (id)initWithSearchResult:(SearchResult *)searchResult;

- (void)setUpViewsWithData:(SearchResult *)searchResult;


/**
 通过数据、约束宽计算完整高
 
 @param searchResult    展示数据
 @param constraintWidth 约束宽
 
 @return height
 */
+ (CGFloat)calculateHeightWithData:(SearchResult *)searchResult constraintWidth:(CGFloat)constraintWidth;

@end
