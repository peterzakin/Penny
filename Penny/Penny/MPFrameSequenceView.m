//
//  MPStorySequenceView.m
//  Once
//
//  Created by Minqi on 7/24/14.
//  Copyright (c) 2014 MJPZ. All rights reserved.
//

#import "MPFrameSequenceView.h"
#import <FrameAccessor/FrameAccessor.h>
#import <math.h>

static const CGFloat TRANSLATION_SCALE = 0.5;
static const CGFloat DEFAULT_CONTENT_WIDTH = 1600;


@interface MPFrameSequenceView ()

@property(nonatomic, strong) NSMutableArray *visibleViewFrames;
@property(nonatomic, strong) UIView *viewFrameContainerView;

@property(nonatomic, strong) NSMutableArray *unusedViewFrames;

@property(nonatomic) CGFloat viewFrameWidth;

@property(nonatomic) NSUInteger rightMostSequenceIndex;
@property(nonatomic) NSUInteger leftMostSequenceIndex;

@end


@implementation MPFrameSequenceView

- (id)initWithFrame:(CGRect)frame framesDelegate:(id<MPFrameSequenceViewDelegate>)framesDelegate
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.delegate = self;
        self.framesDelegate = framesDelegate;
        
        self.contentSize = CGSizeMake(DEFAULT_CONTENT_WIDTH, self.height);
        self.viewFrameWidth = [self.framesDelegate viewFrameWidth];
        
        
        self.unusedViewFrames = [[NSMutableArray alloc] init];
        self.visibleViewFrames = [[NSMutableArray alloc] init];
        self.viewFrameContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.height)];
        [self addSubview:self.viewFrameContainerView];
        
        self.viewFrameContainerView.backgroundColor = [UIColor blackColor];
        self.viewFrameContainerView.userInteractionEnabled = YES;
        
        self.rightMostSequenceIndex = 0;
        self.leftMostSequenceIndex = 0;
        
        self.showsHorizontalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    
    return self;
}


# pragma mark -  View-frame reuse management
- (UIView *)dequeueNextUnusedViewFrame
{
    if ([self.unusedViewFrames count] > 0) {
        // return first unused view frame and dequeue from unused view frame array
        UIView *viewFrame = self.unusedViewFrames[0];
        [self.unusedViewFrames removeObjectAtIndex:0];
        
        return viewFrame;
    }
    else return nil;
}

# pragma mark - View-frame index management

// increase / decrease right-most visible sequence index by 1
- (NSUInteger)incrementRightMostVisibleSequenceIndex
{
    NSUInteger index = (self.rightMostSequenceIndex + 1) % [self.framesDelegate numViewFrames];
    self.rightMostSequenceIndex = index;
    
    return index;
}

- (NSUInteger)decrementRightMostVisibleSequenceIndex
{
    NSInteger index = self.rightMostSequenceIndex;
    index = (index == 0) ? [self.framesDelegate numViewFrames] - 1 : index - 1;
    self.rightMostSequenceIndex = index;
    
    return index;
}

// increase / decrease left-most visible sequence index by 1
- (NSUInteger)incrementLeftMostVisibleSequenceIndex
{
    NSUInteger index = (self.leftMostSequenceIndex + 1) % [self.framesDelegate numViewFrames];
    self.leftMostSequenceIndex = index;
    
    return index;
}

- (NSUInteger)decrementLeftMostVisibleSequenceIndex
{
    NSInteger index = self.leftMostSequenceIndex;
    index = (index == 0) ? [self.framesDelegate numViewFrames] - 1 : index - 1;
    self.leftMostSequenceIndex = index;
    
    return index;
}


