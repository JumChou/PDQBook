//
//  NSString+Custom.m
//  Translation
//
//  Created by Mr.Jiang on 15/10/21.
//  Copyright © 2015年 AirPPT. All rights reserved.
//

#import "NSString+Custom.h"

@implementation NSString(Custom)

#pragma mark - 判断是否为空串、或NSNull
+ (BOOL)isNotEmptyOrNullString:(NSString *)string {
    if (![string isKindOfClass:[NSNull class]] && string.length) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - 动态计算Size
/**
 根据约束size、font动态计算最终size

 @param constraintSize 约束size，如：CGSizeMake(view.frame.size.width, FLT_MAX)
 @param font           字体

 @return expectedLabelSize
 */
- (CGSize)sizeWithConstraintSize:(CGSize)constraintSize font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:constraintSize
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:attributes
                                               context:nil].size;
        
    } else {
        #if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
            expectedLabelSize = [self sizeWithFont:font
                                 constrainedToSize:constraintSize
                                     lineBreakMode:NSLineBreakByWordWrapping];
        #endif
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

/**
 根据约束size、attributes动态计算最终size

 @param constraintSize 约束size，如：CGSizeMake(view.frame.size.width, FLT_MAX)
 @param attrs          attributes配置（字体、分行模式等）

 @return expectedLabelSize
 */
- (CGSize)sizeWithConstraintSize:(CGSize)constraintSize attributes:(NSDictionary*)attrs {
    CGRect rect = [self boundingRectWithSize:constraintSize
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attrs
                                     context:nil];
    return rect.size;
}


#pragma mark - 处理搜索结果当前搜索词
/**
 处理搜索结果文本的搜索词
 
 @param ranges 装载处理后所有搜索词的范围
 
 @return 返回剔除<br>标签的文本
 */
- (NSString *)processAndGetSearchWordsRanges:(NSMutableArray *)ranges {
    NSString *tagString = @"<b>";
    NSString *tagString_ = @"</b>";
    NSString *targetString = [self copy];
    
    NSRange prePartTagRange;
    NSRange afterPartTagRange;
    
    for (int i = 0; i < INT_MAX; i++) {
        if (!(i%2)) { // <b>
            prePartTagRange = [targetString rangeOfString:tagString];
            if (prePartTagRange.length == 0) {
                break;
            }
            
        } else { // </b>
            afterPartTagRange = [targetString rangeOfString:tagString_];
            if (afterPartTagRange.length == 0) { // 标签没有成对？Fuck！
                break;
            } else if (prePartTagRange.length == 0) {
                break;
            }
            
            targetString = [targetString stringByReplacingCharactersInRange:afterPartTagRange withString:@""]; // 先替换后面，以免影响前值替换
            targetString = [targetString stringByReplacingCharactersInRange:prePartTagRange withString:@""];
            NSUInteger wordsLength = afterPartTagRange.location - (prePartTagRange.location + prePartTagRange.length);
            NSRange wordsRange = NSMakeRange(prePartTagRange.location, wordsLength);
            [ranges addObject:[NSValue valueWithRange:wordsRange]];
        }
    }
    
    return targetString;
}

- (NSMutableAttributedString *)handledSearchWordFlag {
    NSMutableArray *wordsRanges = [NSMutableArray array];
    NSString *descriptionStr = [self processAndGetSearchWordsRanges:wordsRanges];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:descriptionStr];
    for (NSValue *rangeValue in wordsRanges) {
        NSRange wordsRange = [rangeValue rangeValue];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:Color_Blue range:wordsRange];
        //        [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:kDescLab_FontSize] range:wordsRange];
    }
    
    return attributedStr;
}



#pragma mark - 统计specificStr
- (NSUInteger)countAppearTimesWithString:(NSString *)str {
    if ([self isKindOfClass:[NSNull class]] || [str isKindOfClass:[NSNull class]]) {
        return 0;
    }
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < self.length - str.length + 1; ) {
        NSString *subString = [self substringWithRange:NSMakeRange(i, str.length)];
        if ([subString isEqualToString:str]) {
            count++;
            i += str.length;
        }
        else {
            i++;
        }
    }
    return count;
}

/**
 *  统计String中 换行符的个数
 *
 *  @return 换行符的个数
 */
- (NSUInteger)breakLineCharCount {
    NSUInteger count = 0;
    for (NSUInteger idx = 0; idx < self.length;) {
        NSString *subStr = [self substringFromIndex:idx];
        NSRange range = [subStr rangeOfString:@"\n"];
        if (range.location == NSNotFound) {
            break;
        }
        count++;
        idx += range.location + range.length;
    }
    return count;
}



@end
