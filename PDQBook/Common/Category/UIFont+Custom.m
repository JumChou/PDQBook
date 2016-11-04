//
//  UIFont+Custom.m
//  PDQBook
//
//  Created by Mr.Chou on 2016/10/26.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "UIFont+Custom.h"
#import "CommonDefine.h"

@implementation UIFont (Custom)

+ (UIFont *)defaultFontWithSize:(CGFloat)fontSize {
//    return [UIFont systemFontOfSize:fontSize];
    return FontHYQH50(fontSize);
}

+ (UIFont *)boldDefaultFontWithSize:(CGFloat)fontSize {
//    return [UIFont boldSystemFontOfSize:fontSize];
    return FontHYQH65(fontSize);
}

+ (UIFont *)thickDefaultFontWithSize:(CGFloat)fontSize {
    return FontFZLTT(fontSize);
}


@end
