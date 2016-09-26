//
//  NSString+Custom.h
//  Translation
//
//  Created by Mr.Jiang on 15/10/21.
//  Copyright © 2015年 AirPPT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString(Custom)

#pragma mark - 判断是否为空串、或NSNull
+ (BOOL)isNotEmptyOrNullString:(NSString *)string;


#pragma mark - 动态计算Size
/**
 根据约束size、font动态计算最终size
 
 @param constraintSize 约束size，如：CGSizeMake(view.frame.size.width, FLT_MAX)
 @param font           字体
 
 @return expectedLabelSize
 */
- (CGSize)sizeWithConstraintSize:(CGSize)constraintSize font:(UIFont *)font;

/**
 根据约束size、attributes动态计算最终size
 
 @param constraintSize 约束size，如：CGSizeMake(view.frame.size.width, FLT_MAX)
 @param attrs          attributes配置（字体、分行模式等）
 
 @return expectedLabelSize
 */
- (CGSize)sizeWithConstraintSize:(CGSize)constraintSize attributes:(NSDictionary*)attrs;


#pragma mark - 处理搜索结果当前搜索词
/**
 处理搜索结果文本的搜索词

 @param ranges 装载处理后所有搜词的范围

 @return 返回剔除<br>标签的文本
 */
- (NSString *)processAndGetSpecificWordsRanges:(NSMutableArray *)ranges;


#pragma mark - 统计specificStr
/**
 * 统计str出现的次数   self 为"aaa"  str为"aa", 出现次数算作1
 */
- (NSUInteger)countAppearTimesWithString:(NSString *)str;


/**
 *  统计String中 换行符的个数
 *
 *  @return 换行符的个数
 */
- (NSUInteger)breakLineCharCount;


@end
