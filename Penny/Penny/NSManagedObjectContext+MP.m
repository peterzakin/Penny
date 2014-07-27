//
//  NSManagedObjectContext+MP.m
//  Once
//
//  Created by PETER ZAKIN on 6/17/14.
//  Copyright (c) 2014 MJPZ. All rights reserved.
//

#import "NSManagedObjectContext+MP.h"

@implementation NSManagedObjectContext (MP)

- (BOOL)saveAndSync {
    BOOL success = [self save:nil];
    
    if ([self parentContext]) {
        __block BOOL parentSuccess = NO;
        [[self parentContext] performBlockAndWait:^{
            parentSuccess = [[self parentContext] save:nil];
        }];
        
        success = success && parentSuccess;
    }
    return success;
}

@end
