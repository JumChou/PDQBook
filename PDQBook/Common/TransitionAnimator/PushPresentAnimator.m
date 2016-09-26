//
//  PushPresentAnimator.m
//  Gump
//
//  Created by Mr.Chou on 15/5/26.
//  Copyright (c) 2015年 周 骏豪. All rights reserved.
//

#import "PushPresentAnimator.h"
#import "CommonDefine.h"

@implementation PushPresentAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
//    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toVC.view];
    toVC.view.alpha = 0;
//    toVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    toVC.view.transform = CGAffineTransformMakeTranslation(0, 2*kScreenHeight);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.transform = CGAffineTransformIdentity;
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        toVC.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}



@end
