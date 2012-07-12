//
//  NSError+RKULock.m
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSError+RKULock.h"

@implementation NSError (RKULock)

+ (NSError *)configurationError
{
    NSMutableDictionary *descriptionDictionary = [NSMutableDictionary dictionary];
    NSString * errorDescription = NSLocalizedStringFromTable(@"INKConfigurationError", @"LocalizedStrings", nil);
    [descriptionDictionary setObject:errorDescription forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:@"RKULock" code:1 userInfo:descriptionDictionary];
}


+ (NSError *)configurationErrorWithMessage:(NSString *)message
{
  NSMutableDictionary *descriptionDictionary = [NSMutableDictionary dictionary];

  NSString * errorDescription = [NSString stringWithFormat:@"%@: %@",
                                 NSLocalizedStringFromTable(@"INKConfigurationError", @"LocalizedStrings", nil), 
                                 message];
  
  [descriptionDictionary setObject:errorDescription forKey:NSLocalizedDescriptionKey];
  
  return [NSError errorWithDomain:@"RKULock" code:5 userInfo:descriptionDictionary];
}


+ (NSError *)serviceNotFoundError:(NSString *)serviceName
{
  NSMutableDictionary *descriptionDictionary = [NSMutableDictionary dictionary];
  NSString * errorDescription = [NSString stringWithFormat:@"%@: %@",
                                   NSLocalizedStringFromTable(@"INKNotFoundError", @"LocalizedStrings", nil), serviceName];

  [descriptionDictionary setObject:errorDescription forKey:NSLocalizedDescriptionKey];
    
  return [NSError errorWithDomain:@"RKULock" code:11112 userInfo:descriptionDictionary];
}


+ (NSError *)plugInNotConfiguredError
{
    NSMutableDictionary *descriptionDictionary = [NSMutableDictionary dictionary];
    NSString * errorDescription = NSLocalizedStringFromTable(@"INKNotConfiguredPlugInError", @"LocalizedStrings", nil);
    [descriptionDictionary setObject:errorDescription forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:@"RKULock" code:3 userInfo:descriptionDictionary];
}


+ (NSError *)sessionManagerGenericError
{
  NSMutableDictionary *descriptionDictionary = [NSMutableDictionary dictionary];
  NSString * errorDescription = NSLocalizedStringFromTable(@"INKGenericError", @"LocalizedStrings", nil);
  [descriptionDictionary setObject:errorDescription forKey:NSLocalizedDescriptionKey];

  return [NSError errorWithDomain:@"RKULock" code:4 userInfo:descriptionDictionary];
}


@end
