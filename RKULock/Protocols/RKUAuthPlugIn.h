//
//  RKUAuthPlugIn.h
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RKUAuthPlugIn <NSObject>

@required

+ (NSString *)serviceName;

- (void)configureUsing:(NSDictionary *)configuration;

- (void)authenticate;

- (void)setDelegate:(id)delegate;

@optional
- (void)authenticateWithCredentials:(NSDictionary *)credentials;

- (BOOL)authenticateWithUrl:(NSURL *)url;
@end
