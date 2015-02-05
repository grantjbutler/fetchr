//
//  GJBApplicationDelegate.m
//  fetchr
//
//  Created by Grant Butler on 2/4/15.
//  Copyright (c) 2015 Grant Butler. All rights reserved.
//

@import CoreData;
@import JavaScriptCore;

#import "GJBApplicationDelegate.h"

#import "GJBPersistenceController.h"
#import "GJBFetchRequest.h"
#import "GJBFetchr.h"

#import "NSURL+GJBAdditions.h"

#include <readline/readline.h>
#include <readline/history.h>

@interface GJBApplicationDelegate ()

@property (nonatomic) GJBPersistenceController *persistenceController;

@property (nonatomic) JSContext *javaScriptContext;

@end

@implementation GJBApplicationDelegate

- (void)printUsage:(FILE *)stream; {
	ddfprintf(stream, @"%@: Usage [OPTIONS] <model> <store> [...]\n", DDCliApp);
}

- (void)printHelp {
	[self printUsage:stdout];
	printf("\n"
		   " -C, --configuration CONFIGURATION        The Core Data model configuration to use\n"
		   " -t, --type=[sqlite,xml]                  Specify the type of Core Data store\n"
		   " -h, --help                               Display this help and exit\n"
		   "\n"
		   "A JavaScript interface for interacting with a Core Data store.\n");
}

- (BOOL)isValidStoreTypeOption:(NSString *)option {
	NSString *lowercaseOption = [option lowercaseString];
	return ([lowercaseOption isEqualToString:@"sqlite"] || [lowercaseOption isEqualToString:@"xml"]);
}

- (NSString *)storeTypeFromOption:(NSString *)option {
	NSString *lowercaseOption = [option lowercaseString];
	if ([lowercaseOption isEqualToString:@"sqlite"]) {
		return NSSQLiteStoreType;
	}
	else if ([lowercaseOption isEqualToString:@"xml"]) {
		return NSXMLStoreType;
	}
	
	return nil;
}

// BEGIN METHOD TAKEN FROM mogenerator
- (NSString*)xcodeSelectPrintPath {
	NSString *result = @"";
	
	@try {
		NSTask *task = [[NSTask alloc] init];
		[task setLaunchPath:@"/usr/bin/xcode-select"];
		
		[task setArguments:[NSArray arrayWithObject:@"-print-path"]];
		
		NSPipe *pipe = [NSPipe pipe];
		[task setStandardOutput:pipe];
		//  Ensures that the current tasks output doesn't get hijacked
		[task setStandardInput:[NSPipe pipe]];
		
		NSFileHandle *file = [pipe fileHandleForReading];
		
		[task launch];
		
		NSData *data = [file readDataToEndOfFile];
		result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		result = [result substringToIndex:[result length]-1]; // trim newline
	} @catch(NSException *ex) {
		ddprintf(@"WARNING couldn't launch /usr/bin/xcode-select\n");
	}
	
	return result;
}
// END METHOD TAKEN FROM mogenerator

