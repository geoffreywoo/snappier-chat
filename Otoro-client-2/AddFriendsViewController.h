//
//  AddFriendsViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/18/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "AddressBookViewController.h"
#import "AddedYouViewController.h"

@interface AddFriendsViewController : UIViewController {
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIButton *addedYou;
    IBOutlet UIButton *contacts;
    IBOutlet UIButton *search;
    IBOutlet UIView *subview2;
}

//@property (nonatomic, strong) IBOutlet SearchFriendView *searchFriendView;
@property (nonatomic, strong) SearchViewController *searchViewController;
@property (nonatomic, strong) AddressBookViewController *addressBookViewController;
@property (nonatomic, strong) AddedYouViewController *addedYouViewController;

-(IBAction) backButton:(id) sender;
-(IBAction) addedYouButton:(id) sender;
-(IBAction) contactsButton:(id) sender;
-(IBAction) searchButton:(id) sender;

@end
