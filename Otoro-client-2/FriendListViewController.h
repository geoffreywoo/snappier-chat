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

@class FriendListViewController;
@protocol FriendListViewControllerDelegate <NSObject>
- (void)friendListViewController:(FriendListViewController *)viewController didSendToro:(Toro *)toro;
@end

@interface FriendListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UINavigationBar *navBar;
	IBOutlet UILabel *title;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *addFriendsButton;
    IBOutlet UIButton *sendButton;
    IBOutlet UILabel *addFriendsLabel;
    IBOutlet UILabel *selectFriendsLabel;
    IBOutlet UILabel *addVenueOrMessageLabel;
    IBOutlet UITableView *friendTableView;
}
@property (nonatomic, strong) AddFriendsViewController *addFriendsViewController;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) Toro *toro;
@property (nonatomic, weak) id<FriendListViewControllerDelegate>delegate;

-(id)initWithToro: (Toro*)toro delegate:(id<FriendListViewControllerDelegate>)delegate;

-(IBAction) back:(id) sender;
-(IBAction) addFriends:(id) sender;
-(IBAction) send:(id) sender;
-(void)imageDidFinishUpload:(UIImage *)image withKey:(NSString *)imageKey;

@end
