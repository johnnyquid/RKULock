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

- (void)saveAuthDataInStoreWithToken:(NSString *)token andExpirationDate:(NSDate *)date;
- (void)removeAuthDataFromStore;
- (Facebook *)authenticatedFacebookObject;

@end

@implementation RKUFacebookConnectAuthPlugIn

@synthesize facebook = _facebook;
@synthesize delegate = _delegate;
@synthesize permissions = _permissions;
@synthesize authStore = _authStore;

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
    self.facebook = [self authenticatedFacebookObject];
  }
}

#pragma mark - authentication methods
- (BOOL)isAuthenticated
{
  return [self.facebook isSessionValid];
}

- (void)authenticate
{
  [self.facebook authorize:self.permissions];  
}

- (BOOL)authenticateWithUrl:(NSURL *)url
{
  return [self.facebook handleOpenURL:url];
}

- (void)logout
{
  [self.facebook logout];
}
#pragma mark - Facebook Session delegate methods
- (void)fbDidLogin
{
  [self saveAuthDataInStoreWithToken:self.facebook.accessToken 
                   andExpirationDate:self.facebook.expirationDate];
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
  [self saveAuthDataInStoreWithToken:accessToken andExpirationDate:expiresAt];
  self.facebook = [self authenticatedFacebookObject];
}

- (void)fbDidLogout
{
  [self removeAuthDataFromStore];
}

- (void)fbSessionInvalidated
{
  [self removeAuthDataFromStore];
}

#pragma mark - auth store methods

- (Facebook *)authenticatedFacebookObject
{
  NSString *storedToken = [self.authStore tokenWithServiceName:[self.class serviceName]];
  NSDate *storedExpirationDate = [self.authStore tokenExpirationDateWithServiceName:[self.class serviceName]];
  if (storedToken && storedExpirationDate) {
    [self.facebook setAccessToken:storedToken];
    [self.facebook setExpirationDate:storedExpirationDate];
  }
  return self.facebook;
}

- (void)saveAuthDataInStoreWithToken:(NSString *)token andExpirationDate:(NSDate *)expirationDate
{
  [self.authStore setToken:token 
           withServiceName:[self.class serviceName]];
  [self.authStore setTokenExpirationDate:expirationDate 
                         withServiceName:[self.class serviceName]];
}

- (void)removeAuthDataFromStore
{
  [self.authStore removeTokenWithServiceName:[self.class serviceName]];
  [self.authStore removeTokenExpirationDateWithServiceName:[self.class serviceName]];
}


@end
