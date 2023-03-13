//
//  JMRefreshControlViewWave.m
//  JuMi(HD)
//
//  Created by Kyo on 8/15/17.
//  Copyright © 2017 JuMi. All rights reserved.
//

#import "JMRefreshControlViewWave.h"

static CGSize const REFRESH_CONTROL_VIEW_WAVE_SIZE = {55, 65};  //波纹view的size
static CGFloat const REFRESH_CONTROL_VIEW_WAVE_FORE_BACK_SEP = 88;  //前景波浪和后景波浪的间距
static NSTimeInterval const REFRESH_CONTROL_VIEW_WAVE__DURATION = 6.0;   //波浪动画时长
static NSTimeInterval const REFRESH_CONTROL_VIEW_OPACITY_SHOW_DURATION = 0.5;   //渐显动画时长
static NSTimeInterval const REFRESH_CONTROL_VIEW_OPACITY_HIDE_DURATION = 0.5;   //渐隐动画时长

@interface JMRefreshControlViewWave()<CAAnimationDelegate> {
    BOOL _isAnimation;  /**< 是否正在动画中 */
    CFTimeInterval _opacityShowTime;    //渐显动画开始时间
    CFTimeInterval _opacityHideTime;    //渐隐动画开始时间
}

@property (strong, nonatomic) UIView *waveView;
@property (strong, nonatomic) CALayer *foreWaveLayer;   //前景波浪
@property (strong, nonatomic) CALayer *lastForeWaveLayer;   //后面的前景波浪
@property (strong, nonatomic) CALayer *backWaveLayer;   //后景波浪
@property (strong, nonatomic) CALayer *lastBackWaveLayer;   //后面的后景波浪

@property (strong, nonatomic) UIImage *imgWaterBackground;
@property (strong, nonatomic) UIImage *imgWaterForeground;

- (BOOL)startAnimation;
- (BOOL)stopAnimation:(BOOL)removeAll;

@end

@implementation JMRefreshControlViewWave

#pragma mark --------------------
#pragma mark - CycLife

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self commonSetupOnInit];
    
    return self;
}

- (void)dealloc {
    [self stopAnimation:YES];
}

#pragma mark --------------------
#pragma mark - Settings, Gettings

#pragma mark --------------------
#pragma mark - Events

#pragma mark --------------------
#pragma mark - Methods

//重置子视图的坐标
- (void)reChangeSubViewOrgin {
    //设置position有显示动画，所以这里要关闭动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];//关闭动画
    [self layoutIfNeeded];
    [CATransaction commit];
}

