//
//  self.m
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKUKeychainStore.h"

#import "RKUAuthStore.h"

@interface RKUKeychainStore ()

- (NSString *)valueForIdentifier:(NSString *)identifier;
- (void)setValue:(NSString *)value forIdentifier:(NSString *)identifier;
- (void)removeValueForIdentifier:(NSString *)identifier;
- (NSString *)valueForApplicationConfigurationKey:(NSString *)configurationKey;

@end

@implementation RKUKeychainStore

#pragma mark -
#pragma mark NSString Tokens

- (NSString *)tokenWithServiceName:(NSString *)serviceName
{
	NSString *configurationKeySuffix = [self valueForApplicationConfigurationKey:@"KeychainSuffix"];
	NSString *configurationMiddleString = [self valueForApplicationConfigurationKey:@"KeychainTokenString"];
	NSString *configurationKey = [NSString stringWithFormat:@"%@%@%@", serviceName, configurationMiddleString, configurationKeySuffix];
	
	NSString *tokenIdentifier = [self valueForApplicationConfigurationKey:configurationKey];
	
	return [self valueForIdentifier:tokenIdentifier];
}


- (void)setToken:(NSString *)token withServiceName:(NSString *)serviceName
{
	if (token)
	{
		NSString *configurationKeySuffix = [self valueForApplicationConfigurationKey:@"KeychainSuffix"];
		NSString *configurationMiddleString = [self valueForApplicationConfigurationKey:@"KeychainTokenString"];
		NSString *configurationKey = [NSString stringWithFormat:@"%@%@%@", serviceName, configurationMiddleString, configurationKeySuffix];
		
        NSString *tokenIdentifier = [self valueForApplicationConfigurationKey:configurationKey];
        
        [self setValue:token forIdentifier:tokenIdentifier];

	}
}


- (void)removeTokenWithServiceName:(NSString *)serviceName
{
	NSString *configurationKeySuffix = [self valueForApplicationConfigurationKey:@"KeychainSuffix"];
	NSString *configurationMiddleString = [self valueForApplicationConfigurationKey:@"KeychainTokenString"];
	NSString *configurationKey = [NSString stringWithFormat:@"%@%@%@", serviceName, configurationMiddleString, configurationKeySuffix];
	
	NSString *tokenIdentifier = [self valueForApplicationConfigurationKey:configurationKey];
	
	[self removeValueForIdentifier:tokenIdentifier];
}


#pragma mark -
#pragma mark NSDate Tokens


- (NSDate *)tokenExpirationDateWithServiceName:(NSString *)serviceName
{
	NSDate *tokenExpirationDate = nil;
	
	NSString *configurationKeySuffix = [self valueForApplicationConfigurationKey:@"KeychainSuffix"];
	NSString *configurationMiddleString = [self valueForApplicationConfigurationKey:@"KeychainDateString"];
	NSString *configurationTokenString = [self valueForApplicationConfigurationKey:@"KeychainTokenString"];
	NSString *configurationKey = [NSString stringWithFormat:@"%@%@%@%@", serviceName, configurationTokenString, configurationMiddleString, configurationKeySuffix];
	
    NSString *tokenExpirationDateIdentifier = [self valueForApplicationConfigurationKey:configurationKey];
	
    NSString *expirationDateTimeInterval = [self valueForIdentifier:tokenExpirationDateIdentifier];
	
	if (expirationDateTimeInterval)
	{
		tokenExpirationDate = [NSDate dateWithTimeIntervalSince1970:[expirationDateTimeInterval doubleValue]];
	}
	
	return tokenExpirationDate;
}


- (void)setTokenExpirationDate:(NSDate *)tokenExpirationDate withServiceName:(NSString *)serviceName
{
	if (tokenExpirationDate)
	{
		NSString *expirationDateTimeInterval = [NSString stringWithFormat:@"%f", [tokenExpirationDate timeIntervalSince1970]];
		
		NSString *configurationKeySuffix = [self valueForApplicationConfigurationKey:@"KeychainSuffix"];
		NSString *configurationMiddleString = [self valueForApplicationConfigurationKey:@"KeychainDateString"];
		NSString *configurationTokenString = [self valueForApplicationConfigurationKey:@"KeychainTokenString"];
		NSString *configurationKey = [NSString stringWithFormat:@"%@%@%@%@", serviceName, configurationTokenString, configurationMiddleString, configurationKeySuffix];
		
		NSString *tokenExpirationDateIdentifier = [self valueForApplicationConfigurationKey:configurationKey];
		
		[self setValue:expirationDateTimeInterval forIdentifier:tokenExpirationDateIdentifier];
	}
}


- (void)removeTokenExpirationDateWithServiceName:(NSString *)serviceName
{
	NSString *configurationKeySuffix = [self valueForApplicationConfigurationKey:@"KeychainSuffix"];
	NSString *configurationMiddleString = [self valueForApplicationConfigurationKey:@"KeychainDateString"];
	NSString *configurationTokenString = [self valueForApplicationConfigurationKey:@"KeychainTokenString"];
	NSString *configurationKey = [NSString stringWithFormat:@"%@%@%@%@", serviceName, configurationTokenString, configurationMiddleString, configurationKeySuffix];
	NSString *tokenExpirationDateIdentifier = [self valueForApplicationConfigurationKey:configurationKey];
	
	[self removeValueForIdentifier:tokenExpirationDateIdentifier];
}


#pragma mark -
#pragma mark Private methods


