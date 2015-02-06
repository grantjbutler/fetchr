//
//  GJBFetchRequest.m
//  fetchr
//
//  Created by Grant Butler on 2/4/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

#import "GJBFetchRequest.h"
#import "GJBPredicate.h"

@interface GJBFetchRequest ()

@end

@implementation GJBFetchRequest

@synthesize entityName = _entityName;
@synthesize predicate = _predicate;

- (NSFetchRequest *)fetchRequest {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
	
	fetchRequest.predicate = self.predicate.predicate;
	
	return fetchRequest;
}

@end
