//
//  Cancer.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/10.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "BasicModel.h"

@interface Cancer : BasicModel

@property (nonatomic, assign) NSInteger cancerId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *icon;


- (id)initWithDic:(NSDictionary *)cancerDic;

+ (Cancer *)cancerWithId:(NSInteger)cancerId;

@end
