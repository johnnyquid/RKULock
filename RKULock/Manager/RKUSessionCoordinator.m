//
//  RKUSessionCoordinator.m
//  RKULock
//
//  Created by Erick Camacho on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKUSessionCoordinator.h"

#import "RKUAuthPlugIn.h"
#import "RKUAuthStore.h"
#import "RKUKeychainStore.h"
#import "RKUFacebookConnectAuthPlugIn.h"
#import "NSError+RKULock.h"
#include "objc/runtime.h"

@interface RKUSessionCoordinator ()
{
  BOOL processingRequest;
}

@property (nonatomic, strong) NSArray *pluginClasses;
@property (nonatomic, strong) id<RKUAuthPlugIn> currentAuthPlugin;
@property (nonatomic, weak) id<RKUSessionCoordinatorDelegate> currentDelegate;
@property (nonatomic, strong) NSMutableArray *requestsQueue;
@property (nonatomic, strong) NSMutableDictionary *configuredPlugins;


- (NSArray *)arrayWithClasses;
- (NSArray *)arrayFilteredByNameWithArray:(NSArray *)unfilteredClasses;
- (NSArray *)arrayFilteredByProtocolConformed:(NSArray *)unfilteredClasses;
- (Class)pluginClassWithServiceName:(NSString *)serviceName;
- (NSArray *)findAuthPluginClassesByConventionAndProtocol;
- (NSDictionary *)dictionaryWithInvocation:(NSInvocation *)invocation andDelegate:(id)delegate 
                                 andPlugin:(id<RKUAuthPlugIn>)plugin;
- (void)processRequestsQueue;

- (void)respondConfigurationWithError:(NSError *)error toDelegate:(id<RKUSessionCoordinatorDelegate>)delegate;
- (void)respondPluginNotFoundWithError:(NSError *)error toDelegate:(id<RKUSessionCoordinatorDelegate>)delegate;
- (void)respondPluginNotConfiguredWithError:(NSError *)error toDelegate:(id<RKUSessionCoordinatorDelegate>)delegate;


@end

@implementation RKUSessionCoordinator

@synthesize pluginClasses = _pluginClasses;
@synthesize currentAuthPlugin = _currentAuthPlugin;
@synthesize configuredPlugins = _configuredPlugins;
@synthesize requestsQueue = _requestsQueue;
@synthesize currentDelegate = _currentDelegate;

__strong static id _sharedObject = nil;

- (id)init
{
	NSAssert(_sharedObject == nil, @"Duplication initialization of singleton");
	self = [super init];
	if (self)
	{
    processingRequest = NO;
    self.requestsQueue = [[NSMutableArray alloc] init];
    NSLog(@"requests Queue %@", self.requestsQueue);
		self.pluginClasses = [self findAuthPluginClassesByConventionAndProtocol];
    self.configuredPlugins = [NSMutableDictionary dictionary];
    
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
  
	NSArray *pluginClasses = [self arrayFilteredByProtocolConformed:[self arrayFilteredByNameWithArray:
                                                                   [self arrayWithClasses]]];
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


- (BOOL)configureService:(NSString *)serviceName 
      usingConfiguration:(NSDictionary *)configuration 
            withDelegate:(id<RKUSessionCoordinatorDelegate>)delegate
{
  BOOL configurationValid = YES;
  Class pluginClass = [self pluginClassWithServiceName:serviceName];	
  if (!pluginClass) {
    configurationValid = NO;
    [self respondPluginNotFoundWithError:[NSError serviceNotFoundError:serviceName] toDelegate:delegate];
  }
  else {    
    id<RKUAuthPlugIn> plugin = [[pluginClass alloc] init];
    [plugin setAuthStore:[[RKUKeychainStore alloc] init]];    
    [plugin setDelegate:self];
    [self.configuredPlugins setObject:plugin forKey:serviceName];                        
    if (![plugin configureUsing:configuration]) {
      configurationValid = NO;
      [self respondConfigurationWithError:[plugin configurationError] 
                               toDelegate:delegate];
    }
  }

  
  return configurationValid;
}

- (BOOL)isAuthenticatedInService:(NSString *)serviceName 
                    withDelegate:(id<RKUSessionCoordinatorDelegate>)delegate
{
  if ([self.configuredPlugins objectForKey:serviceName]) {
    self.currentAuthPlugin = [self.configuredPlugins objectForKey:serviceName];
    return [self.currentAuthPlugin isAuthenticated];
  } else {
    [self respondPluginNotConfiguredWithError:[NSError plugInNotConfiguredError] toDelegate:delegate];
    return NO;
  }

}

- (void)authenticateWithServiceName:(NSString *)serviceName 
                       withDelegate:(id<RKUSessionCoordinatorDelegate>)delegate
{
  if ([self.configuredPlugins objectForKey:serviceName]) {
    
    id<RKUAuthPlugIn> authPlugin = [self.configuredPlugins objectForKey:serviceName];
    
    [authPlugin setDelegate:self];
    NSMethodSignature *authenticateSignature = [(NSObject *)authPlugin methodSignatureForSelector:@selector(authenticate)];
    NSInvocation * authenticateInvocation = [NSInvocation
                                             invocationWithMethodSignature:authenticateSignature];
    [authenticateInvocation setTarget:authPlugin];
    [authenticateInvocation setSelector:@selector(authenticate)];    
    [self.requestsQueue addObject:[self dictionaryWithInvocation:authenticateInvocation 
                                                     andDelegate:delegate 
                                                       andPlugin:authPlugin]];
    [self processRequestsQueue];
  } else {
    [self respondPluginNotConfiguredWithError:[NSError plugInNotConfiguredError] toDelegate:delegate];
    
  }
}

- (NSDictionary *)dictionaryWithInvocation:(NSInvocation *)invocation andDelegate:(id)delegate 
                                 andPlugin:(id<RKUAuthPlugIn>)plugin
{
  return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:invocation, delegate, plugin,nil] 
                                     forKeys:[NSArray arrayWithObjects:@"invocation", @"delegate", @"plugin", nil]]; 
  
}

