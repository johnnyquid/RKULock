//
//  NSError+RKULock.h
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (RKULock)

+ (NSError *)configurationError;
+ (NSError *)configurationErrorWithMessage:(NSString *)message;
+ (NSError *)serviceNotFoundError:(NSString *)serviceName;
+ (NSError *)plugInNotConfiguredError;
+ (NSError *)sessionManagerGenericError;

@end
