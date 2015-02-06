//
//  GJBFetchRequest.h
//  fetchr
//
//  Created by Grant Butler on 2/4/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

@import Foundation;
@import JavaScriptCore;
@import CoreData;

@class GJBPredicate;

@protocol GJBFetchRequest <JSExport>

@property (nonatomic, copy) NSString *entityName;
@property (nonatomic) GJBPredicate *predicate;

@end

@interface GJBFetchRequest : NSObject <GJBFetchRequest>

@property (nonatomic, readonly) NSFetchRequest *fetchRequest;

@end
