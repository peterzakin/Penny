//
//  MPCoreDataManager.h
//  Penny
//
//  Created by PETER ZAKIN on 7/26/14.
//  Copyright (c) 2014 com.MJPZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPCoreDataManager : NSObject

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)fetchRequest intoManagedObjectContext:(NSManagedObjectContext *)moc;

+ (NSManagedObject *)insertObjectOfType:(NSString *)entityName intoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
