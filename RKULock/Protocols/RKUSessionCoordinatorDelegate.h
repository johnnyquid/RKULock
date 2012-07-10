//
//  RKUSessionCoordinatorDelegate.h
//  RKULock
//
//  Created by Erick Camacho on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKUSessionCoordinator;

@protocol RKUSessionCoordinatorDelegate <NSObject>

@required

- (void)sessionCoordinator:(RKUSessionCoordinator *)sessionCoordinator invalidConfiguration:(NSDictionary *)configuration;

- (void)sessionCoordinatorDidAuthenticateSuccesfully:(RKUSessionCoordinator *)sessionCoordinator;

- (void)sessionCoordinatorDidNotAuthenticate:(RKUSessionCoordinator *)sessionCoordinator;

- (void)sessionCoordinatorDidLogout:(RKUSessionCoordinator *)sessionCoordinator;

#pragma mark - error handling

- (void)sessionCoordinator:(RKUSessionCoordinator *)sessionCoordinator configurationDidFailWithError:(NSError *)error;

- (void)sessionCoordinator:(RKUSessionCoordinator *)sessionCoordinator pluginNotFoundWithError:(NSError *)error;

- (void)sessionCoordinator:(RKUSessionCoordinator *)sessionCoordinator pluginNotConfiguredWithError:(NSError *)error;

@end
