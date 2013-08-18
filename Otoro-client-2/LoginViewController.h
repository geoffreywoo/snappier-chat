//
//  LoginViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *backButton;
}

-(IBAction) login:(id) sender;
-(IBAction) back:(id) sender;

@end
