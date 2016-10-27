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
    return FontFZLTX(fontSize);
}

+ (UIFont *)boldDefaultFontWithSize:(CGFloat)fontSize {
    return FontFZLTZ(fontSize);
}

+ (UIFont *)thickDefaultFontWithSize:(CGFloat)fontSize {
    return FontFZLTT(fontSize);
}


@end
