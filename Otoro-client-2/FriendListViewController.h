//
//  FriendListViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListViewController : UIViewController
{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UITableView *friendTableView;
}

@property (nonatomic, strong) NSMutableArray *friends;

@end
