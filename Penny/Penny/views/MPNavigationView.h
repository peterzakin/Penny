//
//  MPNavigationView.h
//  Penny
//
//  Created by PETER ZAKIN on 7/26/14.
//  Copyright (c) 2014 com.MJPZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPDayToggling <NSObject>

- (void)moveToPreviousDay;
- (void)moveToNextDay;
- (BOOL)canMoveToPreviousDay;
- (BOOL)canMoveToNextDay;

@end

@interface MPNavigationView : UIView

- (instancetype)initWithDelegate:(UIViewController<MPDayToggling> *)delegate;

- (void)updateDisplayForDate:(NSDate *)date budgetAmount:(CGFloat)budgetAmount;

@end

