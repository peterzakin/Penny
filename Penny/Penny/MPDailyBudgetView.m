//
//  MPDailyBudgetView.m
//  Penny
//
//  Created by Minqi on 7/26/14.
//  Copyright (c) 2014 com.MJPZ. All rights reserved.
//

#import "MPDailyBudgetView.h"
#import <FrameAccessor/FrameAccessor.h>

@interface MPDailyBudgetView ()

@property(nonatomic) CGFloat budget;

@property(nonatomic, strong) UIView *amountSpentView;
@property(nonatomic, strong) UIView *amountRemainingView;

@property(nonatomic, strong) UITextView *amountSpentTextView;
@property(nonatomic, strong) UITextView *amountRemainingTextView;

@end

@implementation MPDailyBudgetView

- (id)initWithFrame:(CGRect)frame budget:(CGFloat)budget
{
    self = [super initWithFrame:frame];
    if (self) {
        // set budget
        self.budget = budget;
        
        // add amount remaining area
        self.amountRemainingView = [[UIView alloc] initWithFrame:frame];
        self.amountRemainingView.origin = CGPointZero;
        self.amountRemainingView.backgroundColor = [UIColor colorWithRed:111/255.0 green:214/255.0 blue:123/255.0 alpha:1.0];
        [self addSubview:self.amountRemainingView];
        
        // add amount remaining textview value
        self.amountRemainingTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.amountRemainingTextView.textAlignment = NSTextAlignmentCenter;
        self.amountRemainingTextView.width = self.width;
        self.amountRemainingTextView.editable = NO;
        self.amountRemainingTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.amountRemainingTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:36.0f];
        self.amountRemainingTextView.textColor = [UIColor whiteColor];
        self.amountRemainingTextView.backgroundColor = [UIColor clearColor];
        [self updateAmountRemainingTextView:self.budget];
        [self.amountRemainingView addSubview:self.amountRemainingTextView];
        
        // add amount spent area
        self.amountSpentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
        self.amountSpentView.origin = CGPointZero;
        self.amountSpentView.backgroundColor = [UIColor colorWithRed:237/255.0 green:91/255.0 blue:81/255.0 alpha:1.0];
        [self addSubview:self.amountSpentView];
        
        // add amount spent textview value
        self.amountSpentTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.amountSpentTextView.textAlignment = NSTextAlignmentCenter;
        self.amountSpentTextView.width = self.width;
        self.amountSpentTextView.editable = NO;
        self.amountSpentTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.amountSpentTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:36.0f];
        self.amountSpentTextView.textColor = [UIColor whiteColor];
        self.amountSpentTextView.backgroundColor = [UIColor clearColor];
        [self updateAmountSpentTextView:0.00];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panRecognizer];
        panRecognizer.delegate = self;
        
        self.userInteractionEnabled = YES;
        
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return self;
}

# pragma mark - Helpers

- (void)updateAmountRemainingTextView:(CGFloat)amount
{
    self.amountRemainingTextView.text = [NSString stringWithFormat:@"$%.02f", amount];
    self.amountRemainingTextView.height = [self.amountRemainingTextView sizeThatFits:CGSizeMake(self.amountRemainingTextView.width, CGFLOAT_MAX)].height;
    CGSize amountRemainingAreaSize = self.amountRemainingView.size;
    self.amountRemainingTextView.center = CGPointMake(amountRemainingAreaSize.width/2.0, amountRemainingAreaSize.height/2.0);

    // check if textview fits inside area
    if (self.amountRemainingTextView.height < self.amountRemainingView.size.height) {
        if (!self.amountRemainingTextView.superview)
            [self.amountRemainingView addSubview:self.amountRemainingTextView];
    }
    else {
        [self.amountRemainingTextView removeFromSuperview];
    }
}

- (void)updateAmountSpentTextView:(CGFloat)amount
{
    self.amountSpentTextView.text = [NSString stringWithFormat:@"$%.02f", amount];
    self.amountSpentTextView.height = [self.amountSpentTextView sizeThatFits:CGSizeMake(self.amountSpentTextView.width, CGFLOAT_MAX)].height;
    CGSize amountSpentAreaSize = self.amountSpentView.size;
    self.amountSpentTextView.center = CGPointMake(amountSpentAreaSize.width/2.0, amountSpentAreaSize.height/2.0);
    
    // check if textview fits inside area
    if (self.amountSpentTextView.height < self.amountSpentView.size.height) {
        if (!self.amountSpentTextView.superview)
            [self.amountSpentView addSubview:self.amountSpentTextView];
    }
    else {
        [self.amountSpentTextView removeFromSuperview];
    }
}

# pragma mark - Gesture callbacks

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    static CGFloat previousTranslationY = 0;
    
    CGPoint translationPoint = [gesture translationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        previousTranslationY = translationPoint.y;
    }
    
    CGPoint translation = CGPointZero;
    translation.y = translationPoint.y - previousTranslationY;
    previousTranslationY = translationPoint.y;
    
    CGPoint velocity = [gesture velocityInView:self];
    
    BOOL isPanDown = velocity.y > 0; // maybe don't need this bit of info
    
    // update amount spent area
    CGRect amountSpentFrame = self.amountSpentView.frame;
    NSLog(@"translation y = %f", translation.y);
    amountSpentFrame.size.height += translation.y;
    amountSpentFrame.size.height = MAX(amountSpentFrame.size.height, 0);
    amountSpentFrame.size.height = MIN(amountSpentFrame.size.height, self.height);
    self.amountSpentView.frame = amountSpentFrame;
    
    // update amount spent textview value
    CGFloat percentSpent = (self.amountSpentView.height/self.height);
    CGFloat amountSpent = percentSpent*self.budget;
    [self updateAmountSpentTextView:amountSpent];
    
    // update amount remaining area
    CGRect amountRemainingFrame = self.amountRemainingView.frame;
    amountRemainingFrame.size.height -= translation.y;
    amountRemainingFrame.size.height = MAX(amountRemainingFrame.size.height, 0);
    amountRemainingFrame.size.height = MIN(amountRemainingFrame.size.height, self.height);
    amountRemainingFrame.origin = CGPointMake(0, CGRectGetMaxY(amountSpentFrame));
    self.amountRemainingView.frame = amountRemainingFrame;
    
    // update amount remaining textview value
    CGFloat amountRemaining = self.budget - amountSpent;
    [self updateAmountRemainingTextView:amountRemaining];
}

#pragma mark - UIGestureRecognizerDelegate protocol

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
