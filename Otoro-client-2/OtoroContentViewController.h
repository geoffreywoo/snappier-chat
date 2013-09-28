//
//  OtoroContentViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/4/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateToroViewController.h"
#import "SettingsViewController.h"

@interface OtoroContentViewController : UIViewController
{
    IBOutlet UITableView *toroTableView;
}

@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSMutableArray *torosReceived;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CreateToroViewController *createToroViewController;
@property (nonatomic, strong) SettingsViewController *settingsViewController;


-(IBAction) toTakeToroView:(id) sender;
-(IBAction) toSettingsView:(id) sender;
@end
