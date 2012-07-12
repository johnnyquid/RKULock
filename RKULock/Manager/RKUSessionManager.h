//
//  RKUSessionManager.h
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RKUSessionCoordinatorDelegate.h"

#import "RKUSessionManagerDelegate.h"

@interface RKUSessionManager : NSObject <RKUSessionCoordinatorDelegate>

@property (nonatomic, weak) id<RKUSessionManagerDelegate> delegate;

@property (nonatomic, strong, readonly) NSError *lastError;

- (id)initWithDelegate:(id<RKUSessionManagerDelegate>)delegate;

- (BOOL)configureService:(NSString *)serviceName using:(NSDictionary *)configuration;

- (BOOL)handleOpenURLForAuthentication:(NSURL *)url;

- (BOOL)isAuthenticatedInService:(NSString *)serviceName;

- (void)authenticateWithServiceName:(NSString *)serviceName;

- (void)logoutFromService:(NSString *)serviceName;
@end
