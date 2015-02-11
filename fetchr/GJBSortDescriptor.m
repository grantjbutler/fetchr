//
//  GJBSortDescriptor.m
//  fetchr
//
//  Created by Butler, Grant on 2/11/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

#import "GJBSortDescriptor.h"

@interface GJBSortDescriptor ()

@property (nonatomic, copy) NSString *key;
@property (nonatomic) BOOL ascending;

@end

@implementation GJBSortDescriptor

- (instancetype)initWithKey:(NSString *)key ascending:(BOOL)ascending {
    self = [super init];
    if (self) {
        _key = [key copy];
        _ascending = ascending;
    }
    return self;
}

- (NSSortDescriptor *)sortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:self.key ascending:self.ascending];
}

@end