- (BOOL)startAnimation {
    if (!self.foreWaveLayer ||
        !self.lastForeWaveLayer ||
        !self.backWaveLayer ||
        !self.lastBackWaveLayer) {
        return NO;
    }
    
    if (([self.foreWaveLayer animationForKey:@"opacity"] && [self.foreWaveLayer animationForKey:@"position"]) ||
        ([self.lastForeWaveLayer animationForKey:@"opacity"] && [self.lastForeWaveLayer animationForKey:@"position"]) ||
        ([self.backWaveLayer animationForKey:@"opacity"] && [self.backWaveLayer animationForKey:@"position"]) ||
        ([self.lastBackWaveLayer animationForKey:@"opacity"] && [self.lastBackWaveLayer animationForKey:@"position"])) {
        return NO;
    }
    
    _isAnimation = YES;
    
//    CABasicAnimation *opacityBackAnimation = (CABasicAnimation *)[self.foreWaveLayer animationForKey:@"opacityBack"];
    
    _opacityShowTime = [self.waveView.layer convertTime:CACurrentMediaTime() fromLayer:nil];

    //前景波浪动画
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        animation.duration = REFRESH_CONTROL_VIEW_WAVE__DURATION;
        animation.fromValue = @(REFRESH_CONTROL_VIEW_WAVE_SIZE.width - self.imgWaterForeground.size.width);
        animation.toValue = @(REFRESH_CONTROL_VIEW_WAVE_SIZE.width);
        animation.repeatCount = INFINITY;
        animation.delegate = self;
        [self.foreWaveLayer addAnimation:animation forKey:@"position"];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = REFRESH_CONTROL_VIEW_OPACITY_SHOW_DURATION;
        opacityAnimation.fromValue = @(self.foreWaveLayer.presentationLayer.opacity);
        opacityAnimation.toValue = @(1);
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        [self.foreWaveLayer addAnimation:opacityAnimation forKey:@"opacity"];
    }
    
    //后面的前景波浪动画
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        animation.duration = REFRESH_CONTROL_VIEW_WAVE__DURATION;
        animation.fromValue = @(REFRESH_CONTROL_VIEW_WAVE_SIZE.width - self.imgWaterForeground.size.width * 2);
        animation.toValue = @(REFRESH_CONTROL_VIEW_WAVE_SIZE.width - self.imgWaterForeground.size.width);
        animation.repeatCount = INFINITY;
        animation.delegate = self;
        [self.lastForeWaveLayer addAnimation:animation forKey:@"position"];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = REFRESH_CONTROL_VIEW_OPACITY_SHOW_DURATION;
        opacityAnimation.fromValue = @(self.lastForeWaveLayer.presentationLayer.opacity);
        opacityAnimation.toValue = @(1);
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        [self.lastForeWaveLayer addAnimation:opacityAnimation forKey:@"opacity"];
    }
    
    //后景波浪动画
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        animation.duration = REFRESH_CONTROL_VIEW_WAVE__DURATION;
        animation.fromValue = @(REFRESH_CONTROL_VIEW_WAVE_SIZE.width + REFRESH_CONTROL_VIEW_WAVE_FORE_BACK_SEP - self.imgWaterBackground.size.width);
        animation.toValue = @(REFRESH_CONTROL_VIEW_WAVE_SIZE.width + REFRESH_CONTROL_VIEW_WAVE_FORE_BACK_SEP);
        animation.repeatCount = INFINITY;
        animation.delegate = self;
        [self.backWaveLayer addAnimation:animation forKey:@"position"];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = REFRESH_CONTROL_VIEW_OPACITY_SHOW_DURATION;
        opacityAnimation.fromValue = @(self.backWaveLayer.presentationLayer.opacity);
        opacityAnimation.toValue = @(1);
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        [self.backWaveLayer addAnimation:opacityAnimation forKey:@"opacity"];
    }
    
    //后面的后景波浪动画
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        animation.duration = REFRESH_CONTROL_VIEW_WAVE__DURATION;
        animation.fromValue = @(REFRESH_CONTROL_VIEW_WAVE_SIZE.width + REFRESH_CONTROL_VIEW_WAVE_FORE_BACK_SEP - self.imgWaterBackground.size.width * 2);
        animation.toValue = @(REFRESH_CONTROL_VIEW_WAVE_SIZE.width + REFRESH_CONTROL_VIEW_WAVE_FORE_BACK_SEP - self.imgWaterBackground.size.width);
        animation.repeatCount = INFINITY;
        animation.delegate = self;
        [self.lastBackWaveLayer addAnimation:animation forKey:@"position"];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = REFRESH_CONTROL_VIEW_OPACITY_SHOW_DURATION;
        opacityAnimation.fromValue = @(self.lastBackWaveLayer.presentationLayer.opacity);
        opacityAnimation.toValue = @(1);
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        [self.lastBackWaveLayer addAnimation:opacityAnimation forKey:@"opacity"];
    }
    
    return YES;
}

