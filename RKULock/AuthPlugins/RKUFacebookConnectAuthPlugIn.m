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
@synthesize configurationError = _configurationError;

+ (NSString*)serviceName
{
  return @"facebook";
}

#pragma mark - configuration methods
- (BOOL)configureUsing:(NSDictionary *)configuration
{
  BOOL valid = NO;
  NSString *appId = [configuration objectForKey:@"AppId"];
  if ([configuration objectForKey:@"permissions"]) {
    self.permissions = [configuration objectForKey:@"permissions"];
  } else {
    self.permissions = [NSArray array];
  }
  if (![appId length]) {
    self.configurationError = [NSError errorWithDomain:@"" code:100 userInfo:nil];    
  } else {
    valid = YES;
    self.facebook = [[Facebook alloc] initWithAppId:appId andDelegate:self];
    self.facebook = [self authenticatedFacebookObject];
  }
  return valid;
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
  if ([self.delegate respondsToSelector:@selector(authPluginDidLogout:)]) {
    [self.delegate authPluginDidLogout:self];
  }
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


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
  NSMethodSignature *methodSignature = [super methodSignatureForSelector:aSelector];
  
  return methodSignature;
}

@end
