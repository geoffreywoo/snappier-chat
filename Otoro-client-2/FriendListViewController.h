//
//  FriendListViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Puffer.h"
#import "AddFriendsViewController.h"

@class FriendListViewController;
@protocol FriendListViewControllerDelegate <NSObject>
- (void)friendListViewController:(FriendListViewController *)viewController didSendToro:(Puffer *)toro;
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
    
    IBOutlet UILabel *spinnerLabel;
    IBOutlet UIActivityIndicatorView  *spinner;
    
}
@property (nonatomic, strong) AddFriendsViewController *addFriendsViewController;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) Puffer *toro;
@property (nonatomic, weak) id<FriendListViewControllerDelegate>delegate;

-(id)initWithToro: (Puffer*)toro delegate:(id<FriendListViewControllerDelegate>)delegate;

-(IBAction) back:(id) sender;
-(IBAction) addFriends:(id) sender;
-(IBAction) send:(id) sender;
-(void)imageDidFinishUpload:(UIImage *)image withKey:(NSString *)imageKey;

@end
