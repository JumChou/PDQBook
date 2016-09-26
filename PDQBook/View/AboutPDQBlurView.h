//
//  AboutPDQBlurView.h
//  PDQBook
//
//  Created by Mr.Chou on 16/9/12.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "DRNRealTimeBlurView.h"
@class AboutPDQBlurView;

@protocol AboutPDQBlurViewDelegate <NSObject>

@optional
- (void)aboutPDQBlurView:(AboutPDQBlurView *)aboutView didTappedCloseBtn:(id)sender;

@end

@interface AboutPDQBlurView : DRNRealTimeBlurView

@property (nonatomic, assign) BOOL isAutoAnimation;
@property (nonatomic, weak) id<AboutPDQBlurViewDelegate> delegate;


#pragma mark - Init
+ (AboutPDQBlurView *)aboutPDQBlurView;


#pragma mark - Animation
- (void)showAnimationsWithCompletion:(void (^)())completion;

- (void)fadeoutAnimationsWithCompletion:(void (^)())completion;


@end
