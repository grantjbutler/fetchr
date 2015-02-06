//
//  GJBPredicate.m
//  fetchr
//
//  Created by Grant Butler on 2/5/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

#import "GJBPredicate.h"

@interface GJBPredicate ()

@property (nonatomic) NSString *format;
@property (nonatomic) NSArray *arguments;

@end

@implementation GJBPredicate

+ (instancetype)format {
	NSArray *arguments = [JSContext currentArguments];
	if (arguments.count == 0) {
		// TODO: Throw an error? Maybe?
		return nil;
	}
	
	NSString *format = [arguments[0] toString];
	NSArray *formatArguments;
	
	if (arguments.count > 1) {
		formatArguments = [[arguments subarrayWithRange:NSMakeRange(1, arguments.count - 1)] valueForKey:NSStringFromSelector(@selector(toObject))];
	}
	
	return [[GJBPredicate alloc] initWithFormat:format arguments:formatArguments];
}

- (instancetype)initWithFormat:(NSString *)format arguments:(NSArray *)arguments {
	self = [super init];
	if (self) {
		_format = format;
		_arguments = arguments;
	}
	return self;
}

- (NSPredicate *)predicate {
	return [NSPredicate predicateWithFormat:self.format argumentArray:self.arguments];
}

@end
