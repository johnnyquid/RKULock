//
//  RKUSessionManager.m
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKUSessionManager.h"

#import "RKUSessionCoordinator.h"

@interface RKUSessionManager ()

@property (nonatomic, strong) RKUSessionCoordinator *sessionCoordinator;

@property (nonatomic, strong) NSError *lastError;

@end

@implementation RKUSessionManager

@synthesize delegate = _delegate;
@synthesize sessionCoordinator = _sessionCoordinator;
@synthesize lastError = _lastError;

- (id)init
{
  self = [super init];
  if (self) {
    self.sessionCoordinator = [RKUSessionCoordinator sharedInstance];
  }
  return self;
}

- (id)initWithDelegate:(id<RKUSessionManagerDelegate>)delegate
{
  self = [super init];
  
  if (self) {
    self.delegate = delegate;
    self.sessionCoordinator = [RKUSessionCoordinator sharedInstance];
  }
  return self;
}


- (void)configureService:(NSString *)serviceName using:(NSDictionary *)configuration
{
  [self.sessionCoordinator configureService:serviceName usingConfiguration:configuration withDelegate:self];
}

- (BOOL)handleOpenURLForAuthentication:(NSURL *)url
{
  return [self.sessionCoordinator handleOpenURLForAuthentication:url withDelegate:self];
}

- (BOOL)isAuthenticatedInService:(NSString *)serviceName
{
  return [self.sessionCoordinator isAuthenticatedInService:serviceName withDelegate:self];
}

- (void)authenticateWithServiceName:(NSString *)serviceName
{
  [self.sessionCoordinator authenticateWithServiceName:serviceName 
                                          withDelegate:self];
}

- (void)logoutFromService:(NSString *)serviceName
{
  [self.sessionCoordinator logoutFromService:serviceName 
                                withDelegate:self];
}


/*
 - (void)sessionManager:(RKUSessionManager *)sessionManager didAuthenticate:(BOOL)didAuthenticate;
 
 - (void)sessionManager:(RKUSessionManager *)sessionManager didLogout:(BOOL)didLogout;
 
 - (void)sessionManager:(RKUSessionManager *)sessionManager didFailWithError:(NSError *)error;

 */
#pragma mark - session coordinator delegate


- (void)sessionCoordinatorDidAuthenticateSuccesfully:(RKUSessionCoordinator *)sessionCoordinator
{
  if ([self.delegate respondsToSelector:@selector(sessionManager:didAuthenticate:)]) {
    [self.delegate sessionManager:self didAuthenticate:YES];
  }
}

- (void)sessionCoordinatorDidNotAuthenticate:(RKUSessionCoordinator *)sessionCoordinator
{
  if ([self.delegate respondsToSelector:@selector(sessionManager:didAuthenticate:)]) {
    [self.delegate sessionManager:self didAuthenticate:NO];
  }
}

- (void)sessionCoordinatorDidLogout:(RKUSessionCoordinator *)sessionCoordinator
{
  if ([self.delegate respondsToSelector:@selector(sessionManager:didLogout:)]) {
    [self.delegate sessionManager:self didLogout:YES];
  }
}

#pragma mark - error handling

- (void)sessionCoordinator:(RKUSessionCoordinator *)sessionCoordinator configurationDidFailWithError:(NSError *)error
{
  self.lastError = error;
  
  if ([self.delegate respondsToSelector:@selector(sessionManager:didFailWithError:)]) {
    [self.delegate sessionManager:self didFailWithError:nil];
  }

}

- (void)sessionCoordinator:(RKUSessionCoordinator *)sessionCoordinator pluginNotFoundWithError:(NSError *)error
{
  
  self.lastError = error;
  if ([self.delegate respondsToSelector:@selector(sessionManager:didFailWithError:)]) {
    [self.delegate sessionManager:self didFailWithError:nil];
  }
}

- (void)sessionCoordinator:(RKUSessionCoordinator *)sessionCoordinator pluginNotConfiguredWithError:(NSError *)error
{
  self.lastError = error;
  if ([self.delegate respondsToSelector:@selector(sessionManager:didFailWithError:)]) {
    [self.delegate sessionManager:self didFailWithError:nil];
  }
}


@end
