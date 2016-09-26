//
//  NSObject+Custom.m
//  AirPPT
//
//  Created by Mr.Chou on 15/4/22.
//  Copyright (c) 2015年 周 骏豪. All rights reserved.
//

#import "NSObject+Custom.h"

@implementation NSObject (Custom)

/**
 *  完全的深copy（调用类及其子节点类需全部实现NSCoding协议！）
 *
 *  @return copy
 */
- (id)trueDeepCopy {
    id copy = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    return copy;
}




@end
