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
#import "MPDayRecord+MP.h"

@interface MPNavigationView()
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *budgetLabel;
@property (nonatomic, assign) CGFloat budgetAmount;

@property (nonatomic, weak) UIViewController<MPDayToggling> *delegate;

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
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.dateFormat = @"MMM d";
        self.budgetAmount = DEFAULT_BUDGET_AMOUNT;
        
        //display
        [self updateDisplayForDate:[NSDate date] budgetAmount:self.budgetAmount];
    }
    return self;
}

- (void)updateDisplayForRecord:(MPDayRecord *)dayRecord {
    CGFloat budgetAmount = [dayRecord.budgetAmount floatValue];
    [self updateDisplayForDate:dayRecord.date budgetAmount:budgetAmount];
}


//should be called anytime view appears
- (void)updateDisplayForDate:(NSDate *)date budgetAmount:(CGFloat)budgetAmount {
    UIColor *color = [[UIColor greenColor] colorWithAlphaComponent:.6];
    self.backgroundColor = color;
    self.date = date;
    [self displayDateLabel];
    [self displayBudgetLabel];
    self.height = self.dateLabel.height + self.budgetLabel.height + 20;
    //needs to be done after the superviews height is set up
    [self addToggleButtons];
}

- (void)displayDateLabel {
    self.dateLabel = [UILabel new];
    self.dateLabel.font = [UIFont fontWithName:@"helvetica" size:18];
    self.dateLabel.textColor = [UIColor blackColor];
    self.dateLabel.numberOfLines = 0;
    
    if ([self.date isToday]) {
        self.dateLabel.text = @"Today";
    } else if ([self.date isYesterday]) {
        self.dateLabel.text = @"Yesterday";
    } else if ([self.date isTomorrow]) {
        self.dateLabel.text = @"Tomorrow";
    } else {
        self.dateLabel.text = [self.dateFormatter stringFromDate:self.date];
    }
    [self.dateLabel sizeToFit];
    self.dateLabel.centerX = self.centerX;
    self.dateLabel.y = TOP_PADDING_CONTENT;

    [self addSubview:self.dateLabel];
}

- (void)displayBudgetLabel {
    self.budgetLabel = [UILabel new];
    self.budgetLabel.font = [UIFont fontWithName:@"helvetica" size:12];
    self.budgetLabel.textColor = [UIColor blackColor];
    self.budgetLabel.textAlignment = NSTextAlignmentCenter;

    self.budgetLabel.y = self.dateLabel.y + self.dateLabel.height + 5;
    
    self.budgetLabel.text = [NSString stringWithFormat:@"Budget: $%.02f", self.budgetAmount];
    [self.budgetLabel sizeToFit];
    self.budgetLabel.centerX = self.centerX;
    
    [self addSubview:self.budgetLabel];
}

- (void)addToggleButtons {
    if ([self.delegate canMoveToNextDay]) {
        UIImage *forwardImage = [UIImage imageNamed:@"forward-icon"];
        UIButton *forwardButton = [UIButton new];
        [forwardButton setImage:forwardImage forState:UIControlStateNormal];
        [forwardButton addTarget:self action:@selector(moveToNextDay) forControlEvents:UIControlEventTouchUpInside];
        forwardButton.width = 40;
        forwardButton.height = 30;
        forwardButton.x = self.width - forwardButton.width - 10;
        forwardButton.centerY = self.centerY;
        [self addSubview:forwardButton];
    }

    if ([self.delegate canMoveToPreviousDay]) {
        UIImage *backImage = [UIImage imageNamed:@"back-icon"];
        UIButton *backButton = [UIButton new];
        [backButton setImage:backImage forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(moveToPreviousDay) forControlEvents:UIControlEventTouchUpInside];
        backButton.width = 40;
        backButton.height = 30;
        backButton.x = 10;
        backButton.centerY = self.centerY;
        [self addSubview:backButton];
    }

}

- (void)moveToPreviousDay {
    [self.delegate moveToPreviousDay];
}

- (void)moveToNextDay {
    [self.delegate moveToNextDay];
}

@end