- (NSString *)valueForIdentifier:(NSString *)identifier
{
	NSString *value = nil;
  
	NSMutableDictionary *valueQuery = [[NSMutableDictionary alloc] init];
  
	[valueQuery setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[valueQuery setObject:identifier forKey:(__bridge id)kSecAttrGeneric];
	[valueQuery setObject:identifier forKey:(__bridge id)kSecAttrService];
	[valueQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
	[valueQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
  
#if !TARGET_IPHONE_SIMULATOR
  
	NSString *keychainAccessGroup = [self valueForApplicationConfigurationKey:@"KeychainAccessGroup"];
  
	[valueQuery setObject:keychainAccessGroup forKey:(__bridge id)kSecAttrAccessGroup];
  
#endif
  
  CFTypeRef keychainValueData = nil;
  
  OSStatus keychainStatus = SecItemCopyMatching((__bridge CFDictionaryRef) valueQuery, &keychainValueData);
  
	if (keychainStatus == errSecSuccess)
	{
		NSData *valueData = (__bridge NSData *)keychainValueData;
    
		value = [[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];
	}
  
	return value;
}


- (void)setValue:(NSString *)value forIdentifier:(NSString *)identifier
{
	NSMutableDictionary *valueQuery = [[NSMutableDictionary alloc] init];
  
  [valueQuery setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
  [valueQuery setObject:identifier forKey:(__bridge id)kSecAttrGeneric];
  [valueQuery setObject:identifier forKey:(__bridge id)kSecAttrService];
  [valueQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
  [valueQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
  
  
#if !TARGET_IPHONE_SIMULATOR
  
  NSString *keychainAccessGroup = [self valueForApplicationConfigurationKey:@"KeychainAccessGroup"];
  
  [valueQuery setObject:keychainAccessGroup forKey:(__bridge id)kSecAttrAccessGroup];
  
#endif
	
  
  CFTypeRef keychainValueAttributes = nil;
  
  OSStatus keychainStatus = SecItemCopyMatching((__bridge CFDictionaryRef) valueQuery, &keychainValueAttributes);
  
  if (!keychainStatus == noErr)
	{
    NSMutableDictionary *keychainValue = [[NSMutableDictionary alloc] init];
    [keychainValue setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [keychainValue setObject:identifier forKey:(__bridge id)kSecAttrGeneric];
    [keychainValue setObject:identifier forKey:(__bridge id)kSecAttrService];
    
    [keychainValue setObject:[value dataUsingEncoding:NSUTF8StringEncoding] 
                      forKey:(__bridge id)kSecValueData];
    
    
#if !TARGET_IPHONE_SIMULATOR
    
    NSString *keychainAccessGroup = [self valueForApplicationConfigurationKey:@"KeychainAccessGroup"];
    
    [valueQuery setObject:keychainAccessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    
#endif
    
    
    OSStatus keychainAddStatus = SecItemAdd((__bridge CFDictionaryRef) keychainValue, NULL);
    
    if (keychainAddStatus != errSecSuccess)
		{
      NSLog(@"Failure saving Identifier:%@ on Keychain Stack Trace:%@", identifier, [NSThread callStackSymbols]);
		}
	}
  else if (keychainStatus == errSecSuccess)
	{
    NSMutableDictionary *actualKeychainValue = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary *)keychainValueAttributes];
    [actualKeychainValue setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    
    NSMutableDictionary *keychainValue = [[NSMutableDictionary alloc] init];
    [keychainValue setObject:[value dataUsingEncoding:NSUTF8StringEncoding] 
                      forKey:(__bridge id)kSecValueData];
    
		
#if !TARGET_IPHONE_SIMULATOR
    
		NSString *keychainAccessGroup = [self valueForApplicationConfigurationKey:@"KeychainAccessGroup"];
    
    [keychainValue setObject:keychainAccessGroup forKey:(__bridge id)kSecAttrAccessGroup];
#endif
    
    
    OSStatus keychainUpdateStatus = SecItemUpdate((__bridge CFDictionaryRef) actualKeychainValue, (__bridge CFDictionaryRef)keychainValue);
    
    if (keychainUpdateStatus != errSecSuccess)
		{
      NSLog(@"Failure updating Identifier:%@ on Keychain Stack Trace:%@", identifier, [NSThread callStackSymbols]);
		}
	}
  else 
	{
		NSLog(@"Failure accessing Keychain Stack Trace:%@", [NSThread callStackSymbols]);
	}
}


- (void)removeValueForIdentifier:(NSString *)identifier
{
	NSMutableDictionary *valueQuery = [[NSMutableDictionary alloc] init];
  
  [valueQuery setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
  [valueQuery setObject:identifier forKey:(__bridge id)kSecAttrGeneric];
  [valueQuery setObject:identifier forKey:(__bridge id)kSecAttrService];
  
  
#if !TARGET_IPHONE_SIMULATOR
  
  NSString *keychainAccessGroup = [self valueForApplicationConfigurationKey:@"KeychainAccessGroup"];
  
  [valueQuery setObject:keychainAccessGroup forKey:(__bridge id)kSecAttrAccessGroup];
  
#endif
  
  
  OSStatus keychainStatus = SecItemDelete((__bridge CFDictionaryRef) valueQuery);
  
  
  if (keychainStatus != errSecSuccess && keychainStatus !=  errSecItemNotFound) 
	{
    NSLog(@"Failure deleting Identifier:%@ on Keychain Stack Trace:%@", identifier, [NSThread callStackSymbols]);
	}
}


#pragma mark -
#pragma mark Get Configuration Key


- (NSString *)valueForApplicationConfigurationKey:(NSString *)configurationKey
{
  NSString * configurationFilePath = [[NSBundle mainBundle] pathForResource:@"AppConfiguration" ofType:@"plist"];
  
  NSDictionary * configuration = [NSDictionary dictionaryWithContentsOfFile:configurationFilePath];
  
  return [configuration objectForKey:configurationKey];
}



@end
