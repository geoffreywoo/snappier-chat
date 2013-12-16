//
//  RegistrationViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "RegistrationViewController.h"
#import "PufferConnection.h"
#import "PufferContentViewController.h"
#import "OAppDelegate.h"
#import "OUser.h"

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

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:232.0/255.0 green:142.0/255.0 blue:38.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(registerButton:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(IBAction) registerButton:(id) sender {
    NSLog(@"register button hit");
    
    if (![self isValid]) {
        return;
    }
    
    [[PufferConnection sharedInstance] createNewUserWithUsername:usernameField.text password:passwordField.text email: emailField.text phone:phoneField.text completionBlock:^(NSError *error, NSDictionary *returnData) {
        if (error) {
            NSLog(@"logged in response: %@",error);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Failed"
                                                            message:error.domain
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            usernameField.text = @"";
            passwordField.text = @"";
            [usernameField resignFirstResponder];
            
        } else {
            NSLog(@"logged in response: %@",returnData);
            OUser *me = [[OUser alloc]initWith:[returnData objectForKey:@"user"] ];
            [[PufferConnection sharedInstance] setUser: me];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject: [me username] forKey:@"username"];
            [defaults setObject: [me email] forKey:@"email"];
            [defaults setObject: [me phone] forKey:@"phone"];
            [defaults synchronize];
            
            PufferContentViewController *rootViewController = [[PufferContentViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
            navigationController.navigationBarHidden = YES;
            
            OAppDelegate *delegate = (OAppDelegate *)[[UIApplication sharedApplication] delegate];
            delegate.window.rootViewController = navigationController;
            [delegate.window makeKeyAndVisible];
        }
    }];
}

-(BOOL) isValid {
    if (usernameField.text.length < 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Username is too short."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if (passwordField.text.length < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Password is too short."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if (![self validateEmail:emailField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Enter a valid email."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    } else {
        return YES;
    }
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
