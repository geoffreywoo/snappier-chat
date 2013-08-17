//
//  SplashViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController
{
    IBOutlet UIButton *registerButton;
    IBOutlet UIButton *loginButton;
}

-(IBAction) registerButton:(id) sender;
-(IBAction) loginButton:(id) sender;

@end
