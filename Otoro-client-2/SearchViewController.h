//
//  SearchFriendViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
    BOOL isSearching;
    NSMutableArray *filteredList;
    NSMutableArray *list;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
