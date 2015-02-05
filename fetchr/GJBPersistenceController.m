//
//  GJBPersistenceController.m
//  fetchr
//
//  Created by Grant Butler on 2/4/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

#import "GJBPersistenceController.h"

@interface GJBPersistenceController ()

@property (nonatomic, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readwrite) NSManagedObjectContext *context;

@end

@implementation GJBPersistenceController

- (instancetype)initWithManagedObjectModel:(NSManagedObjectModel *)model {
	self = [super init];
	if (self) {
		_managedObjectModel = model;
	}
	return self;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (!_persistentStoreCoordinator) {
		_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	}
	
	return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)context {
	if (!_context) {
		_context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		_context.persistentStoreCoordinator = self.persistentStoreCoordinator;
	}
	
	return _context;
}

@end