- (BOOL)stopAnimation:(BOOL)removeAll {
    _isAnimation = NO;
    
    if (removeAll) {
        [self.foreWaveLayer removeAllAnimations];
        [self.lastForeWaveLayer removeAllAnimations];
        [self.backWaveLayer removeAllAnimations];
        [self.lastBackWaveLayer removeAllAnimations];
        return YES;
    }
    
    CABasicAnimation *opacityAnimation = (CABasicAnimation *)[self.foreWaveLayer animationForKey:@"opacity"];
    _opacityHideTime = [self.waveView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    CGFloat currentShowOpacityTime = MIN(_opacityHideTime - _opacityShowTime, REFRESH_CONTROL_VIEW_OPACITY_SHOW_DURATION);  //当前渐显已用时长
    CGFloat currentShowOpacity = MIN(currentShowOpacityTime / REFRESH_CONTROL_VIEW_OPACITY_SHOW_DURATION, 1);   //当前渐显数值
    CGFloat hideDuration = REFRESH_CONTROL_VIEW_OPACITY_HIDE_DURATION * currentShowOpacityTime / REFRESH_CONTROL_VIEW_OPACITY_SHOW_DURATION;    //渐隐需要时长
    
    [self.foreWaveLayer removeAnimationForKey:@"opacity"];
    [self.lastForeWaveLayer removeAnimationForKey:@"opacity"];
    [self.backWaveLayer removeAnimationForKey:@"opacity"];
    [self.lastBackWaveLayer removeAnimationForKey:@"opacity"];
    
    if (opacityAnimation) {

        //前景波浪动画
        {
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.duration = hideDuration;
            opacityAnimation.fromValue = @(currentShowOpacity);
            opacityAnimation.toValue = @(0);
            [self.foreWaveLayer addAnimation:opacityAnimation forKey:@"opacityBack"];
        }
        
        //后面的前景波浪动画
        {
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.duration = hideDuration;
            opacityAnimation.fromValue = @(currentShowOpacity);
            opacityAnimation.toValue = @(0);
            [self.lastForeWaveLayer addAnimation:opacityAnimation forKey:@"opacityBack"];
        }
        
        //后景波浪动画
        {
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.duration = hideDuration;
            opacityAnimation.fromValue = @(currentShowOpacity);
            opacityAnimation.toValue = @(0);
            [self.backWaveLayer addAnimation:opacityAnimation forKey:@"opacityBack"];
        }
        
        //后面的后景波浪动画
        {
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.duration = hideDuration;
            opacityAnimation.fromValue = @(currentShowOpacity);
            opacityAnimation.toValue = @(0);
            [self.lastBackWaveLayer addAnimation:opacityAnimation forKey:@"opacityBack"];
        }
    }
    
    return YES;
}

#pragma mark --------------------
#pragma mark - RHRefreshControlView

//初始化
- (void)commonSetupOnInit {
    self.imgWaterBackground = [UIImage imageNamed:@"refresh_warter_background"];
    self.imgWaterForeground = [UIImage imageNamed:@"refresh_warter_forground"];
    
    //波纹视图
    self.waveView = ({
        UIView *view = [[UIView alloc] init];
        view.alpha = 0;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1
                                                          constant:REFRESH_CONTROL_VIEW_WAVE_SIZE.width]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1
                                                          constant:REFRESH_CONTROL_VIEW_WAVE_SIZE.height]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
        view;
    });
    
    //maskLayer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, REFRESH_CONTROL_VIEW_WAVE_SIZE.width, REFRESH_CONTROL_VIEW_WAVE_SIZE.height);
    maskLayer.anchorPoint = CGPointMake(0, 0);
    maskLayer.position = CGPointMake(0, 0);
    maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.contentsScale = [UIScreen mainScreen].scale;
    maskLayer.contents = (id)[UIImage imageNamed:@"refresh_warter"].CGImage;
    self.waveView.layer.mask = maskLayer;
    
    //水滴layer
    CALayer *waterLayer = [CALayer layer];
    waterLayer.frame = CGRectMake(0, 0, REFRESH_CONTROL_VIEW_WAVE_SIZE.width, REFRESH_CONTROL_VIEW_WAVE_SIZE.height);
    waterLayer.anchorPoint = CGPointMake(0, 0);
    waterLayer.position = CGPointMake(0, 0);
    waterLayer.contentsGravity = kCAGravityCenter;
    waterLayer.contentsScale = [UIScreen mainScreen].scale;
    waterLayer.contents = (id)[UIImage imageNamed:@"refresh_warter"].CGImage;
    [self.waveView.layer addSublayer:waterLayer];
    
    //前景波浪
    self.foreWaveLayer = ({
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0,
                                 0,
                                 self.imgWaterForeground.size.width,
                                 self.imgWaterForeground.size.height);
        layer.anchorPoint = CGPointMake(0, 0);
        layer.position = CGPointMake(REFRESH_CONTROL_VIEW_WAVE_SIZE.width - self.imgWaterForeground.size.width,
                                     REFRESH_CONTROL_VIEW_WAVE_SIZE.height - self.imgWaterForeground.size.height);
        layer.contentsGravity = kCAGravityCenter;
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.contents = (id)self.imgWaterForeground.CGImage;
        layer.opacity = 0;
        [self.waveView.layer addSublayer:layer];
        layer;
    });
    
    //后面的前景波浪
    self.lastForeWaveLayer = ({
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0,
                                 0,
                                 self.imgWaterForeground.size.width,
                                 self.imgWaterForeground.size.height);
        layer.anchorPoint = CGPointMake(0, 0);
        layer.position = CGPointMake(REFRESH_CONTROL_VIEW_WAVE_SIZE.width - self.imgWaterForeground.size.width * 2,
                                     REFRESH_CONTROL_VIEW_WAVE_SIZE.height - self.imgWaterForeground.size.height);
        layer.contentsGravity = kCAGravityCenter;
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.contents = (id)self.imgWaterForeground.CGImage;
        layer.opacity = 0;
        [self.waveView.layer addSublayer:layer];
        layer;
    });
    
    //后景波浪
    self.backWaveLayer = ({
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0,
                                 0,
                                 self.imgWaterBackground.size.width,
                                 self.imgWaterBackground.size.height);
        layer.anchorPoint = CGPointMake(0, 0);
        layer.position = CGPointMake(REFRESH_CONTROL_VIEW_WAVE_SIZE.width + REFRESH_CONTROL_VIEW_WAVE_FORE_BACK_SEP - self.imgWaterBackground.size.width,
                                     REFRESH_CONTROL_VIEW_WAVE_SIZE.height - self.imgWaterBackground.size.height);
        layer.contentsGravity = kCAGravityCenter;
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.contents = (id)self.imgWaterBackground.CGImage;
        layer.opacity = 0;
        [self.waveView.layer addSublayer:layer];
        layer;
    });
    
    //后面的后景波浪
    self.lastBackWaveLayer = ({
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0,
                                 0,
                                 self.imgWaterBackground.size.width,
                                 self.imgWaterBackground.size.height);
        layer.anchorPoint = CGPointMake(0, 0);
        layer.position = CGPointMake(REFRESH_CONTROL_VIEW_WAVE_SIZE.width + REFRESH_CONTROL_VIEW_WAVE_FORE_BACK_SEP - self.imgWaterBackground.size.width * 2,
                                     REFRESH_CONTROL_VIEW_WAVE_SIZE.height - self.imgWaterBackground.size.height);
        layer.contentsGravity = kCAGravityCenter;
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.contents = (id)self.imgWaterBackground.CGImage;
        layer.opacity = 0;
        [self.waveView.layer addSublayer:layer];
        layer;
    });
}