- (void)logoutFromService:(NSString *)serviceName 
             withDelegate:(id<RKUSessionCoordinatorDelegate>)delegate
{
  if ([self.configuredPlugins objectForKey:serviceName]) {
    
    
    id<RKUAuthPlugIn> authPlugin = [self.configuredPlugins objectForKey:serviceName];
    
    NSMethodSignature *logoutSignature = [(NSObject *)authPlugin methodSignatureForSelector:@selector(logout)];
    NSInvocation *logoutInvocation = [NSInvocation
                                             invocationWithMethodSignature:logoutSignature];
    [logoutInvocation setTarget:authPlugin];
    [logoutInvocation setSelector:@selector(logout)];    
    [self.requestsQueue addObject:[self dictionaryWithInvocation:logoutInvocation 
                                                     andDelegate:delegate 
                                                       andPlugin:authPlugin]];
    [self processRequestsQueue];

  } else {
    [self respondPluginNotConfiguredWithError:[NSError plugInNotConfiguredError] toDelegate:delegate];
    
  }
}

- (BOOL)handleOpenURLForAuthentication:(NSURL *)url                             
                          withDelegate:(id<RKUSessionCoordinatorDelegate>)delegate
{
  [self.currentAuthPlugin setDelegate:self];
  if ([self.currentAuthPlugin respondsToSelector:@selector(authenticateWithUrl:)]) {
    return [self.currentAuthPlugin authenticateWithUrl:url];
  }
  return false;
}

- (void)processRequestsQueue
{
  if (!processingRequest && [self.requestsQueue count]) {
    processingRequest = YES;
    NSLog(@"requestqueue %d", [self.requestsQueue count]);
    NSDictionary *request = [self.requestsQueue objectAtIndex:0];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 1; i < [self.requestsQueue count]; i++) {
      [tempArray addObject:[self.requestsQueue objectAtIndex:i]];
    }
    self.requestsQueue = tempArray;
    NSLog(@"requestqueue %d", [self.requestsQueue count]);
    
    self.currentAuthPlugin = [request objectForKey:@"plugin"];
    self.currentDelegate = [request objectForKey:@"delegate"];
    NSInvocation *invocation = [request objectForKey:@"invocation"];
    [invocation invoke];
    
  } 
}

#pragma mark - validation methods


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

#pragma mark - auth plugin delegate methods


- (void)authPlugin:(id<RKUAuthPlugIn>)authPlugin invalidConfiguration:(NSDictionary *)configuration
{
  processingRequest = NO;
  if ([self.currentDelegate respondsToSelector:@selector(sessionCoordinator:invalidConfiguration:)]) {
    [self.currentDelegate sessionCoordinator:self configurationDidFailWithError:nil];
    
  }
  [self processRequestsQueue];
}

- (void)authPluginDidAuthenticateSuccesfully:(id<RKUAuthPlugIn>)authPlugin
{
  processingRequest = NO;
  if ([self.currentDelegate respondsToSelector:@selector(sessionCoordinatorDidAuthenticateSuccesfully:)]) {
    [self.currentDelegate sessionCoordinatorDidAuthenticateSuccesfully:self];
  }
  [self processRequestsQueue];
}

- (void)authPluginDidNotAuthenticate:(id<RKUAuthPlugIn>)authPlugin
{
  processingRequest = NO;
  if ([self.currentDelegate respondsToSelector:@selector(sessionCoordinatorDidNotAuthenticate:)]) {
    [self.currentDelegate sessionCoordinatorDidNotAuthenticate:self];
  }
  
  [self processRequestsQueue];
}


- (void)authPluginDidLogout:(id<RKUAuthPlugIn>)authPlugin
{
  processingRequest = NO;
  if ([self.currentDelegate respondsToSelector:@selector(sessionCoordinatorDidLogout:)]) {
    [self.currentDelegate sessionCoordinatorDidLogout:self];
  }

  [self processRequestsQueue];
}

#pragma mark - error handling

- (void)respondConfigurationWithError:(NSError *)error toDelegate:(id<RKUSessionCoordinatorDelegate>)delegate
{
  if ([delegate respondsToSelector:@selector(sessionCoordinator:configurationDidFailWithError:)]) {
    
    [delegate sessionCoordinator:self configurationDidFailWithError:error];
  }
}

- (void)respondPluginNotFoundWithError:(NSError *)error toDelegate:(id<RKUSessionCoordinatorDelegate>)delegate
{
  if ([delegate respondsToSelector:@selector(sessionCoordinator:pluginNotFoundWithError:)]) {
    [delegate sessionCoordinator:self pluginNotFoundWithError:error];
  }  
}

- (void)respondPluginNotConfiguredWithError:(NSError *)error toDelegate:(id<RKUSessionCoordinatorDelegate>)delegate
{
  if ([delegate respondsToSelector:@selector(sessionCoordinator:pluginNotConfiguredWithError:)]) {
    [delegate sessionCoordinator:self pluginNotConfiguredWithError:error];
  }  
}





@end
