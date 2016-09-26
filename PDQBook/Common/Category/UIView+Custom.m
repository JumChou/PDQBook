//
//  UIView+Custom.m
//  AirPPT
//
//  Created by Mr.Chou on 15/6/10.
//  Copyright (c) 2015年 周 骏豪. All rights reserved.
//

#import "UIView+Custom.h"

@implementation UIView (Custom)

/**
 *  从view获得截图
 *
 *  @return image
 */
- (UIImage *)imageFromView {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


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
                  completionBlock:(void(^)(POPAnimation *anim, BOOL finished))completionBlock {
    CALayer *layer = self.layer;
//    [layer pop_removeAllAnimations]; // First let's remove any existing animations
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:propertyName];
    if (fromValue != FLT_MAX) {
        anim.fromValue = @(fromValue);
    }
    anim.toValue = @(toValue);
    anim.springSpeed = springSpeed;
    anim.springBounciness = springBounciness;
    anim.dynamicsFriction = dynamicsFriction;
    anim.beginTime = CACurrentMediaTime() + delay;
    anim.removedOnCompletion = YES;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        completionBlock(anim, finished);
    };
    
    [layer pop_addAnimation:anim forKey:key];
}


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
                         completionBlock:(void(^)(POPAnimation *anim, BOOL finished))completionBlock {
    [self setSpringAnimationWithKey:key
                       propertyName:propertyName
                          fromValue:fromValue
                            toValue:toValue
                              delay:delay
                        springSpeed:1.f
                   springBounciness:2.f
                   dynamicsFriction:16.0f
                    completionBlock:completionBlock];
}




@end
