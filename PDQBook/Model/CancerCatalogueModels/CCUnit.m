//
//  CCUnit.m
//  PDQBook
//
//  Created by Mr.Chou on 16/9/20.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "CCUnit.h"
#import "CommonDefine.h"

@implementation CCUnit


- (NSString *)paperURL {
    return Get_PaperWebURL(self.Sid);
}

- (NSString *)paperParaURL {
    return Get_PaperParaWebURL(self.Sid, self.paraId);
}

@end
