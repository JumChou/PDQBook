//
//  JCAnimatedArcView.h
//  PDQBook
//
//  Created by Mr.Chou on 2016/11/11.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCAnimatedArcView : UIView

/**
 *  画单色整环（需在布局完成后调用）
 *
 *  @param color            画笔颜色
 *  @param lineWidth        线宽度
 *  @param percent          完成百分比
 *  @param animatedDuration 动画duration（0为无动画效果）
 */
- (void)drawArcWithColor:(UIColor *)color
               lineWidth:(CGFloat)lineWidth
                 percent:(CGFloat)percent
        animatedDuration:(CFTimeInterval)animatedDuration;


/**
 *  画彩色整环（需在布局完成后调用）
 *
 *  @param lineWidth        线宽度
 *  @param percent          完成百分比
 *  @param animatedDuration 动画duration（0为无动画效果）
 */
- (void)drawColorfulArcWithLineWidth:(CGFloat)lineWidth
                             percent:(CGFloat)percent
                    animatedDuration:(CFTimeInterval)animatedDuration;


/**
 画彩色渐变不完整环形（需在布局完成后调用）

 @param leftColors 左侧渐变色Ary
 @param rightColors 右侧渐变色Ary
 @param leftLocations 左侧渐变色LocationAry
 @param rightLocations 右侧渐变色LocationAry
 @param trackArcColor 轨迹颜色
 @param lineWidth 环形宽
 @param percent 绘制百分比
 @param animatedDuration 动画时间
 */
- (void)drawMajorArcWithLeftColors:(NSArray<UIColor *> *)leftColors
                       rightColors:(NSArray<UIColor *> *)rightColors
                leftColorLocations:(NSArray<NSNumber *> *)leftLocations
               rightColorLocations:(NSArray<NSNumber *> *)rightLocations
                     trackArcColor:(UIColor *)trackArcColor
                         LineWidth:(CGFloat)lineWidth
                           percent:(CGFloat)percent
                  animatedDuration:(CFTimeInterval)animatedDuration;


@end
