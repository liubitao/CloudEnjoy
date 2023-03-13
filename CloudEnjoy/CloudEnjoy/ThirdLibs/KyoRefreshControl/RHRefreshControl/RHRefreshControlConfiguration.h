//
//  RHRefreshControlConfiguration.h
//  Example
//
//  Created by Ratha Hin on 2/2/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHRefreshControlView.h"

typedef NS_ENUM(NSInteger, RHRefreshViewStyle) {
    RHRefreshViewStylePinterest,
    RHRefreshViewStyleJMWave
};

@protocol RHRefreshControlView;

@interface RHRefreshControlConfiguration : NSObject

@property (nonatomic, strong) UIView<RHRefreshControlView> *refreshView; //UIView
@property (assign, nonatomic) RHRefreshViewStyle style;
@property (nonatomic, strong) NSNumber *minimumForStart;
@property (nonatomic, strong) NSNumber *maximumForPull;

@end
