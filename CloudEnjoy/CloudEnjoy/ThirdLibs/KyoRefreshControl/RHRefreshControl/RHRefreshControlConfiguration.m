//
//  RHRefreshControlConfiguration.m
//  Example
//
//  Created by Ratha Hin on 2/2/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "RHRefreshControlConfiguration.h"
#import "RHRefreshControlViewPinterest.h"
#import "JMRefreshControlViewWave.h"

static const CGFloat MIN_PULL = 24;

@implementation RHRefreshControlConfiguration

- (void)setStyle:(RHRefreshViewStyle)style {
    _style = style;
    
    switch (style) {
        case RHRefreshViewStylePinterest: {
            _refreshView = [[RHRefreshControlViewPinterest alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
            break;
        }
        case RHRefreshViewStyleJMWave: {
            _refreshView = [[JMRefreshControlViewWave alloc] initWithFrame:CGRectMake(0, 0, 320, 85)];
            break;
        }
        default:
            break;
    }
}

- (NSNumber *)maximumForPull {
  if (!_maximumForPull) {
    return [NSNumber numberWithFloat:_refreshView.frame.size.height];
  }
  
  return _maximumForPull;
}

- (NSNumber *)minimumForStart {
  if (!_minimumForStart) {
    return [NSNumber numberWithFloat:MIN_PULL];
  }
  
  return _minimumForStart;
}

@end