//完成刷新
- (void)updateViewOnComplete {
    [self stopAnimation:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.waveView.alpha = 0;
        self.waveView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    }];
}

//从（RHRefreshState）state状态到刷新状态
- (void)updateViewOnLoadingStatePreviousState:(NSInteger)state {
    
}

//从（RHRefreshState）state状态到正常状态
- (void)updateViewOnNormalStatePreviousState:(NSInteger)state {
    
}

//从（RHRefreshState）state状态到可以刷新状态（已下拉到临界点）
- (void)updateViewOnPullingStatePreviousState:(NSInteger)state {
    
}

//下拉至刷新零界点的百分比 （RHRefreshState）state当前状态
- (void)updateViewWithPercentage:(CGFloat)percentage state:(NSInteger)state {
//    NSLog(@"%lf", percentage);
    
    if (state == RHRefreshStateNormal) {
        [self stopAnimation: percentage <= 0.1 ? YES : NO];
        if (self.waveView.alpha == 0 && percentage == 1) {
            [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.waveView.alpha = percentage;
                self.waveView.transform = CGAffineTransformScale(CGAffineTransformIdentity, percentage, percentage);
            } completion:nil];
            return;
        }
        self.waveView.alpha = percentage;
        self.waveView.transform = CGAffineTransformScale(CGAffineTransformIdentity, percentage, percentage);
        return;
    }

    if (state == RHRefreshStatePulling) {
        [self startAnimation];
        self.waveView.alpha = 1;
        self.waveView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        return;
    }
    
    if (state == RHRefreshStateLoading) {
        [self startAnimation];
        self.waveView.alpha = 1;
        self.waveView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        return;
    }
    
    
}

#pragma mark ---------------------------
#pragma mark - AnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    if (!_isAnimation) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopAnimation:) object:nil];
        [self performSelector:@selector(stopAnimation:) withObject:@(YES) afterDelay:0.2];
        return;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_isAnimation && self.superview) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimation) object:nil];
        [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.2];
        return;
    }
}

#pragma mark --------------------
#pragma mark - NSNotification

#pragma mark --------------------
#pragma mark - KVO/KVC



@end
