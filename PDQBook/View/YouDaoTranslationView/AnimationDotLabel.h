//
//  AnimationDotLabel2.h
//  DotAnimationDemo
//
//  Created by Mr.Jiang on 15/3/24.
//  Copyright (c) 2015年 JasonRyan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AnimationDotLabel : UILabel

/* 是否执行动画 */
@property (nonatomic, assign) BOOL animated;

/* 动画执行速度： 默认0.5秒 执行一次 */
@property (nonatomic, assign) CGFloat animateInterval;

/* 让进行界面重绘的CADisplayLink失效*/
- (void)invalidate;




@end
