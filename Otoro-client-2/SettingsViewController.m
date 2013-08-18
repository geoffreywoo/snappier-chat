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
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
