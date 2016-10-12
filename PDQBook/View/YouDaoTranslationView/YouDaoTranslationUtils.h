//
//  YouDaoTranslationUtils.h
//  TestYouDaoView
//
//  Created by Mr.Jiang on 15/12/7.
//  Copyright © 2015年 JasonRyan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kYDTU_TextColor_Detail      [UIColor colorWithHexString:@"ebebeb"]     // 细节颜色
#define kYDTU_TextColor_Title       [UIColor whiteColor]                        // Title颜色
#define kYDTU_TextColor_KeyWord     [UIColor colorWithHexString:@"149fff"]     // 关键字颜色

/// 有道翻译返回的数据结构中，需要解析的数据节点类型
typedef NS_ENUM(NSInteger,YouDaoDataNodeType) {
    YouDaoDataNodeTypeQuery,         //query
    YouDaoDataNodeTypeBasicTrans,    // 基本释义
    YouDaoDataNodeTypeTranslation,   // 有道翻译
    YouDaoDataNodeTypeWebTrans,      // 网络释义
};

@interface YouDaoTranslationUtils : NSObject

+ (NSAttributedString *)parseDict:(NSDictionary *)translateContent youdaoDataNodeType:(YouDaoDataNodeType)nodeType;

+ (CGSize)sizeOfText:(NSString *)text constraintSize:(CGSize)constraintSize attributes:(NSDictionary*)attrs;


@end

