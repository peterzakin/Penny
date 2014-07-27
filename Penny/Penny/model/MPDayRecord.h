//
//  MPDayRecord.h
//  Penny
//
//  Created by PETER ZAKIN on 7/26/14.
//  Copyright (c) 2014 com.MJPZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MPDayRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * budgetAmount;
@property (nonatomic, retain) NSNumber * spentAmount;
@property (nonatomic, retain) NSDate * date;

@end
