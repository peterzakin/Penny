//
//  MPNavigationView.h
//  Penny
//
//  Created by PETER ZAKIN on 7/26/14.
//  Copyright (c) 2014 com.MJPZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPNavigationView : UIView

- (void)updateDisplayForDate:(NSDate *)date budgetAmount:(CGFloat)budgetAmount;

@end

@protocol MPDayToggling <NSObject>

- (void)moveToPreviousDay;
- (void)moveToFollowingDay;

@end
