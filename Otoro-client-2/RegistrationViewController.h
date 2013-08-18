//
//  RegistrationViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController {
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *phoneField;
    IBOutlet UIButton *registerButton;
    IBOutlet UIButton *backButton;
}

-(IBAction) checkValidityOfRegistration:(id) sender;
-(IBAction) registerButton:(id) sender;
-(IBAction) back:(id) sender;

@end
