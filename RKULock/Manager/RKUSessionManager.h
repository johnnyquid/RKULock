//
//  RKUSessionManager.h
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RKUAuthPluginDelegate.h"

#import "RKUSessionManagerDelegate.h"

@interface RKUSessionManager : NSObject <RKUAuthPlugInDelegate>

@property (nonatomic, strong, readonly) NSArray *pluginClasses;
@property (nonatomic, assign, readonly) Class currentAuthPluginClass;
@property (nonatomic, weak) id<RKUSessionManagerDelegate> delegate;

+ (id)sharedInstance;

- (NSArray *)findAuthPluginClassesByConventionAndProtocol;

- (void)authenticateWithServiceName:(NSString *)serviceName 
                 usingConfiguration:(NSDictionary *)configuration;

- (BOOL)handleOpenURLForAuthentication:(NSURL *)url;
@end
