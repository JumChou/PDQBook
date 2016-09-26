//
//  NSObject+Custom.h
//  AirPPT
//
//  Created by Mr.Chou on 15/4/22.
//  Copyright (c) 2015年 周 骏豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Custom)

/**
 *  完全的深copy（调用类及其子节点类需全部实现NSCoding协议！）
 *
 *  @return copy
 */
- (id)trueDeepCopy;




@end
