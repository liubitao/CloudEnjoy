//
//  OverlayInteractiveTransition.h
//  MainApp
//
//  Created by Kyo on 11/10/16.
//  Copyright © 2016 hzins. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TransitionAnimationDelegate;
@class KyoPanGestureRecognizer;

@interface TransitionAnimationInteractive : UIPercentDrivenInteractiveTransition<UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) KyoPanGestureRecognizer *gestureRecogniser;
@property (nonatomic, assign, readonly) BOOL interactionInProgress;

@property (weak, nonatomic) UIViewController *viewController;
@property (weak, nonatomic) TransitionAnimationDelegate *transitionAnimationDelegate;
@property (assign, nonatomic, readonly) BOOL wasCancelDismiss;    /**< 是否取消了滑动关闭，如果YES，则停止调用dismissblock */
@property (copy, nonatomic) void (^dismissBlock)(void); /**< 手势滑动关闭后触发的block */

- (void)dismissPanGestureRecognizer:(KyoPanGestureRecognizer *)recognizer;  /**< dismiss手势触发事件  子类可重写已达到不同的处理效果 */

@end

@interface KyoPanGestureRecognizer : UIPanGestureRecognizer

@end
