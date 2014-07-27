//
//  MPNavigationView.m
//  Penny
//
//  Created by PETER ZAKIN on 7/26/14.
//  Copyright (c) 2014 com.MJPZ. All rights reserved.
//

#import "MPNavigationView.h"
#import <FrameAccessor/FrameAccessor.h>
#import <DateTools/DateTools.h>

@interface MPNavigationView()
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *budgetLabel;
@property (nonatomic, assign) CGFloat budgetAmount;

@property (nonatomic, weak) UIViewController *delegate;

@end


@implementation MPNavigationView

CGFloat TOP_PADDING_CONTENT = 5;
CGFloat DEFAULT_BUDGET_AMOUNT = 20;

/*
 * Defaults to showing the date for today
 */
- (instancetype)initWithDelegate:(UIViewController<MPDayToggling> *)delegate {
    self = [super init];
    if (self && delegate) {
        self.delegate = delegate;
        self.width = delegate.view.width;
        self.height = 50;
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.dateFormat = @"MMM d";

        self.budgetAmount = DEFAULT_BUDGET_AMOUNT;
        [self updateDisplayForDate:[NSDate date] budgetAmount:self.budgetAmount];
        
#warning add buttons for left and right with associated delegate methods
    }
    return self;
}


//should be called anytime view appears
- (void)updateDisplayForDate:(NSDate *)date budgetAmount:(CGFloat)budgetAmount {
    self.backgroundColor = [UIColor blackColor];
    self.alpha = .2;
    self.date = date;
    [self displayDateLabel];
    [self displayBudgetLabel];
}

- (void)displayDateLabel {
    self.dateLabel = [UILabel new];
    self.dateLabel.font = [UIFont fontWithName:@"helvetica" size:14];
    self.dateLabel.textColor = [UIColor blackColor];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.width = self.width;
    self.dateLabel.centerX = self.centerX;
    self.dateLabel.y = TOP_PADDING_CONTENT;
    
    if ([self.date isToday]) {
        self.dateLabel.text = @"Today";
    } else if ([self.date isYesterday]) {
        self.dateLabel.text = @"Yesterday";
    } else if ([self.date isTomorrow]) {
        self.dateLabel.text = @"Tomorrow";
    } else {
        self.dateLabel.text = [self.dateFormatter stringFromDate:self.date];
    }
    
    [self addSubview:self.dateLabel];
}

- (void)displayBudgetLabel {
    self.budgetLabel = [UILabel new];
    self.budgetLabel.font = [UIFont fontWithName:@"helvetica" size:12];
    self.budgetLabel.textColor = [UIColor blackColor];
    self.budgetLabel.textAlignment = NSTextAlignmentCenter;
    self.budgetLabel.width = self.width;
    self.budgetLabel.centerX = self.centerX;
    self.budgetLabel.y = self.dateLabel.y + 5;
    
    self.budgetLabel.text = [NSString stringWithFormat:@"$%f", self.budgetAmount];
}

@end
