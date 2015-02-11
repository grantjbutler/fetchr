//
//  GJBSortDescriptor.h
//  fetchr
//
//  Created by Butler, Grant on 2/11/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

@import Foundation;
@import JavaScriptCore;

@protocol GJBSortDescriptor <JSExport>

JSExportAs(init,
- (instancetype)initWithKey:(NSString *)key ascending:(BOOL)ascending);

@end

@interface GJBSortDescriptor : NSObject <GJBSortDescriptor>

- (instancetype)initWithKey:(NSString *)key ascending:(BOOL)ascending;

@end
