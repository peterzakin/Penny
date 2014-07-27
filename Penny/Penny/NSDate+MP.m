//
//  NSDate+MP.m
//  Penny
//
//  Created by PETER ZAKIN on 7/26/14.
//  Copyright (c) 2014 com.MJPZ. All rights reserved.
//

#import "NSDate+MP.h"
#import <DateTools/DateTools.h>

@implementation NSDate (MP)

- (NSDate *)beginningOfDay {
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.year = self.year;
    dateComponents.month = self.month;
    dateComponents.day = self.day;
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDate *beginningOfDay = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    return beginningOfDay;
}


@end
