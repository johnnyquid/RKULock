//
//  RKUFacebookConnectAuthPlugIn.h
//  RKULock
//
//  Created by Erick Camacho on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "Facebook.h"
#import "RKUAuthStore.h"
#import "RKUAuthPlugIn.h"
#import "RKUAuthPluginDelegate.h"

@interface RKUFacebookConnectAuthPlugIn : NSObject <RKUAuthPlugIn, FBSessionDelegate>

@property (nonatomic, strong) id<RKUAuthPlugInDelegate> delegate;

@property (nonatomic, strong) id<RKUAuthStore> authStore;

@property (nonatomic, strong) NSError *configurationError;

@end
