//
//  CCUnit.h
//  PDQBook
//
//  Created by Mr.Chou on 16/9/20.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "BasicModel.h"

typedef NS_ENUM(NSInteger, CCUnitLevel) {
    CCUnitLevel_Paper,
    CCUnitLevel_Section,
    CCUnitLevel_Paragraph
};

@interface CCUnit : BasicModel

/// 单元等级
@property (nonatomic, assign) CCUnitLevel unitLevel;
/// 标题内容
@property (nonatomic, strong) NSString *title;
/// CDR id
@property (nonatomic, strong) NSString *Sid;
/// 段落id
@property (nonatomic, strong) NSString *paraId;



- (NSString *)paperURL;

- (NSString *)paperParaURL;

@end
