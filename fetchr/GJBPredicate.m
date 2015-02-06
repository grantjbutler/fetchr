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

- (instancetype)initWithFormat:(NSString *)format arguments:(NSArray *)arguments {
	self = [super init];
	if (self) {
		_format = format;
		_arguments = arguments;
	}
	return self;
}

@end
