//
//  BouncyViewControllerAnimator.m
//  MainApp
//
//  Created by 元 on 16/9/18.
//  Copyright © 2016年 hzins. All rights reserved.
//

#import "TransitionAnimationPosition.h"


#define kWindowWidth [UIScreen mainScreen].bounds.size.width
#define kWindowHeight [UIScreen mainScreen].bounds.size.height
@interface TransitionAnimationPosition ()

@end

@implementation TransitionAnimationPosition

#pragma mark ---------------------------
#pragma mark - Cyclelife

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    if ([transitionContext viewForKey:UITransitionContextToViewKey] != nil) {//如果是presented动画
        return 0.2;
    }else if ([transitionContext viewForKey:UITransitionContextFromViewKey] != nil){ //如果是dismiss动画
        return 0.25;
    }else{
        return 0.3;
    }
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey]; //如果是presented动画
    UIView *dismissedView = [transitionContext viewForKey:UITransitionContextFromViewKey];//如果是dismiss动画
    
    if (presentedView != nil) {
        CGPoint viewCenter = presentedView.center;
        [self setViewOriginalPosition:presentedView];
        [transitionContext.containerView addSubview:presentedView];
        [UIView  animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self setViewAfterTransitionPosition:presentedView andCenter:viewCenter];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else if (dismissedView != nil) {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self setViewOriginalPosition:dismissedView];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

#pragma mark --------------------
#pragma mark - Methods

/**< 动画转变迁的位置坐标 */
- (void)setViewOriginalPosition:(UIView *)view {
    if (self.viewAnimationType == ViewAnimationTypeTransformFromBottom) {
        view.center = CGPointMake(view.center.x, kWindowHeight + (view.frame.size.height) / 2);
    } else if (self.viewAnimationType == ViewAnimationTypeTransformFromTop) {
        view.center = CGPointMake(view.center.x,  -(view.frame.size.height) / 2);
    } else if (self.viewAnimationType == ViewAnimationTypeTransformFromRight) {
        view.center = CGPointMake(kWindowWidth + view.frame.size.width / 2, view.center.y);
    }else if (self.viewAnimationType == ViewAnimationTypeTransformFromLeft) {
        view.center = CGPointMake(-view.frame.size.width / 2, view.center.y);
    }
}

/**< 动画转变后的位置坐标 */
- (void)setViewAfterTransitionPosition:(UIView *)view andCenter:(CGPoint)viewCenter {
    if (self.viewAnimationType == ViewAnimationTypeTransformFromBottom) {
        view.center = CGPointMake(viewCenter.x, kWindowHeight - viewCenter.y);
    }else if (self.viewAnimationType == ViewAnimationTypeTransformFromTop) {
        view.center = CGPointMake(viewCenter.x,  viewCenter.y);
    } else if (self.viewAnimationType == ViewAnimationTypeTransformFromRight) {
        view.center = CGPointMake(kWindowWidth - viewCenter.x, viewCenter.y);
    } else if (self.viewAnimationType == ViewAnimationTypeTransformFromLeft) {
        view.center = CGPointMake(viewCenter.x,  viewCenter.y);
    }
}

@end
