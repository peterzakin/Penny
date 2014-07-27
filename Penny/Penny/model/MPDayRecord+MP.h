//
//  MPDayRecord+MP.h
//  Penny
//
//  Created by PETER ZAKIN on 7/26/14.
//  Copyright (c) 2014 com.MJPZ. All rights reserved.
//

#import "MPDayRecord.h"

@interface MPDayRecord (MP)

+ (NSArray *)loadAllRecords;
+ (MPDayRecord *)updateOrInsertRecordWithDate:(NSDate *)date budgetAmount:(NSNumber *)budgetAmount spentAmount:(NSNumber *)spentAmount;

@end
