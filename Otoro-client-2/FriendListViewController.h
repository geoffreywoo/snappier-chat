//
//  FriendListViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toro.h"
#import "AddFriendsViewController.h"

@interface FriendListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *addFriendsButton;
    IBOutlet UIButton *sendButton;
    IBOutlet UITableView *friendTableView;
}
@property (nonatomic, strong) AddFriendsViewController *addFriendsViewController;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) Toro *toro;

-(id)initWithToro: (Toro*)toro;

-(IBAction) back:(id) sender;
-(IBAction) addFriends:(id) sender;
-(IBAction) send:(id) sender;

@end
