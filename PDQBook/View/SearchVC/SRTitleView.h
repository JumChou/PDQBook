//
//  SRTitleView.h
//  PDQBook
//
//  Created by Mr.Chou on 16/9/7.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SRTitleView_Color_Title     Color_Navy

static const CGFloat SRTitleView_H = 38.f;
static const CGFloat SRTitleView_Flag_Leading = 20.f;
static const CGFloat SRTitleView_Flag_W = 4.f;
static const CGFloat SRTitleView_Flag_H = 15.f;
static const CGFloat SRTitleView_TitleLab_Leading = 10.f;
static const CGFloat SRTitleView_TitleLab_FontSize = 16.f;
static const CGFloat SRTitleView_BottomLine_Leading = 10.f;

@interface SRTitleView : UIView


- (void)configureWithTitle:(NSString *)title;

@end
