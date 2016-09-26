//
//  UIView+Custom.h
//  AirPPT
//
//  Created by Mr.Chou on 15/6/10.
//  Copyright (c) 2015年 周 骏豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP/POP.h>

@interface UIView (Custom)

/**
 *  从view获得截图
 *
 *  @return image
 */
- (UIImage *)imageFromView;


#pragma mark - Animation
/**
 *  @author zhoujunhao, 2016-07-15 14:51:00
 *  @since  v1.0.0
 *
 *  设置Spring动画
 *
 *  @param key              动画key标识
 *  @param propertyName     动画的属性名称，如kPOPLayerPositionY
 *  @param fromValue        开始value(不设置传FLT_MAX)
 *  @param toValue          目标value
 *  @param delay            延迟执行时间s
 *  @param springSpeed      速度-取值范围[0, 20]，默认为12
 *  @param springBounciness 弹力-取值范围为[0, 20]，默认值为4
 *  @param dynamicsFriction 摩擦力
 *  @param completionBlock  完成block
 *
 */
- (void)setSpringAnimationWithKey:(NSString *)key
                     propertyName:(NSString *)propertyName
                        fromValue:(CGFloat)fromValue
                          toValue:(CGFloat)toValue
                            delay:(CFTimeInterval)delay
                      springSpeed:(CGFloat)springSpeed
                 springBounciness:(CGFloat)springBounciness
                 dynamicsFriction:(CGFloat)dynamicsFriction
                  completionBlock:(void(^)(POPAnimation *anim, BOOL finished))completionBlock;


/**
 *  @author zhoujunhao, 2016-07-15 14:51:00
 *  @since  v1.0.0
 *
 *  设置默认的Spring动画
 *
 *  @param key              动画key标识
 *  @param propertyName     动画的属性名称，如kPOPLayerPositionY
 *  @param fromValue        开始value(不设置传FLT_MAX)
 *  @param toValue          目标value
 *  @param delay            延迟执行时间s
 *  @param completionBlock  完成block
 *
 */
- (void)setSpringAnimationDefaultWithKey:(NSString *)key
                            propertyName:(NSString *)propertyName
                               fromValue:(CGFloat)fromValue
                                 toValue:(CGFloat)toValue
                                   delay:(CFTimeInterval)delay
                         completionBlock:(void(^)(POPAnimation *anim, BOOL finished))completionBlock;




@end
