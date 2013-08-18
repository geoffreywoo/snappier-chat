//
//  RegistrationViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "RegistrationViewController.h"
#import "OtoroConnection.h"
#import "OtoroContentViewController.h"
#import "OAppDelegate.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    registerButton.hidden = YES;
    [usernameField becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction) registerButton:(id) sender {
    NSLog(@"register button hit");

    
    
    [[OtoroConnection sharedInstance] createNewUserWithUsername:usernameField.text password:passwordField.text email: emailField.text phone:phoneField.text completionBlock:^(NSError *error, NSDictionary *returnData) {
        if (error) {
            
        } else {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults synchronize];
        }
    }];
    OtoroContentViewController *otoroViewController = [[OtoroContentViewController alloc] init];
    OAppDelegate *delegate = (OAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = otoroViewController;
    [delegate.window makeKeyAndVisible];
}

-(IBAction) back:(id) sender {
    [self.view removeFromSuperview];
}

-(IBAction) checkValidityOfRegistration:(id) sender {
    NSLog(@"checking validity");
    if (usernameField.text.length < 3) {
        registerButton.hidden = YES;
    } else if (passwordField.text.length < 4) {
        registerButton.hidden = YES;
    } else if (![self validateEmail:emailField.text]) {
        registerButton.hidden = YES;
    } else {
        registerButton.hidden = NO;
    }
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [emailField resignFirstResponder];
    [phoneField resignFirstResponder];
    
    [self checkValidityOfRegistration:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == usernameField) {
        NSLog(@"text field 1");
        [passwordField becomeFirstResponder];
    } else if (textField == passwordField) {
        NSLog(@"text field 2");
        [emailField becomeFirstResponder];
    } else if (textField == emailField) {
        NSLog(@"text field 3");
        [phoneField becomeFirstResponder];
    } else {
        NSLog(@"text field 4");
        [textField resignFirstResponder];
        [self registerButton:textField];
    }
    
    [self checkValidityOfRegistration:textField];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
