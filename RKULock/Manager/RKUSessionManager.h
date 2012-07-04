//
//  RKUSessionManager.h
//  RKULock
//
//  Created by Luis Alberto Hernández Guzmán on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKUSessionManager : NSObject

@property (nonatomic, strong, readonly) NSArray *pluginClasses;
@property (nonatomic, assign, readonly) Class currentAuthPluginClass;


+ (id)sharedInstance;

- (NSArray *)findAuthPluginClassesByConventionAndProtocol;
- (void)authenticateWithServiceName:(NSString *)serviceName;

@end
