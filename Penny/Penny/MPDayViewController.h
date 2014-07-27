//
//  MPDayViewController.h
//  Penny
//
//  Created by Minqi on 7/26/14.
//  Copyright (c) 2014 com.MJPZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPFrameSequenceView;
@protocol MPDayToggling, MPFrameSequenceViewDelegate;

@interface MPDayViewController : UIViewController <MPDayToggling, MPFrameSequenceViewDelegate>

@end
