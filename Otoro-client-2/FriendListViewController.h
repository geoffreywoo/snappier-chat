//
//  FriendListViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFriendsViewController.h"

@interface FriendListViewController : UIViewController
{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *addFriendsButton;
    IBOutlet UITableView *friendTableView;
}
@property (nonatomic, strong) AddFriendsViewController *addFriendsViewController;
@property (nonatomic, strong) NSMutableArray *friends;

-(IBAction) back:(id) sender;
-(IBAction) addFriends:(id) sender;

@end
