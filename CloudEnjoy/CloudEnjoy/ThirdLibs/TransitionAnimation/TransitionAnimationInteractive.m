//
//  OverlayInteractiveTransition.m
//  MainApp
//
//  Created by Kyo on 11/10/16.
//  Copyright © 2016 hzins. All rights reserved.
//

#import "TransitionAnimationInteractive.h"
#import "TransitionAnimationDelegate.h"

#define dissmissLessDuration    0.25f   //小于这个时间都算快速滑动并执行侧滑
#define MultiPowerMorethanLength    480 //超过这个长度（根据枚举判断是x或y【目前只做y判断，以后可以拓展判断x】）百分比计算翻倍（因为太长手滑动不了太长距离）
#define MultiPowerNum   1   //百分比计算翻倍的倍率
#define CRITICAL_PERCENTAGE    0.34f    //达到dismiss的临界百分比 34%

@interface TransitionAnimationInteractive()

@property (assign, nonatomic) NSTimeInterval timeInterval;

@end

@implementation TransitionAnimationInteractive

#pragma mark --------------------
#pragma mark - CycLife

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gestureRecogniser = [[KyoPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPanGestureRecognizer:)];
        self.gestureRecogniser.delegate = self;
        self.completionCurve = UIViewAnimationCurveLinear;  //使得手势关闭平滑（手指放开达到关闭临界点，自动关闭时平滑动画）
    }
    return self;
}

#pragma mark --------------------
#pragma mark - Settings, Gettings

#pragma mark --------------------
#pragma mark - Events

#pragma mark --------------------
#pragma mark - Methods

#pragma mark --------------------
#pragma mark - UIGestureRecognizer

- (void)dismissPanGestureRecognizer:(KyoPanGestureRecognizer *)recognizer
{
    //计算进度百分比
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGFloat percentage = 0;
    if (self.transitionAnimationDelegate.viewAnimationType == ViewAnimationTypeTransformFromRight ||
        self.transitionAnimationDelegate.viewAnimationType == ViewAnimationTypeTransformFromLeft) {  //x轴计算
        percentage  = MAX(translation.x / CGRectGetWidth(recognizer.view.bounds), 0);
    } else {    //y轴计算
        CGFloat length = CGRectGetHeight(recognizer.view.bounds);
        percentage  = MAX(translation.y / length, 0);
        if (length >= MultiPowerMorethanLength) {   //超过长度，百分比翻倍
            percentage *= MultiPowerNum;
        }
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            _interactionInProgress = YES;
            self.timeInterval = [[NSDate date] timeIntervalSince1970];
            __weak typeof(self) weakSelf = self;
            [self.viewController dismissViewControllerAnimated:YES completion:^{
                if (weakSelf.wasCancelDismiss == NO && weakSelf.dismissBlock != nil) {
                    weakSelf.dismissBlock();
                }
            }];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition:percentage];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            if(percentage >= CRITICAL_PERCENTAGE ||
               [[NSDate date] timeIntervalSince1970] - self.timeInterval <= dissmissLessDuration) {
                _wasCancelDismiss = NO;
                [self finishInteractiveTransition];
            } else {
                _wasCancelDismiss = YES;
                [self cancelInteractiveTransition];
            }
            _interactionInProgress = NO;
            break;
            
        case UIGestureRecognizerStateCancelled:
            _wasCancelDismiss = YES;
            [self cancelInteractiveTransition];
            _interactionInProgress = NO;
            
        default:
            break;
    }
}

#pragma mark --------------------
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //如果是navigation且已经push到子页面，不能手势dismiss
    if (self.gestureRecogniser == gestureRecognizer &&
        [self.viewController isKindOfClass:[UINavigationController class]] &&
        ((UINavigationController *)self.viewController).viewControllers.count > 1) {
        return NO;
    }
    
    return YES;
}


#pragma mark --------------------
#pragma mark - NSNotification

#pragma mark --------------------
#pragma mark - KVO/KVC



@end

@interface KyoPanGestureRecognizer()

@end

@implementation KyoPanGestureRecognizer

@end
