//
//  KyoCircleLoadView.h
//  testabcd
//
//  Created by Kyo on 4/4/19.
//  Copyright © 2019 liyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KyoCircleLoadView : UIView

@property (assign, nonatomic) CGFloat progress; /**< 圈的进度 0-1 */
@property (strong, nonatomic) UIColor *circleColor; /**< 圈的颜色 */
@property (assign, nonatomic) CGFloat circleWidth;  /**< 圈的宽度 */
@property (readonly, nonatomic) BOOL isLoading; /**< 是否正在loading */
@property (assign, nonatomic) BOOL enable;  /**< 控件是否可用 */

- (void)setProgress:(CGFloat)progress withAnimation:(BOOL)animation;    /**< 设置进度，是否动画显示 */

- (BOOL)progressFull;   /**< 进度是否满了 */
+ (BOOL)progressFullWithProgress:(CGFloat)progress; /**< 判断指定进度是否满了 */
- (void)showLoading;
- (void)hideLoading;

@end
