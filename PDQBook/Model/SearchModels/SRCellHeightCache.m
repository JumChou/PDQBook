//
//  SRCellHeightCache.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/19.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SRCellHeightCache.h"

@interface SRCellHeightCache ()



@end

@implementation SRCellHeightCache

- (id)initWithIndexPath:(NSIndexPath *)indexPath
          expandedState:(SRCellExpandedState)expandedState
            limitHeight:(CGFloat)limitHeight
             fullHeight:(CGFloat)fullHeight {
    self = [self init];
    if (self) {
        self.indexPath = indexPath;
        self.expandedState = expandedState;
        self.limitHeight = limitHeight;
        self.fullHeight = fullHeight;
    }
    
    return self;
}

- (CGFloat)height {
    if (self.expandedState == ExpandedState_NO) { // 缩起状态
        return self.limitHeight;
    } else {
        return self.fullHeight;
    }
}






@end
