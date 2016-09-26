//
//  Cancers.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/10.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "Cancers.h"
#import "CommonDefine.h"

@interface Cancers ()

@end

@implementation Cancers
@dynamic cancers;

- (void)setCancers:(NSArray<Cancer *> *)cancers {
    [[DBManager shareInstance] bulkInsertCancers:cancers];
}

- (NSArray<Cancer *> *)cancers {
    return [[DBManager shareInstance] queryAllCancers];
}


#pragma mark - ClassMethod
+ (Cancer *)getCancerWithId:(NSInteger)cancerId inCancerAry:(NSArray<Cancer *> *)cancerAry {
    Cancer *cancer;
    for (Cancer *c in cancerAry) {
        if (c.cancerId == cancerId) {
            cancer = c;
            break;
        }
    }
    
    return cancer;
}


#pragma mark - HTTPRequest
- (void)HTTPRequestCancersWithSuccess:(void (^)(void))success
                              failure:(void (^)(void))failure {
    NSDictionary *params = @{@"c":@"", @"x":@"", @"userId":@"", @"token":@""};
    [self HTTPRequestWithMethod:HTTP_GET URLString:URL_GetCancerList parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responeseObj = responseObject;
        DebugLog(@"%@", responeseObj);
        NSArray *cancerDics = [[responeseObj valueForKey:@"Data"] valueForKey:@"List"];
        NSMutableArray *cancers = [NSMutableArray array];
        for (NSDictionary *cancerDic in cancerDics) {
            [cancers addObject:[[Cancer alloc] initWithDic:cancerDic]];
        }
        
        if (cancers.count) {
            self.cancers = cancers;
        }
        success();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure();
    }];
}


@end
