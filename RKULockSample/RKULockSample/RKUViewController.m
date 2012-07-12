//
//  RKUViewController.m
//  RKULockSample
//
//  Created by Erick Camacho on 11/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKUViewController.h"


@interface RKUViewController ()

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

- (void)enableLogin;

- (void)disableLogin;


@end

@implementation RKUViewController

@synthesize loginButton = _loginButton;
@synthesize logoutButton = _logoutButton;
@synthesize sessionManager = _sessionManager;

- (void)viewDidLoad
{
  [super viewDidLoad];

	[self.sessionManager setDelegate:self];
  
  if ( [self.sessionManager configureService:@"facebook" 
                                       using:[NSDictionary dictionaryWithObject:@"120624561408332" 
                                                                         forKey:@"AppId"]] ) {
    if ([self.sessionManager isAuthenticatedInService:@"facebook"]) {
      [self disableLogin];
    }
    else {
      [self enableLogin];
    }
  }
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)loginWithFacebook:(id)sender
{
  
  [self.sessionManager authenticateWithServiceName:@"facebook"];
  
}

- (IBAction)logoutFromFacebook:(id)sender
{
  [self.sessionManager logoutFromService:@"facebook"];
}

#pragma mark - RKUSession delegate methods
- (void)sessionManager:(RKUSessionManager *)sessionManager didAuthenticate:(BOOL)didAuthenticate
{
  if (didAuthenticate) {
    [self showAlertWithTitle:@"Authenticated" andMessage:@"The user was authenticated"];
    [self disableLogin];
  } else {
    [self showAlertWithTitle:@"Error" andMessage:@"The user was not authenticated"];
    [self enableLogin];
  }
  
  
}

- (void)sessionManager:(RKUSessionManager *)sessionManager didLogout:(BOOL)didLogout
{
  if (didLogout) {
    [self showAlertWithTitle:@"Error" andMessage:@"The user was logged out"];
    [self enableLogin];
  } else {
    [self showAlertWithTitle:@"Error" andMessage:@"The user was not logged out"];
    [self disableLogin];
  }
  
}

- (void)sessionManager:(RKUSessionManager *)sessionManager didFailWithError:(NSError *)error
{
  NSLog(@"%@", self.sessionManager.lastError);
  [self showAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
}

#pragma mark - Utility methods
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
                                                  message:message 
                                                 delegate:nil 
                                        cancelButtonTitle:@"Ok" 
                                        otherButtonTitles:nil];
  [alert show];
}

- (void)enableLogin
{
  [self.loginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
  [self.loginButton setHidden:NO];
  [self.logoutButton setHidden:YES];
}

- (void)disableLogin
{
  [self.logoutButton setTitle:@"Logout from Facebook" forState:UIControlStateNormal];
  [self.loginButton setHidden:YES];
  [self.logoutButton setHidden:NO];
}

@end
