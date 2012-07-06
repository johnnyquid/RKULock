//
//  RKUSessionManager.h
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RKUAuthPluginDelegate.h"

#import "RKUSessionManagerDelegate.h"

@interface RKUSessionManager : NSObject <RKUAuthPlugInDelegate>

@property (nonatomic, strong, readonly) NSArray *pluginClasses;
@property (nonatomic, weak) id<RKUSessionManagerDelegate> delegate;

+ (id)sharedInstance;

- (NSArray *)findAuthPluginClassesByConventionAndProtocol;

- (void)configureService:(NSString *)serviceName using:(NSDictionary *)configuration;

- (BOOL)handleOpenURLForAuthentication:(NSURL *)url;

- (BOOL)isAuthenticatedInService:(NSString *)serviceName;

- (void)authenticateWithServiceName:(NSString *)serviceName;

- (void)logoutFromService:(NSString *)serviceName;
@end
