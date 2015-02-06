//
//  GJBPredicate.h
//  fetchr
//
//  Created by Grant Butler on 2/5/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

@import Foundation;
@import JavaScriptCore;

@protocol GJBPredicate <JSExport>

+ (instancetype)format;

@end

@interface GJBPredicate : NSObject <GJBPredicate>

@end
