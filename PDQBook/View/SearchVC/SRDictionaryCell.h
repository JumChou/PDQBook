//
//  SRDictionaryCell.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/17.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SRBasicCell.h"
#import "SRCellHeightCache.h"
@class SRDictionaryCell;

// Protocol ----------------------------------------------------------------------
@protocol SRDictionaryCellDelegate <NSObject>

@optional
- (void)expandBtnActionInCell:(SRDictionaryCell *)cell;

@end

// -------------------------------------------------------------------------------

#define SRDictionaryCell_Color_SwitchEN     Color_TextLightGray
#define SRDictionaryCell_Color_SwitchCN     Color_Blue

@interface SRDictionaryCell : SRBasicCell

/// delegate
@property (nonatomic, weak) id<SRDictionaryCellDelegate> delegate;
/// 展开情况
@property (nonatomic, assign) SRCellExpandedState expandedState;


#pragma mark - Mehtod
- (void)setUpViewsWithData:(NSArray *)data expandedState:(SRCellExpandedState)expandedState;


#pragma mark - ClassMethod
/**
 通过数据计算内容高度（不包含底部展开btn）
 
 @param data 展示数据
 
 @return 内容高度
 */
+ (CGFloat)calculateContentHeightWithData:(NSArray *)data;

/**
 根据内容高、展开情况计算完整高
 
 @param contentHeight 内容高
 @param expandedState 可否展开情况
 
 @return 完整高
 */
+ (CGFloat)calculateFullHeightWithContentHeight:(CGFloat)contentHeight
                                  expandedState:(SRCellExpandedState)expandedState;

/**
 通过数据、展开情况计算完整高
 
 @param data          展示数据
 @param expandedState 可否展开情况
 
 @return 完整高
 */
+ (CGFloat)calculateFullHeightWithData:(NSArray *)data
                         expandedState:(SRCellExpandedState)expandedState;

@end
