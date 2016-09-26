//
//  Cancer.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/10.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "Cancer.h"

@implementation Cancer

- (id)initWithDic:(NSDictionary *)cancerDic {
    self = [super init];
    if (self) {
        self.cancerId = [[cancerDic valueForKey:@"Id"] integerValue];
        self.name = [cancerDic valueForKey:@"Name"];
        self.type = [cancerDic valueForKey:@"CancerType"];
        self.desc = [cancerDic valueForKey:@"Description"];
        self.icon = [cancerDic valueForKey:@"Icon"];
    }
    
    return self;
}

+ (Cancer *)cancerWithId:(NSInteger)cancerId {
    return [[DBManager shareInstance] queryCancerWithId:cancerId];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(\nCancerId:%zd,\nName:%@,\nType:%@,\nDescription:%@,\nIcon:%@\n)", self.cancerId, self.name, self.type, self.desc, self.icon];
}


@end
