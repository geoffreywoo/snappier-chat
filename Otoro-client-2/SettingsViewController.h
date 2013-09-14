//
//  SettingsViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController {
    __weak IBOutlet UIButton *logoutButton;
    __weak IBOutlet UIButton *backButton;
}

@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;


-(IBAction) logout:(id) sender;
-(IBAction) back:(id) sender;

@end
