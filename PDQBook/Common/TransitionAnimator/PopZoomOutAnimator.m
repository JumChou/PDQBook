//
//  PopZoomOutAnimator.m
//  Gump
//
//  Created by Mr.Chou on 15/5/18.
//  Copyright (c) 2015年 周 骏豪. All rights reserved.
//

#import "PopZoomOutAnimator.h"

@implementation PopZoomOutAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toVC.view];
    fromVC.view.transform = CGAffineTransformMakeScale(1, 1);
    fromVC.view.alpha = 1;
    toVC.view.alpha = 0; // toVC一定要变化才能动画？
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        fromVC.view.alpha = 0;
        toVC.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        fromVC.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

@end
