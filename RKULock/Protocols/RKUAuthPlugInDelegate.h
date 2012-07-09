//
//  RKUAuthPlugInDelegate.h
//  RKULock
//
//  Created by Erick Camacho on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RKUAuthPlugIn.h"

@protocol RKUAuthPlugInDelegate <NSObject>

- (void)authPlugin:(id<RKUAuthPlugIn>)authPlugin invalidConfiguration:(NSDictionary *)configuration;

- (void)authPluginDidAuthenticateSuccesfully:(id<RKUAuthPlugIn>)authPlugin;

- (void)authPluginDidNotAuthenticate:(id<RKUAuthPlugIn>)authPlugin;

- (void)authPluginDidLogout:(id<RKUAuthPlugIn>)authPlugin;

@end
