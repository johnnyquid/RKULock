//
//  RKUSessionCoordinator.h
//  RKULock
//
//  Created by Erick Camacho on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RKUAuthPlugInDelegate.h"
#import "RKUSessionCoordinatorDelegate.h"

@interface RKUSessionCoordinator : NSObject <RKUAuthPlugInDelegate>

+ (id)sharedInstance;

- (BOOL)configureService:(NSString *)serviceName 
      usingConfiguration:(NSDictionary *)configuration 
            withDelegate:(id<RKUSessionCoordinatorDelegate>)delegate;

- (BOOL)handleOpenURLForAuthentication:(NSURL *)url                             
                          withDelegate:(id<RKUSessionCoordinatorDelegate>)delegate;

- (BOOL)isAuthenticatedInService:(NSString *)serviceName 
                    withDelegate:(id<RKUSessionCoordinatorDelegate>)delegate;

- (void)authenticateWithServiceName:(NSString *)serviceName 
                       withDelegate:(id<RKUSessionCoordinatorDelegate>)delegate;

- (void)logoutFromService:(NSString *)serviceName 
             withDelegate:(id<RKUSessionCoordinatorDelegate>)delegate;


@end
