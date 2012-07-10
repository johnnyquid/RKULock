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

@end

@implementation RKUSessionManager

@synthesize delegate = _delegate;
@synthesize sessionCoordinator = _sessionCoordinator;

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


@end
