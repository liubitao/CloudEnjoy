//
//  OverlayTransitioningDelegate.h
//  MainApp
//
//  Created by 元 on 16/9/18.
//  Copyright © 2016年 hzins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitionAnimationInteractive.h"

/**---调用示例
 UIViewController *viewController = [[UIViewController alloc] init];
 self.transitionAnimationDelegate = [[OverlayTransitioningDelegate alloc] init];
 self.transitionAnimationDelegate.viewAnimationType = ViewAnimationTypeTransformFromTop;
 self.transitionAnimationDelegate.overlayTransitioningType = OverlayTransitioningTypeBlackBackground;
 viewController.transitioningDelegate = self.transitionAnimationDelegate;
 viewController.modalPresentationStyle =  UIModalPresentationCustom;
 [self.navigationController presentViewController:viewController animated:YES completion:nil];
**/


/**<
 @pram  OverlayTransitioningTypeNormal = 0,//正常的跳转，背景色透明
 @pram OverlayTransitioningTypeAnimator = 1,//有矩阵动画和黑色的背景色
 @pram  OverlayTransitioningTypeBlackBackGround = 2 //只有黑色的背景
 */

typedef NS_ENUM(NSUInteger, OverlayTransitioningType) {
    OverlayTransitioningTypeNormal = 0,
    OverlayTransitioningTypeAnimator = 1,
    OverlayTransitioningTypeBlackBackground = 2
};

/**<
 @pram TouchInBackgroundTypeClose = 0,//点击黑色的背景退出
 @pram TouchInBackgroundTypeDoNothing = 1,//点击黑色的背景没有任何反应
 */

typedef NS_ENUM(NSUInteger, TouchInBackgroundType) {
    TouchInBackgroundTypeClose = 0,
    TouchInBackgroundTypeDoNothing = 1,
};


/**<
 @pram ViewAnimationTypeTransformFromBottom = 0,//从底部弹出
 @pram ViewAnimationTypeTransformFromTop = 1,//从上面弹出
 @pram ViewAnimationTypeTransformFromRight = 2,//从右边弹出
 @pram  ViewAnimationTypeTransformFromLeft = 3,//从左边弹出
 @pram  ViewAnimationTypeAlphagGradualChange = 4,//透明度渐变式弹出
 */

typedef NS_ENUM(NSUInteger, ViewAnimationType) {
    ViewAnimationTypeTransformFromBottom = 0,
    ViewAnimationTypeTransformFromTop = 1,
    ViewAnimationTypeTransformFromRight = 2,
    ViewAnimationTypeTransformFromLeft = 3,
    ViewAnimationTypeAlphagGradualChange = 4,
};


/**< 注意这个delegate放入vc中是weak属性，如此delegate被释放，会导致不能触发滑动手势等问题 */
@interface TransitionAnimationDelegate : NSObject<UIViewControllerTransitioningDelegate>

@property (assign, nonatomic) OverlayTransitioningType  overlayTransitioningType;
@property (assign, nonatomic) TouchInBackgroundType    touchInBackgroundType;
@property (assign, nonatomic) ViewAnimationType        viewAnimationType;
@property (strong, nonatomic, readonly) TransitionAnimationInteractive *interactive;  /**< 手势控制对象 */
@property (assign, nonatomic) BOOL enableInteractive;   /**< 是否开启手势滑动，默认不开启 */
@property (copy, nonatomic) void (^dismissBlock)(void); /**< 手势滑动关闭或点击背景关闭后触发的block */

- (TransitionAnimationInteractive *)createInteractive;  /**< 创建手势控制对象  子类可重写以实现不同的手势控制处理 */

@end

