//
//  RKUAuthPlugIn.h
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RKUAuthStore.h"

@protocol RKUAuthPlugIn <NSObject>

@required

#pragma mark - plugin configuration
+ (NSString *)serviceName;

- (void)configureUsing:(NSDictionary *)configuration;

- (void)setDelegate:(id)delegate;

- (void)setAuthStore:(id<RKUAuthStore>)authStore;

#pragma mark - authentication
- (BOOL)isAuthenticated;

- (void)authenticate;

- (void)logout;
@optional

- (void)authenticateWithCredentials:(NSDictionary *)credentials;

- (BOOL)authenticateWithUrl:(NSURL *)url;

@end