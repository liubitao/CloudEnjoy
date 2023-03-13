//
//  BouncyViewControllerAnimator.h
//  MainApp
//
//  Created by 元 on 16/9/18.
//  Copyright © 2016年 hzins. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "TransitionAnimationDelegate.h"


@interface TransitionAnimationPosition : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) ViewAnimationType    viewAnimationType;

@end
