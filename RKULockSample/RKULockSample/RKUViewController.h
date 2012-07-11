//
//  RKUViewController.h
//  RKULockSample
//
//  Created by Erick Camacho on 11/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RKUSessionManager.h"

#import "RKUSessionManagerDelegate.h"
@interface RKUViewController : UIViewController <RKUSessionManagerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) IBOutlet UIButton *logoutButton;

@property (nonatomic, strong) RKUSessionManager *sessionManager;

- (IBAction)loginWithFacebook:(id)sender;

- (IBAction)logoutFromFacebook:(id)sender;

@end
