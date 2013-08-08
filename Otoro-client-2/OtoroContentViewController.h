//
//  OtoroContentViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/4/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToroViewController.h"

@interface OtoroContentViewController : UIViewController 
{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UIBarButtonItem *toTakeToroViewButton;
    IBOutlet UIBarButtonItem *toSettingsViewButton;
    IBOutlet UITableView *toroTableView;
}
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSMutableArray *torosReceived;
@property (nonatomic, strong) ToroViewController *toroViewController;
@property (nonatomic, strong) NSTimer *timer;

@end
