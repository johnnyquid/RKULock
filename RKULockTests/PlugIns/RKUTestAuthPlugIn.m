//
//  RKUTestAuthPlugIn.m
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKUTestAuthPlugIn.h"

@implementation RKUTestAuthPlugIn

+ (NSString*)serviceName
{
	return @"testService";
}



- (void)configureUsing:(NSDictionary *)configuration
{
  
}

- (void)authenticate
{
  
}

- (BOOL)isAuthenticated
{
  return NO;
}

- (void)logout
{
  
}
- (void)setDelegate:(id)delegate
{
  
}

- (void)setAuthStore:(id<RKUAuthStore>)authStore
{
  
}
@end
