//
//  CCUnitGroups.h
//  PDQBook
//
//  Created by Mr.Chou on 16/9/20.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "BasicNetworkingModel.h"
#import "CCUnit.h"

@interface CCUnitGroups : BasicNetworkingModel


#pragma mark - Method
/**
 根据indexPath获取CCUnit数据

 @param indexPath indexPath索引

 @return CCUnit
 */
- (CCUnit *)getDataWithIndexPath:(NSIndexPath *)indexPath;



@end
