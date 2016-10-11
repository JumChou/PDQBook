//
//  TranslationResult.m
//  PDQBook
//
//  Created by Mr.Chou on 2016/10/11.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "TranslationResult.h"

@implementation TranslationResult

- (NSString *)description {
    return [NSString stringWithFormat:@"[\n   content:%@,\n   translateContent:%@,\n   tag:%@,\n   source:%@,\n]", self.content, self.translateContent, self.tag, self.source];
}


@end
