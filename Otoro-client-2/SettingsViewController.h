//
//  SettingsViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LegalViewController.h"

@interface SettingsViewController : UIViewController {
}

@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UIButton *privacy;
@property (nonatomic, weak) IBOutlet UIButton *terms;

@property (nonatomic, strong) LegalViewController *legalViewController;

-(IBAction) logout:(id) sender;
-(IBAction) back:(id) sender;
-(IBAction) privacy:(id) sender;
-(IBAction) terms:(id) sender;

@end
