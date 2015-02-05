//
//  NSURL+GJBAdditions.m
//  fetchr
//
//  Created by Grant Butler on 2/5/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

#import "NSURL+GJBAdditions.h"

NSString * const GJBUnknownStoreType = @"com.grantjbutler.CoreData.UnknownStoreType";

@implementation NSURL (GJBAdditions)

- (NSString *)storeTypeGuess {
	NSString *fileExtension = self.pathExtension.lowercaseString;
	if ([fileExtension isEqualToString:@"sqlite"]) {
		return NSSQLiteStoreType;
	}
	else if ([fileExtension isEqualToString:@"xml"]) {
		return NSXMLStoreType;
	}
	
	return GJBUnknownStoreType;
}

@end
