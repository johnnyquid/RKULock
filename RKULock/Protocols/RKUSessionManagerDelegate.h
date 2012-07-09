//
//  RKUSessionManagerDelegate.h
//  RKULock
//
//  Created by Erick Camacho on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RKUSessionManagerDelegate <NSObject>

- (void)sessionManagerDidAuthenticateSuccesfulyInService:(NSString *)serviceName;

- (void)sessionManagerDidNotAuthenticateInService:(NSString *)serviceName;

- (void)sessionManagerInvalidConfiguration:(NSDictionary *)configuration forService:(NSString *)serviceName;

- (void)sessionManagerDidLogoutFromService:(NSString *)serviceName;

@end
