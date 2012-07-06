//
//  RKUFacebookConnectAuthPlugIn.h
//  RKULock
//
//  Created by Erick Camacho on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "Facebook.h"
#import "RKUAuthPlugIn.h"
#import "RKUAuthPluginDelegate.h"

@interface RKUFacebookConnectAuthPlugIn : NSObject <RKUAuthPlugIn, FBSessionDelegate>

@property (nonatomic, weak) id<RKUAuthPlugInDelegate> delegate;


@end