- (int)application:(DDCliApplication *)app runWithArguments:(NSArray *)arguments {
	__block BOOL isDone = NO;
	
	if (self.help) {
		[self printHelp];
		return EXIT_SUCCESS;
	}
	
	if (arguments.count < 2) {
		[self printUsage:stderr];
		return EX_USAGE;
	}
	
	NSFileManager *fm = [NSFileManager defaultManager];
	
	NSURL *modelURL = [NSURL fileURLWithPath:[arguments[0] stringByExpandingTildeInPath]];
	NSURL *storeURL = [NSURL fileURLWithPath:[arguments[1] stringByExpandingTildeInPath]];
	
	if ([modelURL.pathExtension isEqualToString:@"xcdatamodeld"]) {
		NSURL *currentVersionURL = [modelURL URLByAppendingPathComponent:@".xccurrentversion"];
		if ([fm fileExistsAtPath:currentVersionURL.path]) {
			NSDictionary *currentVersionDictionary = [NSDictionary dictionaryWithContentsOfURL:currentVersionURL];
			
			NSString *currentVersionModelFileName = currentVersionDictionary[@"_XCCurrentVersionName"];
			modelURL = [modelURL URLByAppendingPathComponent:currentVersionModelFileName];
		}
		else {
			// BEGIN CODE TAKEN FROM mogenerator
			// Freshly created models with only one version do NOT have a .xccurrentversion file, but only have one model
			// in them.  Use that model.
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self endswith %@", @".xcdatamodel"];
			NSArray *contents = [[fm contentsOfDirectoryAtPath:modelURL.path error:nil] filteredArrayUsingPredicate:predicate];
			if (contents.count == 1) {
				modelURL = [modelURL URLByAppendingPathComponent:[contents lastObject]];
			}
			// END CODE TAKEN FROM mogenerator
		}
	}
	
	// BEGIN CODE TAKEN FROM mogenerator
	NSString *tempGeneratedMomFilePath;
	NSURL *momFileURL;
	if ([[modelURL pathExtension] isEqualToString:@"xcdatamodel"]) {
		//  We've been handed a .xcdatamodel data model, transparently compile it into a .mom managed object model.
		
		NSString *momcTool = nil;
		{{
			// Rats, don't have xcrun. Hunt around for momc in various places where various versions of Xcode stashed it.
			NSString *xcodeSelectMomcPath = [NSString stringWithFormat:@"%@/usr/bin/momc", [self xcodeSelectPrintPath]];
			
			if ([fm fileExistsAtPath:xcodeSelectMomcPath]) {
				momcTool = [NSString stringWithFormat:@"\"%@\"", xcodeSelectMomcPath]; // Quote for safety.
			} else if ([fm fileExistsAtPath:@"/Applications/Xcode.app/Contents/Developer/usr/bin/momc"]) {
				// Xcode 4.3 - Command Line Tools for Xcode
				momcTool = @"/Applications/Xcode.app/Contents/Developer/usr/bin/momc";
			} else if ([fm fileExistsAtPath:@"/Developer/usr/bin/momc"]) {
				// Xcode 3.1.
				momcTool = @"/Developer/usr/bin/momc";
			} else if ([fm fileExistsAtPath:@"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc"]) {
				// Xcode 3.0.
				momcTool = @"\"/Library/Application Support/Apple/Developer Tools/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc\"";
			} else if ([fm fileExistsAtPath:@"/Developer/Library/Xcode/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc"]) {
				// Xcode 2.4.
				momcTool = @"/Developer/Library/Xcode/Plug-ins/XDCoreDataModel.xdplugin/Contents/Resources/momc";
			}
			assert(momcTool && "momc not found");
		}}
		
		NSMutableString *momcOptions = [NSMutableString string];
		{{
			NSArray *supportedMomcOptions = [NSArray arrayWithObjects:
											 @"MOMC_NO_WARNINGS",
											 @"MOMC_NO_INVERSE_RELATIONSHIP_WARNINGS",
											 @"MOMC_SUPPRESS_INVERSE_TRANSIENT_ERROR",
											 nil];
			for (NSString *momcOption in supportedMomcOptions) {
				if ([[[NSProcessInfo processInfo] environment] objectForKey:momcOption]) {
					[momcOptions appendFormat:@" -%@ ", momcOption];
				}
			}
		}}
		
		NSString *momcIncantation = nil;
		{{
			NSString *tempGeneratedMomFileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingPathExtension:@"mom"];
			tempGeneratedMomFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:tempGeneratedMomFileName];
			momcIncantation = [NSString stringWithFormat:@"%@ %@ \"%@\" \"%@\"",
							   momcTool,
							   momcOptions,
							   modelURL.path,
							   tempGeneratedMomFilePath];
		}}
		
		{{
			system([momcIncantation UTF8String]); // Ignore system() result since momc sadly doesn't return any relevent error codes.
			momFileURL = [NSURL fileURLWithPath:tempGeneratedMomFilePath];
		}}
	} else {
		momFileURL = modelURL;
	}
	// END CODE TAKEN FROM mogenerator
	
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momFileURL];
	if (!model) {
		ddfprintf(stderr, @"%@: Could not load model at path '%@'. Double check that it is correct.\n", DDCliApp, momFileURL.path);
		return EXIT_FAILURE;
	}
	
	self.persistenceController = [[GJBPersistenceController alloc] initWithManagedObjectModel:model];
	NSString *storeType = storeURL.storeTypeGuess;
	if ([storeType isEqualToString:GJBUnknownStoreType]) {
		if (self.type && [self isValidStoreTypeOption:self.type]) {
			storeType = [self storeTypeFromOption:self.type];
		}
		else {
			ddfprintf(stderr, @"%@: Unable to automatically determine store type of store at path '%@'. Use --type to specify type.)\n", DDCliApp, storeURL.path);
			return EXIT_FAILURE;
		}
	}
	
	NSError *storeError;
	if (![self.persistenceController.persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:self.configuration URL:storeURL options:nil error:&storeError]) {
		ddfprintf(stderr, @"%@: Error opening store at path '%@': %@\n", DDCliApp, storeURL.path, storeError);
		return EXIT_FAILURE;
	}
	
	self.javaScriptContext = [[JSContext alloc] init];
	self.javaScriptContext[@"fetchr"] = [[GJBFetchr alloc] initWithPersistenceController:self.persistenceController];
	self.javaScriptContext[@"FetchRequest"] = [GJBFetchRequest class];
	self.javaScriptContext[@"exit"] = ^{
		isDone = YES;
	};
	
	self.javaScriptContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
		// TODO: Handle exception better.
		ddprintf(@"%@\n", [exception toString]);
	};
	
	char *input;
	
	
	do {
		input = readline("> ");
		
		if (!input) {
			break;
		}
		
		add_history(input);
		
		NSString *javaScriptSource = [NSString stringWithUTF8String:input];
		JSValue *result = [self.javaScriptContext evaluateScript:javaScriptSource];
		id resultObject = [result toObject];
		if (resultObject) {
			ddprintf(@"%@\n", resultObject);
		}
		
		free(input);
	} while (!isDone);
	
	if (tempGeneratedMomFilePath) {
		[fm removeItemAtPath:tempGeneratedMomFilePath error:nil];
	}
	
	return EXIT_SUCCESS;
}

- (void)application:(DDCliApplication *)app willParseOptions:(DDGetoptLongParser *)optionParser {
	DDGetoptOption optionTable[] = {
		{"configuration",	'C',	DDGetoptRequiredArgument},
		{"type",			't',	DDGetoptRequiredArgument},
		{"help",			'h',	DDGetoptNoArgument},
		{nil,				0,		0}
	};
	[optionParser addOptionsFromTable:optionTable];
}

@end
