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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction) registerButton:(id) sender {
    NSLog(@"register button hit");
    
    [[OtoroConnection sharedInstance] loginWithUsername:usernameField.text password:passwordField.text completionBlock:^(NSError *error, NSDictionary *returnData) {
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [emailField resignFirstResponder];
    [phoneField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
