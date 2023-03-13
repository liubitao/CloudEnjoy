//
//  KyoRefreshControl.h
//  YWCat
//
//  Created by Kyo on 4/25/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KyoDataTipsView.h"
#import "RHRefreshControl.h"


#define kKyoRefreshControlErrorMsgDefault @"抱歉！当前没有数据"
#define KYOPAGESIZE 30
#define KYOLOADMORECONTROL_NUMBER_OF_PAGES(_total,_rowsAPage)   ((_total + _rowsAPage - 1) / _rowsAPage)

typedef enum : NSInteger {
    KyoDataTipsViewTypeNone = 0,    //什么鸟也没有
    KyoDataTipsViewTypeNoDataNoWifi = 1,    //当前没数据没wifi
    KyoDataTipsViewTypeNoDataHadNetworkError = 2,  //当前没数据且网络请求失败
    KyoDataTipsViewTypeNoDataHadError = 3,  //当前没数据且服务器返回错误
    KyoDataTipsViewTypeNoDataNoError = 4  //当前没数据且服务器返回真的没数据
} KyoDataTipsViewType;

/**< 手动刷新类型 */
typedef NS_ENUM(NSInteger, KyoManualRefreshType) {
    KyoManualRefreshTypeDefault = 0,    /**< 默认，头部刷新 */
    KyoManualRefreshTypeCenter = 1,  /**< 中间视图刷新 */
};

@protocol KyoRefreshControlDelegate;

@interface KyoRefreshControl : NSObject

@property (nonatomic, weak) id<KyoRefreshControlDelegate> kyoRefreshControlDelegate;
@property (nonatomic, assign) NSInteger numberOfPage;   //总共能加载几页
@property (nonatomic, assign) NSInteger currentPage;   //当前加载到第几页
@property (assign, nonatomic) NSTimeInterval delayLoadFinished; /**< 调用加载完成延迟执行的时间，默认为0.2(中央刷新不生效) */
@property (assign, nonatomic) NSTimeInterval delayRefresh; /**< 调用刷新完成延迟执行的时间，默认为0.5 */
@property (assign, nonatomic) UIEdgeInsets tableViewDefaultInsets;   //tableview默认的insets
@property (assign, nonatomic) CGFloat yOffset;  /**< tipsview的y偏移量 */
@property (assign, nonatomic) CGFloat refreshViewOffsetY;   /**< refreshView的y轴偏移量 */
@property (assign, nonatomic) CGFloat centerRefreshOffsetY; /**< centerRefresh的中央y轴偏移量 */


@property (nonatomic, readonly) BOOL isLoading; //是否正在刷新
@property (assign, nonatomic) BOOL isHadLoaded; //是否有过刷新
@property (assign, nonatomic, readonly) BOOL isLoadMoreing;  //是否正在加载更多
@property (assign, nonatomic, readonly) BOOL isOperationing;    //是否正在执行刷新或加载更多

@property (strong, nonatomic) NSError *error;   /**< 网络请求失败的错误（网络连接失败或请求成功但服务器返回错误信息） */
@property (assign, nonatomic) BOOL isShowErrorMsg;  //是否显示了错误提示框

@property (assign, nonatomic) BOOL isEnableRefresh; //是否可以使用刷新，默认yes
//@property (assign, nonatomic) BOOL isEnableLoadMore; //是否可以使用加载更多，默认yes

- (instancetype)initWithScrollView:(UIScrollView *)scrollView withDelegate:(id<KyoRefreshControlDelegate>)delegate;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView withDelegate:(id<KyoRefreshControlDelegate>)delegate withIsCanShowNoMore:(BOOL)isCanShowNoMore;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView withDelegate:(id<KyoRefreshControlDelegate>)delegate withIsCanShowNoMore:(BOOL)isCanShowNoMore withKyoRefreshDisplayType:(KyoRefreshDisplayType)type;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView withDelegate:(id<KyoRefreshControlDelegate>)delegate withIsCanShowNoMore:(BOOL)isCanShowNoMore withKyoRefreshDisplayType:(KyoRefreshDisplayType)type withRHRefreshViewStyle:(RHRefreshViewStyle)style;

//- (void)kyoRefreshOperationWithRefreshDisplayType:(RefreshDisplayType)refreshDisplayType;   //手动刷新，根据类型显示刷新样式
- (void)kyoRefreshOperation;   //手动刷新
- (void)kyoRefreshOperationWithDelay:(NSTimeInterval)delay; /**< 延迟delay时间后手动刷新 */
- (void)kyoRefreshOperationWithDelay:(NSTimeInterval)delay withType:(KyoManualRefreshType)type; /**< 延迟delay时间后手动刷新，配置刷新类型（头部或中间视图刷新） */
- (void)kyoRefreshScrollViewDataSourceDidFinishedLoadingWithAnimation:(BOOL)isAnimation;   //刷新完成，是否带动画
- (void)kyoRefreshLoadMore; //加载完成，成功获失败自动判断（通过设置numberofpage就当作加载成功）
- (void)kyoRefreshLoadMoreFinished:(BOOL)isSuccess; //加载完成，是否加载成功
- (void)kyoReset;   //重置
- (void)kyoRefreshDoneRefreshOrLoadMore:(BOOL)isLoadFristPage withHadData:(BOOL)isHadData withError:(NSError *)error;    //根据传入是否第一页判断和设置刷新或加载完成，根据3个参数判断是否在tableview中显示提示框
- (void)kyoRefreshShowOrHideErrorMessage:(NSError *)error  withHadData:(BOOL)isHadData; //显示或隐藏错误框
- (void)rechangeConfigurationWithFillColor:(UIColor *)fillColor withStrokeColor:(UIColor *)strokeColor withImgContent:(UIImage *)imgContent withActivityIndicatorColor:(UIColor *)activityIndicatorColor;   /**< 重置下拉刷新的样式 */

- (NSString *)currentVersion;   /**< 获得当前版本号 */

@end

@protocol KyoRefreshControlDelegate <NSObject>

@optional
- (void)kyoRefreshDidTriggerRefresh:(KyoRefreshControl *)refreshControl;
- (void)kyoRefreshLoadMore:(KyoRefreshControl *)refreshControl loadPage:(NSInteger)index;
- (KyoDataTipsModel *)kyoRefresh:(KyoRefreshControl *)refreshControl withNoDataShowTipsView:(KyoDataTipsView *)kyoDataTipsView withCurrentKyoDataTipsModel:(KyoDataTipsModel *)kyoDataTipsModel withType:(KyoDataTipsViewType)kyoDataTipsViewType;    /**< 没数据要展示提示view时调用这个委托得到自定义展示数据，如果不想处理的状态返回nil */


@end
