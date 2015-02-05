//
//  GJBFetchr.h
//  fetchr
//
//  Created by Grant Butler on 2/5/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

@import Foundation;
@import JavaScriptCore;

@class GJBPersistenceController;
@class GJBFetchRequest;

@protocol GJBFetchr <JSExport>

- (void)executeFetchRequest:(GJBFetchRequest *)fetchRequest;

@end

@interface GJBFetchr : NSObject <GJBFetchr>

- (instancetype)initWithPersistenceController:(GJBPersistenceController *)persistenceController NS_DESIGNATED_INITIALIZER;

@end
