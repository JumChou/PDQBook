//
//  YouDaoTranslationUtils.m
//  TestYouDaoView
//
//  Created by Mr.Jiang on 15/12/7.
//  Copyright © 2015年 JasonRyan. All rights reserved.
//

#import "YouDaoTranslationUtils.h"

#define kYDTU_BasicTransView_DetailFont             [UIFont systemFontOfSize:16.0f]
#define kYDTU_QueryLabel_Font                       [UIFont systemFontOfSize:16.0f]
#define kYDTU_WebTransView_DetailFont               [UIFont systemFontOfSize:16.0f]

@implementation YouDaoTranslationUtils


+ (NSAttributedString *)parseDict:(NSDictionary *)translateContent youdaoDataNodeType:(YouDaoDataNodeType)nodeType {
    // 有道翻译
    NSArray *translateResultArray = [translateContent objectForKey:@"translation"];
    
    // 有道词典
    NSDictionary *basicDict = [translateContent objectForKey:@"basic"];
    
    // 网络释义
    NSArray *webTransArray = [translateContent objectForKey:@"web"];
    
    
    NSString *queryString = [translateContent objectForKey:@"query"];
    NSString *phoneticStr = @"";
    if (nodeType == YouDaoDataNodeTypeQuery) {  // 查询的key，拼接音标
        if (basicDict != nil && ![basicDict isKindOfClass:[NSNull class]]) {
            NSString *phonetic = [basicDict objectForKey:@"phonetic"];
            NSString *uk_phonetic = [basicDict objectForKey:@"uk-phonetic"];
            NSString *us_phonetic = [basicDict objectForKey:@"us-phonetic"];
            if (phonetic) {
                phoneticStr = [phoneticStr stringByAppendingFormat:@"  音标: %@",phonetic];
            }
            if (uk_phonetic) {
                phoneticStr = [phoneticStr stringByAppendingFormat:@"  英 %@",uk_phonetic];
            }
            if (us_phonetic) {
                phoneticStr = [phoneticStr stringByAppendingFormat:@"  美 %@",us_phonetic];
            }
        }
        
        NSAttributedString *queryAttriStr = [[NSAttributedString alloc] initWithString:queryString attributes:@{NSForegroundColorAttributeName : kYDTU_TextColor_KeyWord,NSFontAttributeName : kYDTU_QueryLabel_Font}];
        NSAttributedString *transAttriStr = [[NSAttributedString alloc] initWithString:phoneticStr attributes:@{NSForegroundColorAttributeName : kYDTU_TextColor_Detail,NSFontAttributeName : kYDTU_QueryLabel_Font}];
        NSMutableAttributedString *retStr = [NSMutableAttributedString new];
        [retStr appendAttributedString:queryAttriStr];
        [retStr appendAttributedString:transAttriStr];
        return [retStr copy];
    }
    else if (nodeType == YouDaoDataNodeTypeBasicTrans) { // 基础释义
        if (basicDict == nil || [basicDict isKindOfClass:[NSNull class]]) {
            // 基本释义的数据没有，则用"translation"中的数据(翻译的是句子时，会出现此情况)
            return [self parseDict:translateContent youdaoDataNodeType:YouDaoDataNodeTypeTranslation];
        }
        else {
            NSArray *explains = [basicDict objectForKey:@"explains"];
            if (explains == nil || [explains isKindOfClass:[NSNull class]] || explains.count < 1) {
                return [self parseDict:translateContent youdaoDataNodeType:YouDaoDataNodeTypeTranslation];
            }
            NSMutableString *transStr = [NSMutableString string];
            for (NSUInteger i = 0; i <= explains.count - 1; i++) {
                NSString *str = [explains objectAtIndex:i];
                if (i != explains.count - 1) {
                    [transStr appendFormat:@"%@\n",str];
                }
                else {
                    [transStr appendString:str];
                }
            }
            return [[NSAttributedString alloc] initWithString:transStr attributes:@{NSForegroundColorAttributeName : kYDTU_TextColor_Detail,NSFontAttributeName : kYDTU_BasicTransView_DetailFont}];
        }
    }
    else if (nodeType == YouDaoDataNodeTypeTranslation) {
        NSMutableString *transStr = [NSMutableString string];
        for (NSUInteger i = 0; i < translateResultArray.count; i++) {
            NSString *str = [translateResultArray objectAtIndex:i];
            if (i != translateResultArray.count - 1) {
                [transStr appendFormat:@"%@\n",str];
            }
            else {
                [transStr appendString:str];
            }
        }
        
        return [[NSAttributedString alloc] initWithString:transStr attributes:@{NSForegroundColorAttributeName : kYDTU_TextColor_Detail, NSFontAttributeName : kYDTU_BasicTransView_DetailFont}];
    }
    else if (nodeType == YouDaoDataNodeTypeWebTrans) {
        if (webTransArray == nil || [webTransArray isKindOfClass:[NSNull class]] || webTransArray.count < 1) {
            return nil;
        }
        NSMutableAttributedString *attrStr = [NSMutableAttributedString new];
        NSAttributedString *spaceHolderStr = [[NSAttributedString alloc] initWithString:@"  "];
        NSAttributedString *breakLineStr = [[NSAttributedString alloc] initWithString:@"\n"];
        for (NSUInteger i = 0; i <= webTransArray.count - 1; i ++) {
            NSDictionary *subRet = [webTransArray objectAtIndex:i];
            NSString *key = [subRet objectForKey:@"key"];
            NSArray *values = [subRet objectForKey:@"value"];
            NSMutableString *valueString = [NSMutableString string];
            for (NSString *str in values) {
                [valueString appendFormat:@"%@  ",str];
            }
            NSMutableAttributedString *keyStr = [[NSMutableAttributedString alloc] initWithString:key attributes:@{NSForegroundColorAttributeName : kYDTU_TextColor_KeyWord, NSFontAttributeName : kYDTU_WebTransView_DetailFont}];
            NSMutableAttributedString *valueStr= [[NSMutableAttributedString alloc] initWithString:valueString attributes:@{NSForegroundColorAttributeName : kYDTU_TextColor_Detail,NSFontAttributeName : kYDTU_WebTransView_DetailFont}];
            [attrStr appendAttributedString:keyStr];
            [attrStr appendAttributedString:spaceHolderStr];
            [attrStr appendAttributedString:valueStr];
            if (i != webTransArray.count - 1) {
                [attrStr appendAttributedString:breakLineStr];
            }
        }
        return [attrStr copy];
        
    }
    return nil;
}


+ (CGSize)sizeOfText:(NSString *)text constraintSize:(CGSize)constraintSize attributes:(NSDictionary*)attrs {
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:attrs];
    //    [dict setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGSize size = [text boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

@end

