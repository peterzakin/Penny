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
#import <FrameAccessor/FrameAccessor.h>


@interface MPDayViewController ()

@property(nonatomic, strong) MPNavigationView *navigationView;
@property(nonatomic, strong) MPFrameSequenceView *frameSequenceView;

@end


@implementation MPDayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)moveToPreviousDay
{
    // TODO
}

- (void)moveToNextDay
{
    // TODO
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


@end
