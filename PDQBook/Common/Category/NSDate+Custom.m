//
//  NSDate+Custom.m
//  AirPPT
//
//  Created by Mr.Chou on 15/4/24.
//  Copyright (c) 2015年 周 骏豪. All rights reserved.
//

#import "NSDate+Custom.h"

@implementation NSDate (Custom)

/**
 *  获得date默认格式string @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return string
 */
- (NSString *)defaultFormatString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}




@end
