//
//  JCTabBarView.h
//  PDQBook
//
//  Created by Mr.Chou on 16/7/26.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRNRealTimeBlurView.h"
@class JCTabBarView;

@protocol JCTabBarViewDelegate <NSObject>

- (void)tabBarView:(JCTabBarView *)tabBarView didSelectedIndex:(NSUInteger)selectedIndex;

@end

@interface JCTabBarView : UIView

@property (nonatomic, weak) id<JCTabBarViewDelegate> delegate;

- (id)initWithTitles:(NSArray *)titles btnBasicIMGName:(NSString *)btnBasicIMGName;

#pragma mark - Method
- (void)changeToSelectedIndex:(NSUInteger)selectedIndex;

- (void)changeMarkerWithXOffsetRatio:(CGFloat)xOffsetRatio;



@end
