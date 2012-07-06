//
//  RKUSessionManagerTest.m
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKUSessionManagerTest.h"
#import "RKUSessionManager.h"
#import "RKUTestAuthPlugIn.h"

@implementation RKUSessionManagerTest

@synthesize sessionManager;

- (void)setUp
{
	self.sessionManager = [RKUSessionManager sharedInstance];
}


- (void)testFindAuthPluginClassesByConventionAndProtocol
{
	NSArray *array = [self.sessionManager findAuthPluginClassesByConventionAndProtocol];
	STAssertNotNil(array, @"Finding Plugin classes by Convention returns a valid array");

	NSUInteger expectedArrayCount = 2;
	STAssertEquals([array count], expectedArrayCount, @"Checking array is not empty");
}

- (void)testAuthenticatesWithCorrectService
{
	NSString *testServiceName = @"testService";
	[self.sessionManager authenticateWithServiceName:testServiceName];
	
}

@end
