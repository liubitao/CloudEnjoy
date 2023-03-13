//
//  AlphaChangeViewControllerAnimator.m
//  MainApp
//
//  Created by yuan on 2016/10/19.
//  Copyright © 2016年 hzins. All rights reserved.
//

#import "TransitionAnimationChangeAlpha.h"

@implementation TransitionAnimationChangeAlpha

#pragma mark ---------------------------
#pragma mark - Cyclelife

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    if ([transitionContext viewForKey:UITransitionContextToViewKey] != nil) {//如果是presented动画
        return 0.25;
    }else if ([transitionContext viewForKey:UITransitionContextFromViewKey] != nil){ //如果是dismiss动画
        return 0.3;
    }else{
        return 0.3;
    }
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey]; //如果是presented动画
    UIView *dismissedView = [transitionContext viewForKey:UITransitionContextFromViewKey];//如果是dismiss动画
    
    if (presentedView != nil) {
        presentedView.alpha = 0;
        [transitionContext.containerView addSubview:presentedView];
        [UIView  animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            presentedView.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }else if (dismissedView != nil){
        dismissedView.alpha = 1;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            dismissedView.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}


@end
