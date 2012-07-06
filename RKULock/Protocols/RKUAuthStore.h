//
//  RKUAuthStore.h
//  RKULock
//
//  Created by Erick Camacho on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RKUAuthStore <NSObject>

- (NSString *)tokenWithServiceName:(NSString *)serviceName;

- (void)setToken:(NSString *)token withServiceName:(NSString *)serviceName;

- (void)removeTokenWithServiceName:(NSString *)serviceName;

- (NSDate *)tokenExpirationDateWithServiceName:(NSString *)serviceName;

- (void)setTokenExpirationDate:(NSDate *)tokenExpirationDate withServiceName:(NSString *)serviceName;

- (void)removeTokenExpirationDateWithServiceName:(NSString *)serviceName;


@end
