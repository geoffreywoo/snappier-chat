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

@interface SettingsViewController ()<UITextFieldDelegate>

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

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	self.usernameLabel.text = [NSString stringWithFormat:@"Username: %@",[defaults objectForKey:@"username"]];
	self.emailTextField.text = [defaults objectForKey:@"email"];
	self.phoneTextField.text = [defaults objectForKey:@"phone"];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[self.emailTextField resignFirstResponder];
	[self.phoneTextField resignFirstResponder];
}

-(IBAction) logout:(id) sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults stringForKey:@"username"];
    [defaults setObject: nil forKey:@"username"];
    [defaults synchronize];
    
    [OtoroConnection sharedInstance].friends = [[NSMutableArray alloc] init];
    [OtoroConnection sharedInstance].selectedFriends = [[NSMutableArray alloc] init];
    
    [[OtoroConnection sharedInstance] logoutWithUsername:username completionBlock:^(NSError *error, NSDictionary *returnData) {
    }];
    
    SplashViewController *rootViewController = [[SplashViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    navigationController.navigationBarHidden = YES;
    
    OAppDelegate *delegate = (OAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = navigationController;
    [delegate.window makeKeyAndVisible];
    
    
    
}
- (IBAction)backgroundTapped:(id)sender
{
	[self.emailTextField resignFirstResponder];
	[self.phoneTextField resignFirstResponder];
}

-(IBAction) back:(id) sender {
    [[self navigationController] popViewControllerAnimated:YES];
    
    if (self.emailTextField.text == nil)
        self.emailTextField.text = @"";
    if (self.phoneTextField.text == nil)
        self.phoneTextField.text = @"";
	
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

-(IBAction) privacy:(id) sender {
    if (_legalViewController == nil) {
        _legalViewController = [[LegalViewController alloc] init];
    }
    [[self navigationController] pushViewController:_legalViewController animated:YES];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://snappermap.com"]];
}
-(IBAction) terms:(id) sender {
    if (_legalViewController == nil) {
        _legalViewController = [[LegalViewController alloc] init];
    }
    [[self navigationController] pushViewController:_legalViewController animated:YES];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://snappermap.com"]];
}


@end