# pragma mark - Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary
{
    CGPoint currentOffset = self.contentOffset;
    CGFloat contentWidth = self.contentSize.width;
    CGFloat centerOffsetX = (contentWidth - self.bounds.size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter > (contentWidth / 4.0))
    {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        // move content by the same amount so it appears to stay still
        for (UIView *viewFrame in self.visibleViewFrames) {
            CGPoint center = [self.viewFrameContainerView convertPoint:viewFrame.center toView:self];
            center.x += (centerOffsetX - currentOffset.x);
            viewFrame.center = [self convertPoint:center toView:self.viewFrameContainerView];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self recenterIfNecessary];
    
    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:self.bounds toView:self.viewFrameContainerView];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    
    [self tileViewFramesFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
    
    //    [self updateViewFrameSizes];
}

#pragma mark - View frame tiling

- (UIView *)insertViewFrameForSequenceIndex:(NSUInteger)index;
{
    //  ask delegate for view frame for a given index
    UIView *viewFrame = [self.framesDelegate viewFrameForIndex:index];
    
    //  ask delegate to configure the view frame for display
    [self.framesDelegate willDisplayViewFrame:viewFrame forIndex:index];
    
    // add frame to screen
    [self.viewFrameContainerView addSubview:viewFrame];
    
    return viewFrame;
}

- (CGFloat)placeNewViewFrameOnRight:(CGFloat)rightEdge
{
    // get sequence index of right-most frame
    UIView *viewFrame = [self insertViewFrameForSequenceIndex:self.rightMostSequenceIndex];
    
    [self.visibleViewFrames addObject:viewFrame]; // add rightmost view frame at the end of the array
    
    CGRect frame = [viewFrame frame];
    frame.origin.x = rightEdge;
    viewFrame.frame = frame;
    
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewViewFrameOnLeft:(CGFloat)leftEdge
{
    // get sequence index of left-most frame
    UIView *viewFrame = [self insertViewFrameForSequenceIndex:self.leftMostSequenceIndex];
    
    [self.visibleViewFrames insertObject:viewFrame atIndex:0]; // add leftmost view frame at the beginning of the array
    
    CGRect frame = [viewFrame frame];
    frame.origin.x = leftEdge - frame.size.width;
    viewFrame.frame = frame;
    
    return CGRectGetMinX(frame);
}

- (void)tileViewFramesFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    // the upcoming tiling logic depends on there already being at least one view frame in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([self.visibleViewFrames count] == 0)
    {
        self.rightMostSequenceIndex = 0;
        self.leftMostSequenceIndex = 0;
        [self placeNewViewFrameOnRight:minimumVisibleX];
    }
    
    // add view frames that are missing on right side
    UIView *lastViewFrame = [self.visibleViewFrames lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastViewFrame frame]);
    while (rightEdge < maximumVisibleX)
    {
        [self incrementRightMostVisibleSequenceIndex];
        rightEdge = [self placeNewViewFrameOnRight:rightEdge];
    }
    
    // add view frames that are missing on left side
    UIView *firstViewFrame = self.visibleViewFrames[0];
    CGFloat leftEdge = CGRectGetMinX([firstViewFrame frame]);
    while (leftEdge > minimumVisibleX)
    {
        [self decrementLeftMostVisibleSequenceIndex];
        leftEdge = [self placeNewViewFrameOnLeft:leftEdge];
    }
    
    // remove view frames that have fallen off right edge and add them to unused view frames
    lastViewFrame = [self.visibleViewFrames lastObject];
    while ([lastViewFrame frame].origin.x > maximumVisibleX)
    {
        [self decrementRightMostVisibleSequenceIndex];
        [lastViewFrame removeFromSuperview];
        [self.unusedViewFrames addObject:lastViewFrame];
        [self.visibleViewFrames removeLastObject];
        lastViewFrame = [self.visibleViewFrames lastObject];
    }
    
    // remove view frames that have fallen off left edge and add them to unused view frames
    firstViewFrame = self.visibleViewFrames[0];
    while (CGRectGetMaxX([firstViewFrame frame]) < minimumVisibleX)
    {
        [self incrementLeftMostVisibleSequenceIndex];
        [firstViewFrame removeFromSuperview];
        [self.unusedViewFrames addObject:firstViewFrame];
        [self.visibleViewFrames removeObjectAtIndex:0];
        firstViewFrame = self.visibleViewFrames[0];
    }
}


# pragma mark - UIScrollViewDelegate protocol

// always end scroll at nearest frame boundary
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint currentOffset = scrollView.contentOffset;
    
    CGRect visibleBounds = [self convertRect:self.bounds toView:self.viewFrameContainerView];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    UIView *firstViewFrame = self.visibleViewFrames[0];
    
    // maximum delta offset from current offset for this swipe
    CGFloat deltaOffset = targetContentOffset->x - currentOffset.x;
    CGFloat firstVisibleRightEdgeX = firstViewFrame.origin.x + firstViewFrame.width;
    
    CGFloat deltaLeftward = firstVisibleRightEdgeX - minimumVisibleX;
    CGFloat deltaRightward = maximumVisibleX - firstVisibleRightEdgeX;
    
    // swipe left if
    // - right edge of first view frame will not go beyond max visible x
    // - right edge of first view frame will go beyond min visible x
    // -- or delta left is smaller than delta right
    BOOL isLeftward = ( ((firstVisibleRightEdgeX - deltaOffset <= minimumVisibleX) || (deltaLeftward <= deltaRightward) )
                       && !(firstVisibleRightEdgeX - deltaOffset >= maximumVisibleX) );
    
    // swipe left instead if
    // - velocity x is positive
    isLeftward = (velocity.x > 0) ? YES : isLeftward;
    
    // swipe right instead if
    // - velocity x is negative
    isLeftward = (velocity.x < 0) ? NO : isLeftward;
    
    CGFloat delta = isLeftward ? deltaLeftward : -deltaRightward;
    
    
    targetContentOffset->x = currentOffset.x + delta;
}

// TODO: redo based on state
- (void)updateViewFrameSizes
{
    if (!self.visibleViewFrames || [self.visibleViewFrames count] == 0)
        return;
    
    CGRect visibleBounds = [self convertRect:self.bounds toView:self.viewFrameContainerView];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    CGFloat middleVisibleX = (minimumVisibleX + maximumVisibleX)/2.0;
    UIView *firstViewFrame = self.visibleViewFrames[0];
    
    CGFloat firstVisibleLeftEdgeX = firstViewFrame.origin.x;
    CGFloat x = minimumVisibleX - 2*firstVisibleLeftEdgeX + middleVisibleX;
    
    CGFloat heightDelta = CGFLOAT_IS_DOUBLE ? 1.0/exp2(pow((4*x/firstViewFrame.width), 2.0)) : 1.0/exp2f(powf((4*x/firstViewFrame.width), 2.0));
    if (firstVisibleLeftEdgeX <= minimumVisibleX - firstViewFrame.width) heightDelta = 0;
    
    CGFloat maxHeightDelta = firstViewFrame.height - TRANSLATION_SCALE*firstViewFrame.height;
    CGFloat scale = (firstViewFrame.height - maxHeightDelta*heightDelta)/firstViewFrame.height;
    NSLog(@"scale = %f", scale);
    
    for (UIView *viewFrame in self.visibleViewFrames) {
        // scale viewFrame
        viewFrame.frame = CGRectMake(viewFrame.origin.x - (1-scale)*320,
                                     viewFrame.origin.y,
                                     scale*320,
                                     scale*320);
        viewFrame.center = CGPointMake(viewFrame.centerX, self.viewFrameContainerView.height/2.0);
        NSLog(@"rect = %f, %f, %f, %f", viewFrame.frame.origin.x, viewFrame.frame.origin.y, viewFrame.width, viewFrame.height);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

@end
