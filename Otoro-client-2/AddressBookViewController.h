//
//  AddressBookViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *addressBookUsersTableView;
}

@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) NSMutableArray *alreadyFriends;
@property (nonatomic, strong) NSMutableArray *addressBookUsers;

@end
