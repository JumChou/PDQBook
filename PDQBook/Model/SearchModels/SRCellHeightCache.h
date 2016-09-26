//
//  SRCellHeightCache.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/19.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "BasicModel.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SRCellExpandedState) {
    ExpandedState_None,
    ExpandedState_Yes,
    ExpandedState_NO
};

@interface SRCellHeightCache : BasicModel

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) SRCellExpandedState expandedState;
@property (nonatomic, assign) CGFloat limitHeight;
@property (nonatomic, assign) CGFloat fullHeight;

@property (nonatomic, assign) BOOL isNeedNewValue;


- (id)initWithIndexPath:(NSIndexPath *)indexPath
          expandedState:(SRCellExpandedState)expandedState
            limitHeight:(CGFloat)limitHeight
             fullHeight:(CGFloat)fullHeight;

- (CGFloat)height;



@end
