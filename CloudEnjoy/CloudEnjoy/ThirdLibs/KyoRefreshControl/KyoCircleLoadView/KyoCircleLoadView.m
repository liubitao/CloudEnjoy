//
//  KyoCircleLoadView.m
//  testabcd
//
//  Created by Kyo on 4/4/19.
//  Copyright © 2019 liyu. All rights reserved.
//

#import "KyoCircleLoadView.h"

static CGFloat const LoadingDefaultProgress = 0.8;  //loading时的progress

@interface KyoCircleLoadView()

@property (strong, nonatomic) CAShapeLayer *loadingLayer;

- (void)setupDefault;
- (void)setupView;
- (void)setupData;

@end

@implementation KyoCircleLoadView

#pragma mark --------------------
#pragma mark - CycLife

- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    [self setupDefault];
    [self setupView];
    [self setupData];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    
    [self setupDefault];
    [self setupView];
    [self setupData];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self == nil) {
        return nil;
    }
    
    [self setupDefault];
    [self setupView];
    [self setupData];
    
    return self;
}

- (void)dealloc {
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.loadingLayer removeAllAnimations];
}

- (void)setupDefault {
    _enable = YES;
    _circleColor = [UIColor redColor];
    _circleWidth = 2.0f;
}

- (void)setupView {
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.frame = self.bounds;
    circle.contentsGravity = kCAGravityCenter;
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:circle.position
                                                              radius:CGRectGetMidX(circle.bounds)
                                                          startAngle:0
                                                            endAngle:(360) / 180.0 * M_PI
                                                           clockwise:NO];
    circle.path = circlePath.CGPath;
    
    circle.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));    //设置动画圆圈坐标
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = self.circleColor.CGColor;
    circle.lineWidth = self.circleWidth;
    circle.strokeEnd = 0.0f;
    circle.opacity = 1.0f;
    [[self layer] addSublayer:circle];
    self.loadingLayer = circle;
}

- (void)setupData {
    
}

#pragma mark --------------------
#pragma mark - Settings, Gettings

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress withAnimation:NO];
}

- (void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    
    self.loadingLayer.strokeColor = [_circleColor CGColor];
}

- (void)setCircleWidth:(CGFloat)circleWidth {
    _circleWidth = circleWidth;
    
    self.loadingLayer.lineWidth = circleWidth;
}

#pragma mark --------------------
#pragma mark - Events

#pragma mark --------------------
#pragma mark - Methods

/**< 进度是否满了 */
- (BOOL)progressFull {
    return [KyoCircleLoadView progressFullWithProgress:_progress];
}

/**< 判断指定进度是否满了 */
+ (BOOL)progressFullWithProgress:(CGFloat)progress {
        return progress == 1;
}

/**< 设置进度，是否动画显示 */
- (void)setProgress:(CGFloat)progress withAnimation:(BOOL)animation {
    if (self.enable == NO) return;
    
    _progress = MIN(MAX(progress, 0), 1);   //0-1之间
    
    [CATransaction begin];
    [CATransaction setDisableActions:!animation];
    
    self.loadingLayer.strokeEnd = self.progress;
    
    [CATransaction commit];
}

- (void)showLoading {
    if (_enable == NO) return;
    
    if (_isLoading) {
        return;
    }
    
    _isLoading = YES;
    self.loadingLayer.frame = self.bounds;
    [self setProgress:LoadingDefaultProgress withAnimation:YES];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1;
    animation.repeatCount = INFINITY;
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:(360) / 180.0 * M_PI]; // 终止角度
    animation.removedOnCompletion = NO;
    [self.loadingLayer addAnimation:animation forKey:@"rotate"];
}

- (void)hideLoading {
    if (!_isLoading) {
        return;
    }
    
    _isLoading = NO;
    [self setProgress:0 withAnimation:YES];
    [self.loadingLayer removeAllAnimations];
}

#pragma mark --------------------
#pragma mark - Delegate

#pragma mark --------------------
#pragma mark - NSNotification

#pragma mark --------------------
#pragma mark - KVO/KVC



@end
