//
//  NSManagedObjectContext+MP.h
//  Once
//
//  Created by PETER ZAKIN on 6/17/14.
//  Copyright (c) 2014 MJPZ. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (MP)

- (BOOL)saveAndSync;

@end
