//
//  GJBPersistenceController.h
//  fetchr
//
//  Created by Grant Butler on 2/4/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

@import CoreData;

@interface GJBPersistenceController : NSObject

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext *context;

- (instancetype)initWithManagedObjectModel:(NSManagedObjectModel *)model NS_DESIGNATED_INITIALIZER;

@end
