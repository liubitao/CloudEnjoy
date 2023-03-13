//
//  OverlayPresentationController.m
//  MainApp
//
//  Created by 元 on 16/9/18.
//  Copyright © 2016年 hzins. All rights reserved.
//

#import "TransitionAnimationPresentationController.h"
#import "UIView-WhenTappedBlocks.h"

static CGFloat const kBackgroundColorAlpha = 0.3;   /**< 遮罩背景透明度 */

@interface TransitionAnimationPresentationController ()

@property (nonatomic,strong) UIView *dimmingView;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIView *snapshot;

@end

@implementation TransitionAnimationPresentationController

#pragma mark ---------------------------
#pragma mark - Cyclelife

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController;
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if(self) {
    }
    
    return self;
}

- (void)setupView {
    self.dimmingView = [[UIView alloc] init];
    self.snapshot = [[UIView alloc] init];
    self.maskView = [[UIView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [self.maskView whenTapped:^{
        if (weakSelf.touchInBackgroundType == TouchInBackgroundTypeClose) {
            UIViewController* presentedViewController = [weakSelf presentedViewController];
            [presentedViewController dismissViewControllerAnimated:YES completion:weakSelf.dismissBlock];
        }
    }];
    
    [self.dimmingView addSubview:self.maskView];
    self.dimmingView.backgroundColor = [UIColor clearColor];
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:kBackgroundColorAlpha];
    
    if (self.overlayTransitioningType == OverlayTransitioningTypeAnimator) {
        NSInteger scale = [UIScreen mainScreen].scale;
        UIView *fromView = [UIApplication sharedApplication].keyWindow;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(fromView.bounds.size.width, fromView.bounds.size.height), NO, scale);
        [fromView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
//            UIImage *img = [KyoUtil getImageFromView:[UIApplication sharedApplication].getKeyWindow useScreenScale:YES];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
        imgView.frame = [UIApplication sharedApplication].keyWindow.frame;
        [self.snapshot addSubview:imgView];
        self.dimmingView.backgroundColor = [UIColor blackColor];
        [self.dimmingView insertSubview:self.snapshot belowSubview:self.maskView];
    }
}

- (void)presentationTransitionWillBegin {
    UIView* containerView = [self containerView];
    UIViewController* presentedViewController = [self presentingViewController];
    
    if (self.overlayTransitioningType == OverlayTransitioningTypeAnimator) {
        
        self.snapshot.frame = containerView.bounds;
        self.maskView.frame = containerView.bounds;
        self.dimmingView.frame = containerView.bounds;
        self.maskView.alpha = 0;
        
        [containerView insertSubview:self.dimmingView atIndex:0];
        self.snapshot.layer.allowsEdgeAntialiasing = true;
        self.snapshot.layer.anchorPoint = CGPointMake(0.5, 1);
        self.snapshot.frame = CGRectMake(self.snapshot.frame.origin.x, 0, self.snapshot.frame.size.width,self.snapshot.frame.size.height);
        
    } else if (self.overlayTransitioningType == OverlayTransitioningTypeBlackBackground ||
               self.overlayTransitioningType == OverlayTransitioningTypeNormal) {
        UIColor *maskColor = [UIColor blackColor];
        maskColor = self.overlayTransitioningType == OverlayTransitioningTypeNormal ? [UIColor clearColor] : maskColor;
        
        if (self.viewAnimationType == ViewAnimationTypeTransformFromBottom || self.viewAnimationType == ViewAnimationTypeTransformFromRight || self.viewAnimationType == ViewAnimationTypeTransformFromLeft || self.viewAnimationType == ViewAnimationTypeTransformFromTop) {
            self.maskView.frame = containerView.bounds;
            self.dimmingView.frame = containerView.bounds;
            self.maskView.backgroundColor = maskColor;
            self.maskView.alpha = 0;
            [containerView insertSubview:self.dimmingView atIndex:0];
        }else{
            self.maskView.frame = containerView.bounds;
            self.dimmingView.frame = containerView.bounds;
            self.maskView.backgroundColor = maskColor;
            self.maskView.alpha = kBackgroundColorAlpha;
            [containerView insertSubview:self.dimmingView atIndex:0];
        }
        
    }
    
    [[presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.maskView.alpha = kBackgroundColorAlpha;
        
        if (self.overlayTransitioningType == OverlayTransitioningTypeAnimator) {
            __block CATransform3D transformation = CATransform3DIdentity;
            transformation.m24 = -0.0001;
            [UIView animateKeyframesWithDuration:0.6 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.45 animations:^{
                    self.snapshot.layer.transform = transformation;
                }];
                [UIView addKeyframeWithRelativeStartTime:0.55 relativeDuration:0.45 animations:^{
                    transformation = CATransform3DIdentity;
                    transformation = CATransform3DScale(transformation, 0.9, 0.9, 1);
                    CGFloat y = self.containerView.bounds.size.height * (0.9 - 1.0) / 2.0;
                    transformation = CATransform3DTranslate(transformation, 0, y, 0);
                    self.snapshot.layer.transform = transformation;
                }];
            } completion:nil];
        }
    } completion:nil];
}

-(void)dismissalTransitionWillBegin{
    UIViewController* presentedViewController = [self presentedViewController];
    
    [[presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.maskView.alpha = 0;
        
        if (self.overlayTransitioningType == OverlayTransitioningTypeAnimator) {
            CATransform3D transformation = CATransform3DIdentity;
            transformation.m24 = -0.0001;
            [UIView animateKeyframesWithDuration:0.6 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.45 animations:^{
                    self.snapshot.layer.transform = transformation;
                }];
                [UIView addKeyframeWithRelativeStartTime:0.55 relativeDuration:0.45 animations:^{
                    self.snapshot.layer.transform = CATransform3DIdentity;
                }];
            } completion:nil];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    }];
}

@end
