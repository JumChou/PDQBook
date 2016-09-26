//
//  CCUnitGroups.m
//  PDQBook
//
//  Created by Mr.Chou on 16/9/20.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "CCUnitGroups.h"

@interface CCUnitGroups ()

@property (nonatomic, strong) NSMutableArray *unitGroups;

@end

@implementation CCUnitGroups

- (id)init {
    self = [super init];
    if (self) {
        self.unitGroups = [[NSMutableArray alloc] init];
        [self initTestData];
        
    }
    
    return self;
}


#pragma mark - Method
/**
 根据indexPath获取CCUnit数据
 
 @param indexPath indexPath索引
 
 @return CCUnit
 */
- (CCUnit *)getDataWithIndexPath:(NSIndexPath *)indexPath {
    CCUnit *unit;
    
    if (self.unitGroups && self.unitGroups.count) {
        if (indexPath.section >= 0) {
            NSArray *unitGroup = self.unitGroups[indexPath.section];
            if (indexPath.row >= 0) {
                unit = unitGroup[indexPath.row];
            }
        }
    }
    
    return unit;
}













#pragma mark - Test
- (void)initTestData {
    CCUnit *unit1 = [[CCUnit alloc] init];
    unit1.unitLevel = CCUnitLevel_Paper;
    unit1.title = @"肺癌的预防（PDQ®）";
    CCUnit *unit2 = [[CCUnit alloc] init];
    unit2.unitLevel = CCUnitLevel_Section;
    unit2.title = @"基本信息";
    CCUnit *unit3 = [[CCUnit alloc] init];
    unit3.unitLevel = CCUnitLevel_Paragraph;
    unit3.title = @"危险人群有哪些？";
    CCUnit *unit4 = [[CCUnit alloc] init];
    unit4.unitLevel = CCUnitLevel_Paragraph;
    unit4.title = @"降低肺癌风险的干预";
    CCUnit *unit5 = [[CCUnit alloc] init];
    unit5.unitLevel = CCUnitLevel_Paragraph;
    unit5.title = @"对可增加肺癌风险相关因素的干预";
    CCUnit *unit6 = [[CCUnit alloc] init];
    unit6.unitLevel = CCUnitLevel_Paragraph;
    unit6.title = @"不降低肺癌风险的干预";
    //---
    CCUnit *unit7 = [[CCUnit alloc] init];
    unit7.unitLevel = CCUnitLevel_Section;
    unit7.title = @"证据描述";
    CCUnit *unit8 = [[CCUnit alloc] init];
    unit8.unitLevel = CCUnitLevel_Paragraph;
    unit8.title = @"背景";
    CCUnit *unit9 = [[CCUnit alloc] init];
    unit9.unitLevel = CCUnitLevel_Paragraph;
    unit9.title = @"危险因素";
    CCUnit *unit10 = [[CCUnit alloc] init];
    unit10.unitLevel = CCUnitLevel_Paragraph;
    unit10.title = @"与肺癌风险降低相关的干预";
    CCUnit *unit11 = [[CCUnit alloc] init];
    unit11.unitLevel = CCUnitLevel_Paragraph;
    unit11.title = @"与肺癌风险增加相关的干预";
    CCUnit *unit12 = [[CCUnit alloc] init];
    unit12.unitLevel = CCUnitLevel_Paragraph;
    unit12.title = @"充分证据表明不降低风险的干预";
    NSArray *group1 = @[unit1, unit2, unit3, unit4, unit5, unit6, unit7, unit8, unit9, unit10, unit11, unit12];
    
    CCUnit *unit13 = [[CCUnit alloc] init];
    unit13.unitLevel = CCUnitLevel_Paper;
    unit13.title = @"肺癌的预防（PDQ®）";
    CCUnit *unit14 = [[CCUnit alloc] init];
    unit14.unitLevel = CCUnitLevel_Section;
    unit14.title = @"预防是什么？";
    CCUnit *unit15 = [[CCUnit alloc] init];
    unit15.unitLevel = CCUnitLevel_Section;
    unit15.title = @"肺癌总论";
    CCUnit *unit16 = [[CCUnit alloc] init];
    unit16.unitLevel = CCUnitLevel_Section;
    unit16.title = @"肺癌的预防";
    NSArray *group2 = @[unit13, unit14, unit15, unit16];
    
    [self.unitGroups addObject:group1];
    [self.unitGroups addObject:group2];
}



@end
