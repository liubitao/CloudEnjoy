//
//  OverlayPresentationController.h
//  MainApp
//
//  Created by 元 on 16/9/18.
//  Copyright © 2016年 hzins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionAnimationDelegate.h"

@interface TransitionAnimationPresentationController : UIPresentationController

@property (assign, nonatomic) OverlayTransitioningType  overlayTransitioningType;
@property (assign, nonatomic) TouchInBackgroundType    touchInBackgroundType;
@property (assign, nonatomic) ViewAnimationType        viewAnimationType;
@property (copy, nonatomic) void (^dismissBlock)(void); /**< 手势滑动关闭或点击背景关闭后触发的block */

- (void)setupView;

@end
