//
//  SplashViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

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
    NSLog(@"register");
    
    if (_registrationViewController == nil) {
        _registrationViewController = [[RegistrationViewController alloc] init];
    }
    
    [self.view addSubview:_registrationViewController.view];
}

-(IBAction) loginButton:(id) sender {
    NSLog(@"login");
    
    if (_loginViewController == nil) {
        _loginViewController = [[LoginViewController alloc] init];
    }
    
    [self.view addSubview:_loginViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
