//
//  SRBasicCell.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/20.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRTitleView.h"
#import "SearchResult.h"

#define SRBasicCell_Color_Title     Color_Navy

//static const CGFloat SRBasicCell_BG_Bottom = 10.f;
static const CGFloat SRBasicCell_BG_Bottom = 0.f;
static const CGFloat SRBasicCell_ALine_H = 0.5f;

@interface SRBasicCell : UITableViewCell

@property (nonatomic, strong) UIView *BGView;
@property (nonatomic, strong) SRTitleView *titleView;

@property (nonatomic, assign) SRLanguage language;


#pragma mark - PrivateMethod
- (void)initViews;

+ (UIView *)getALine;


#pragma mark - ClassMethod
/**
 限制高度
 
 @return CGFloat
 */
+ (CGFloat)limitHeight;



@end
