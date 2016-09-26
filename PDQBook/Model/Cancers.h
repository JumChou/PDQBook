//
//  Cancers.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/10.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "BasicNetworkingModel.h"
#import "Cancer.h"

@interface Cancers : BasicNetworkingModel

@property (nonatomic, strong) NSArray *cancers;

#pragma mark - ClassMethod
+ (Cancer *)getCancerWithId:(NSInteger)cancerId inCancerAry:(NSArray<Cancer *> *)cancerAry;

#pragma mark - HTTPRequest
- (void)HTTPRequestCancersWithSuccess:(void (^)(void))success
                              failure:(void (^)(void))failure;

@end
