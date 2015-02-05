//
//  GJBApplicationDelegate.h
//  fetchr
//
//  Created by Grant Butler on 2/4/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

#import "DDCommandLineInterface.h"

@interface GJBApplicationDelegate : NSObject <DDCliApplicationDelegate>

@property (nonatomic) BOOL help;
@property (nonatomic, copy) NSString *configuration;
@property (nonatomic, copy) NSString *type;

@end
