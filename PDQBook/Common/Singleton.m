//
//  Singleton.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/10.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

+ (Singleton *)shareInstance {
    static Singleton *singleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

@end
