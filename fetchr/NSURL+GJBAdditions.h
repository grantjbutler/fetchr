//
//  NSURL+GJBAdditions.h
//  fetchr
//
//  Created by Grant Butler on 2/5/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

@import Foundation;
@import CoreData;

extern NSString * const GJBUnknownStoreType;

@interface NSURL (GJBAdditions)

@property (nonatomic, readonly) NSString *storeTypeGuess;

@end
