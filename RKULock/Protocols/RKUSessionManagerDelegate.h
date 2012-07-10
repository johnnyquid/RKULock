//
//  RKUSessionManagerDelegate.h
//  RKULock
//
//  Created by Erick Camacho on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKUSessionManager;

@protocol RKUSessionManagerDelegate <NSObject>

- (void)sessionManager:(RKUSessionManager *)sessionManager didAuthenticate:(BOOL)didAuthenticate;

- (void)sessionManager:(RKUSessionManager *)sessionManager didLogout:(BOOL)didLogout;

- (void)sessionManager:(RKUSessionManager *)sessionManager didFailWithError:(NSError *)error;

@end
