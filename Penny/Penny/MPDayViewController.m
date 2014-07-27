//
//  MPDayViewController.m
//  Penny
//
//  Created by Minqi on 7/26/14.
//  Copyright (c) 2014 com.MJPZ. All rights reserved.
//

#import "MPDayViewController.h"
#import "MPNavigationView.h"
#import "MPFrameSequenceView.h"
#import "MPDayRecord+MP.h"
#import <FrameAccessor/FrameAccessor.h>


@interface MPDayViewController ()

@property (nonatomic, strong) MPNavigationView *navigationView;
@property (nonatomic, strong) MPFrameSequenceView *frameSequenceView;
@property (nonatomic, strong) NSArray *dayRecords;
@property (nonatomic, strong) MPDayRecord *currentDay;

@end


@implementation MPDayViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dayRecords = [MPDayRecord loadAllRecords];
        self.currentDay = [self.dayRecords firstObject];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationView = [[MPNavigationView alloc] initWithDelegate:self];
    [self.view addSubview:self.navigationView];
    
    CGRect frameSequenceRect = CGRectMake(0, self.navigationView.height,
                                          self.view.width, self.view.height - self.navigationView.height);
    
    self.frameSequenceView = [[MPFrameSequenceView alloc] initWithFrame:frameSequenceRect framesDelegate:self];
}


# pragma mark - MPDayToggling protocol
- (BOOL)canMoveToNextDay {
    //assume that the records are ordered correctly
    //NO if it is not found or if it is the 0th element
    NSInteger currentIndex = [self.dayRecords indexOfObject:self.currentDay];
    if (currentIndex != NSNotFound && currentIndex > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)canMoveToPreviousDay {
    NSInteger index = [self.dayRecords indexOfObject:self.currentDay];
    if (index == NSNotFound) {
        return NO;
    }
    
    if ((index + 1) < [self.dayRecords count]) {
        return YES;
    }
    
    return NO;
}

- (void)moveToPreviousDay
{
    // TODO
    if ([self canMoveToPreviousDay]) {
        //adjust currentDay
        NSInteger currentIndex = [self.dayRecords indexOfObject:self.currentDay];
        self.currentDay = [self.dayRecords objectAtIndex:currentIndex+1];
        //reload views based on new model object
    }
}

- (void)moveToNextDay
{
    if ([self canMoveToNextDay]) {
        //adjust currentDay
        NSInteger currentIndex = [self.dayRecords indexOfObject:self.currentDay];
        self.currentDay = [self.dayRecords objectAtIndex:currentIndex-1];
        //reload views based on new model object
    }
}


# pragma mark - MPFrameSequenceViewDelegate protocol

// get width of each frame
- (CGFloat)viewFrameWidth
{
    // TODO
    return 0;
}

// num frames
- (NSUInteger)numViewFrames
{
    // TODO
    return 1;
}

// get padding
- (CGFloat)paddingBetweenViewFrames
{
    // TODO
    return 0;
}

// get frame view for index (frames are reused)
- (UIView *)viewFrameForIndex:(NSUInteger)index
{
    // TODO
    return nil;
}

// prepare the frame with content for a given index
- (void)willDisplayViewFrame:(UIView*)viewFrame forIndex:(NSUInteger)index
{
    // TODO
    return;
}

#pragma mark -
- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
