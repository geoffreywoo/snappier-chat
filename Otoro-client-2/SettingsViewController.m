//
//  SettingsViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SettingsViewController.h"
#import "SplashViewController.h"
#import "OAppDelegate.h"
#import "OtoroConnection.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	self.usernameTextField.text = [defaults objectForKey:@"username"];
	self.emailTextField.text = [defaults objectForKey:@"email"];
	self.phoneTextField.text = [defaults objectForKey:@"phone"];
}

-(IBAction) logout:(id) sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: nil forKey:@"username"];
    [defaults synchronize];
    
    SplashViewController *splashViewController = [[SplashViewController alloc] init];
    OAppDelegate *delegate = (OAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = splashViewController;
    [delegate.window makeKeyAndVisible];
}

-(IBAction) back:(id) sender {
    [[self navigationController] popViewControllerAnimated:YES];
	
	[[OtoroConnection sharedInstance] updateUserEmail:self.emailTextField.text phone:self.phoneTextField.text completionBlock:^(NSError *error, NSDictionary *dict)
	 {
		 if (error)
		 {
			 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error saving your info, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			 [alert show];
		 }
		 else
		 {
			 [OtoroConnection sharedInstance].user.phone = self.phoneTextField.text;
			 [OtoroConnection sharedInstance].user.email = self.emailTextField.text;
			 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

			 [defaults setObject:self.emailTextField.text forKey:@"email"];
			 [defaults setObject:self.phoneTextField.text forKey:@"phone"];
		 }
	 }];
}
@end
