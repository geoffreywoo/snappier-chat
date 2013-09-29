//
//  SplashViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrationViewController.h"

@interface SplashViewController : UIViewController
{
    IBOutlet UIButton *registerButton;
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIButton *loginButton;
}
@property (nonatomic, strong) RegistrationViewController *registrationViewController;

-(IBAction) registerButton:(id) sender;

@end
