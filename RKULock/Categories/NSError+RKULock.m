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
    NSMutableDictionary *descriptionDictionary;
    NSString * errorDescription = NSLocalizedStringFromTable(@"INKConfigurationError", @"LocalizedStrings", nil);
    [descriptionDictionary setObject:errorDescription forKey:@"NSLocalizedDescriptionKey"];
    
    return [NSError errorWithDomain:@"RKULock" code:1 userInfo:descriptionDictionary];
}


+ (NSError *)notFoundError
{
    NSMutableDictionary *descriptionDictionary;
    NSString * errorDescription = NSLocalizedStringFromTable(@"INKNotFoundError", @"LocalizedStrings", nil);
    [descriptionDictionary setObject:errorDescription forKey:@"NSLocalizedDescriptionKey"];
    
    return [NSError errorWithDomain:@"RKULock" code:2 userInfo:descriptionDictionary];
}


+ (NSError *)plugInNotConfiguredError
{
    NSMutableDictionary *descriptionDictionary;
    NSString * errorDescription = NSLocalizedStringFromTable(@"INKNotConfiguredPlugInError", @"LocalizedStrings", nil);
    [descriptionDictionary setObject:errorDescription forKey:@"NSLocalizedDescriptionKey"];
    
    return [NSError errorWithDomain:@"RKULock" code:3 userInfo:descriptionDictionary];
}

@end
