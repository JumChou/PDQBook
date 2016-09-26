//
//  UITableViewCell+StartAnimation.m
//  Translation
//
//  Created by Mr.Jiang on 15/11/30.
//  Copyright © 2015年 AirPPT. All rights reserved.
//

#import "UITableViewCell+StartAnimation.h"

@implementation UITableViewCell(StartAnimation)

- (void)startAnimationWithDelay:(CGFloat)delayTime
{
    self.contentView.transform =  CGAffineTransformMakeTranslation(kScreenWidth, 0);
    [UIView animateWithDuration:1. delay:delayTime usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:NULL];
}

@end
