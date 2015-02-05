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

@protocol GJBFetchRequest <JSExport>

@property (nonatomic, copy) NSString *entityName;

@end

@interface GJBFetchRequest : NSObject <GJBFetchRequest>

@property (nonatomic, readonly) NSFetchRequest *fetchRequest;

@end
