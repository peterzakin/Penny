//
//  MPClient.h
//  Once
//
//  Created by PETER ZAKIN on 6/17/14.
//  Copyright (c) 2014 MJPZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPClient : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (strong, nonatomic) NSManagedObjectContext *backgroundObjectContext;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedClient;
- (void)saveContext;

@end
