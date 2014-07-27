//
//  MPCoreDataManager.m
//  Penny
//
//  Created by PETER ZAKIN on 7/26/14.
//  Copyright (c) 2014 com.MJPZ. All rights reserved.
//

#import "MPCoreDataManager.h"
#import "MPClient.h"

@implementation MPCoreDataManager

+ (NSManagedObject *)insertObjectOfType:(NSString *)entityName intoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
    
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)fetchRequest intoManagedObjectContext:(NSManagedObjectContext *)moc {
    __block NSArray *results;
    [moc performBlockAndWait:^{
        results = [moc executeFetchRequest:fetchRequest error:nil];
    }];
    return results;
}

@end
