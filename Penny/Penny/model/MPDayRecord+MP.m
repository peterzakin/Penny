//
//  MPDayRecord+MP.m
//  Penny
//
//  Created by PETER ZAKIN on 7/26/14.
//  Copyright (c) 2014 com.MJPZ. All rights reserved.
//

#import "MPDayRecord+MP.h"
#import "NSDate+MP.h"
#import "MPClient.h"
#import "MPCoreDataManager.h"
#import "NSManagedObjectContext+MP.h"

@implementation MPDayRecord (MP)

+ (NSString *)entityName {
    return @"MPDayRecord";
}

+ (MPDayRecord *)updateOrInsertRecordWithDate:(NSDate *)date budgetAmount:(NSNumber *)budgetAmount spentAmount:(NSNumber *)spentAmount {
   __block MPDayRecord *dayRecord;
    
    NSManagedObjectContext *threadMOC = [MPClient sharedClient].managedObjectContext;
    if (!threadMOC) {
        return nil;
    }
    
    NSArray *results = [MPCoreDataManager executeFetchRequest:[MPDayRecord fetchRequestForRecordsForDate:date] intoManagedObjectContext:threadMOC];
    if ([results count]) {
        dayRecord = results[0];
    } else {
        dayRecord = (MPDayRecord *)[MPCoreDataManager insertObjectOfType:[MPDayRecord entityName] intoManagedObjectContext:threadMOC];
    }

    //save
    [threadMOC performBlockAndWait:^{
        //update with new values
        dayRecord.date = date;
        dayRecord.budgetAmount = budgetAmount;
        dayRecord.spentAmount = spentAmount;
        
        [threadMOC saveAndSync];
    }];
    
    return dayRecord;
}


+ (NSFetchRequest *)fetchRequestForRecordsForDate:(NSDate *)date {
    //sorted by most recent
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[MPDayRecord entityName]];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"date == %@",[date beginningOfDay]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    return fetchRequest;
}

+ (NSArray *)loadAllRecords {
    NSManagedObjectContext *threadMOC = [MPClient sharedClient].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[MPDayRecord entityName]];
    NSArray *results = [MPCoreDataManager executeFetchRequest:fetchRequest intoManagedObjectContext:threadMOC];
    return results;
}

@end
