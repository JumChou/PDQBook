//
//  PushZoomInAnimator.m
//  Gump
//
//  Created by Mr.Chou on 15/5/18.
//  Copyright (c) 2015年 周 骏豪. All rights reserved.
//

#import "PushZoomInAnimator.h"

@implementation PushZoomInAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
//    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toVC.view];
    toVC.view.alpha = 0;
    toVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.transform = CGAffineTransformMakeScale(1, 1);
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        toVC.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

@end
