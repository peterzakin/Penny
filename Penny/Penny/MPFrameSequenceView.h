//
//  MPStorySequenceView.h
//  Once
//
//  Created by Minqi on 7/24/14.
//  Copyright (c) 2014 MJPZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPFrameSequenceViewDelegate <NSObject>

// get width of each frame
- (CGFloat)viewFrameWidth;

// num frames
- (NSUInteger)numViewFrames;

// get padding
- (CGFloat)paddingBetweenViewFrames;

// get frame view for index (frames are reused)
- (UIView *)viewFrameForIndex:(NSUInteger)index;

// prepare the frame with content for a given index
- (void)willDisplayViewFrame:(UIView*)viewFrame forIndex:(NSUInteger)index;

@end


@interface MPFrameSequenceView : UIScrollView <UIScrollViewDelegate>

@property(nonatomic, strong) NSArray *stories;
@property(nonatomic, weak) id<MPFrameSequenceViewDelegate> framesDelegate;

- (id)initWithFrame:(CGRect)frame framesDelegate:(id<MPFrameSequenceViewDelegate>)framesDelegate;

- (UIView *)dequeueNextUnusedViewFrame;

@end
