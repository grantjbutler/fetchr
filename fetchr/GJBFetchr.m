//
//  GJBFetchr.m
//  fetchr
//
//  Created by Grant Butler on 2/5/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

@import CoreData;

#import "GJBFetchr.h"

#import "GJBFetchRequest.h"
#import "GJBPersistenceController.h"

@interface GJBFetchr ()

@property (nonatomic) GJBPersistenceController *persistenceController;

@end

@implementation GJBFetchr

- (instancetype)initWithPersistenceController:(GJBPersistenceController *)persistenceController {
	self = [super init];
	if (self) {
		_persistenceController = persistenceController;
	}
	return self;
}

- (NSArray *)executeFetchRequest:(GJBFetchRequest *)fetchRequest {
	NSFetchRequest *actualFetchRequest = fetchRequest.fetchRequest;
	actualFetchRequest.resultType = NSDictionaryResultType;
	
	NSError *fetchError;
	NSArray *results = [self.persistenceController.context executeFetchRequest:actualFetchRequest error:&fetchError];
	if (!results.count) {
		return nil;
	}
	else {
		return results;
	}
}

@end
