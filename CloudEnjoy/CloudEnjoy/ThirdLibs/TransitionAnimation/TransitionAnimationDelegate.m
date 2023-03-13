//
//  OverlayTransitioningDelegate.m
//  MainApp
//
//  Created by 元 on 16/9/18.
//  Copyright © 2016年 hzins. All rights reserved.
//

#import "TransitionAnimationDelegate.h"
#import "TransitionAnimationPosition.h"
#import "TransitionAnimationPresentationController.h"
#import "TransitionAnimationChangeAlpha.h"

@interface TransitionAnimationDelegate ()

@property (strong, nonatomic) NSObject<UIViewControllerAnimatedTransitioning > *animator;

@end

@implementation TransitionAnimationDelegate

#pragma mark ---------------------------
#pragma mark - Cyclelife

//返回presentationcontroller，处理模块动画的背景
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    
    if (self.viewAnimationType == ViewAnimationTypeTransformFromBottom || self.viewAnimationType == ViewAnimationTypeTransformFromRight || self.viewAnimationType == ViewAnimationTypeTransformFromLeft || self.viewAnimationType == ViewAnimationTypeTransformFromTop ) {
        
        TransitionAnimationPosition *transitionAnimationPosition = [[TransitionAnimationPosition alloc] init];
        transitionAnimationPosition.viewAnimationType = self.viewAnimationType;
        self.animator = transitionAnimationPosition;
        
    }else if (self.viewAnimationType == ViewAnimationTypeAlphagGradualChange){
        
        self.animator = [[TransitionAnimationChangeAlpha alloc] init];
    }
    
    TransitionAnimationPresentationController *overlayPresentationController = [[TransitionAnimationPresentationController alloc] initWithPresentedViewController:presented  presentingViewController:presenting];
    overlayPresentationController.overlayTransitioningType = self.overlayTransitioningType;
    overlayPresentationController.touchInBackgroundType = self.touchInBackgroundType;
    overlayPresentationController.viewAnimationType = self.viewAnimationType;
    overlayPresentationController.dismissBlock = self.dismissBlock;
    [overlayPresentationController setupView];
    
    TransitionAnimationInteractive *interactive = [self createInteractive];
    _interactive = interactive;
    interactive.viewController = presented;
    interactive.transitionAnimationDelegate = self;
    interactive.dismissBlock = self.dismissBlock;
    if (self.enableInteractive) {
        [presented.view addGestureRecognizer:interactive.gestureRecogniser];
    }
    
    return overlayPresentationController;
}

//presented动画时调用，返回动画实例
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.animator;
}

//dismissed动画时调用，返回动画实例
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self.animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return ((TransitionAnimationInteractive *)self.interactive).interactionInProgress ? self.interactive : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return ((TransitionAnimationInteractive *)self.interactive).interactionInProgress ? self.interactive : nil;
}

#pragma mark --------------------
#pragma mark - Settings, Gettings

- (void)setEnableInteractive:(BOOL)enableInteractive {
    _enableInteractive = enableInteractive;
    
    if (_enableInteractive) {
        if ([self.interactive.viewController.view.gestureRecognizers containsObject:self.interactive.gestureRecogniser] == NO) {
            [self.interactive.viewController.view addGestureRecognizer:self.interactive.gestureRecogniser];
        }
    } else {
        if ([self.interactive.viewController.view.gestureRecognizers containsObject:self.interactive.gestureRecogniser] == YES) {
            [self.interactive.viewController.view removeGestureRecognizer:self.interactive.gestureRecogniser];
        }
    }
}

#pragma mark --------------------
#pragma mark - Methods

/**< 创建手势控制对象  子类可重写以实现不同的手势控制处理 */
- (TransitionAnimationInteractive *)createInteractive {
    TransitionAnimationInteractive *interactive = [[TransitionAnimationInteractive alloc] init];
    return interactive;
}

@end
