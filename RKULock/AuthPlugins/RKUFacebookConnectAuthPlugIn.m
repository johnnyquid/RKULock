//
//  RKUFacebookConnectAuthPlugIn.m
//  RKULock
//
//  Created by Erick Camacho on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKUFacebookConnectAuthPlugIn.h"

@interface RKUFacebookConnectAuthPlugIn ()

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) NSArray *permissions;

@end

@implementation RKUFacebookConnectAuthPlugIn

@synthesize facebook = _facebook;
@synthesize delegate = _delegate;
@synthesize permissions = _permissions;

+ (NSString*)serviceName
{
  return @"facebook";
}

#pragma mark - configuration methods
- (void)configureUsing:(NSDictionary *)configuration
{
  NSString *appId = [configuration objectForKey:@"AppId"];
  if ([configuration objectForKey:@"permissions"]) {
    self.permissions = [configuration objectForKey:@"permissions"];
  } else {
    self.permissions = [NSArray array];
  }
  if (![appId length]) {
    if ([self.delegate respondsToSelector:@selector(authPlugin:invalidConfiguration:)]) {
      [self.delegate authPlugin:self invalidConfiguration:configuration];
    }
  } else {
    self.facebook = [[Facebook alloc] initWithAppId:appId andDelegate:self];
  }
}

#pragma mark - authentication methods
- (void)authenticate
{
  [self.facebook authorize:self.permissions];  
}

- (BOOL)authenticateWithUrl:(NSURL *)url
{
  return [self.facebook handleOpenURL:url];
}

#pragma mark - Facebook Session delegate methods
- (void)fbDidLogin
{
  //TODO store token and valid date in keychain
  if ([self.delegate respondsToSelector:@selector(authPluginDidAuthenticateSuccesfully:)]) {
    [self.delegate authPluginDidAuthenticateSuccesfully:self];
  }
  
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
  if ([self.delegate respondsToSelector:@selector(authPluginDidNotAuthenticate:)]) {
    [self.delegate authPluginDidNotAuthenticate:self];
  }
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
  
}

- (void)fbDidLogout
{
  
}

- (void)fbSessionInvalidated
{
  
}

@end
