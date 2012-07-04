//
//  RKUSessionManager.m
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKUSessionManager.h"
#import "RKUAuthPlugIn.h"
#import "MARTNSObject.h"

@interface RKUSessionManager ()

@property (nonatomic, strong) NSArray *pluginClasses;
@property (nonatomic, assign) Class currentAuthPluginClass;

- (NSArray *)arrayWithClasses;
- (NSArray *)arrayFilteredByNameWithArray:(NSArray *)unfilteredClasses;
- (NSArray *)arrayFilteredByProtocolConformed:(NSArray *)unfilteredClasses;
- (Class)pluginClassWithServiceName:(NSString *)serviceName;

@end

@implementation RKUSessionManager

@synthesize pluginClasses = _pluginClasses;
@synthesize currentAuthPluginClass = _currentAuthPluginClass;

__strong static id _sharedObject = nil;

- (id)init
{
	NSAssert(_sharedObject == nil, @"Duplication initialization of singleton");
	self = [super init];
	if (self)
	{
		self.pluginClasses = [self findAuthPluginClassesByConventionAndProtocol];
	}

	return self;
}

+ (id)sharedInstance
{
	static dispatch_once_t pred = 0;
	
	dispatch_once(&pred, ^{
		_sharedObject = [[self alloc] init]; 
	});
	return _sharedObject;
}


- (NSArray *)findAuthPluginClassesByConventionAndProtocol
{

	NSArray *pluginClasses = [self arrayFilteredByProtocolConformed:[self arrayFilteredByNameWithArray:[self arrayWithClasses]]];
	return pluginClasses;
}


- (NSArray *)arrayWithClasses
{
	int numClasses;
	Class *class = NULL;
	NSMutableArray *classes;

	numClasses = objc_getClassList(NULL, 0);
	classes = [NSMutableArray arrayWithCapacity:numClasses];
	
	NSLog(@"Number of classes: %d", numClasses);
	
	if (numClasses > 0 )
	{
		class = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
		numClasses = objc_getClassList(class, numClasses);
		for (int i = 0; i < numClasses; i++) {
			[classes addObject:[NSString stringWithFormat:@"%s", class_getName(class[i])]];

		NSLog(@"Class name: %s", class_getName(class[i]));
		}
		free(class);
	}
	return classes;
}


- (NSArray *)arrayFilteredByNameWithArray:(NSArray *)unfilteredClasses
{
	NSMutableArray *filteredClasses = [NSMutableArray array];

	for (NSString *className in unfilteredClasses)
	{
		NSRange range = [className rangeOfString:@"AuthPlugIn"];
		
		if (range.location != NSNotFound)
		{
			if ((range.location + range.length) == className.length)
			{
				[filteredClasses addObject:className];
			}
		}
	}

	return filteredClasses;
}


- (NSArray *)arrayFilteredByProtocolConformed:(NSArray *)unfilteredClasses
{
	NSMutableArray *filteredClasses = [NSMutableArray array];

	for (NSString *className in unfilteredClasses)
	{
		Class pluginClass = NSClassFromString(className);

		if ([pluginClass conformsToProtocol:@protocol(RKUAuthPlugIn)])
		{
			[filteredClasses addObject:pluginClass];
		}
		
	}

	return filteredClasses;
}


- (void)authenticateWithServiceName:(NSString *)serviceName
{
	self.currentAuthPluginClass = nil;
	if ([serviceName length]) {
		self.currentAuthPluginClass = [self pluginClassWithServiceName:serviceName];	
	}
	if (!self.currentAuthPluginClass) {
		//TODO notify delegate that the plugin was not found
	}
}

- (Class)pluginClassWithServiceName:(NSString *)serviceName
{
	Class foundClass;
	for (Class pluginClass in self.pluginClasses) {
		if ([[pluginClass serviceName] isEqualToString:serviceName]) {
			foundClass = pluginClass;
			break;
		}
	}
	return foundClass;
}


@end
