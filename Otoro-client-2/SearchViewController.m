//
//  SearchFriendViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SearchViewController.h"
#import "OtoroConnection.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isSearching = NO;
    filteredList = [[NSMutableArray alloc] init];
    list = [[NSMutableArray alloc] init];

}

-(void)viewDidAppear:(BOOL)animated  {
    [self.searchDisplayController.searchBar becomeFirstResponder];
}


- (void)filterListForSearchText:(NSString *)searchText
{
    [filteredList removeAllObjects]; //clears the array from all the string objects it might contain from the previous searches
    
    for (NSString *title in list) {
        NSRange nameRange = [title rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound) {
            [filteredList addObject:title];
        }
    }
    [filteredList addObject:searchText];
}

#pragma mark - UISearchDisplayControllerDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    //When the user taps the search bar, this means that the controller will begin searching.
    isSearching = YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    //When the user taps the Cancel Button, or anywhere aside from the view.
    isSearching = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterListForSearchText:searchString]; // The method we made in step 7
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterListForSearchText:[self.searchDisplayController.searchBar text]]; // The method we made in step 7
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (isSearching) {
        //If the user is searching, use the list in our filteredList array.
        return [filteredList count];
    } else {
        return [list count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SearchViewCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString *title;
    if (isSearching && [filteredList count]) {
        //If the user is searching, use the list in our filteredList array.
        title = [NSString stringWithFormat:@"Add \"%@\"",[filteredList objectAtIndex:indexPath.row]];
    } else {
        title = [list objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = title;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // If you want to push another view upon tapping one of the cells on your table.
    if (isSearching && [filteredList count]) {
        //If the user is searching, use the list in our filteredList array.
        [[OtoroConnection sharedInstance] addFriendWithUserID:[filteredList objectAtIndex:indexPath.row] completionBlock:^(NSError *error, NSDictionary *returnData) {
            if (error) {
                NSLog(@"Error: %@",error);
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [tableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"Add \"%@\"",[filteredList objectAtIndex:indexPath.row]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Adding friend failed"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            } else {
                NSLog(@"Return Data: %@" ,returnData);
                bool ok = [[returnData objectForKey:@"ok"] boolValue];
                if (ok) {
                    NSArray *arr = [returnData objectForKey:@"elements"];
                    NSString *addedFriend = arr[0];
                    NSLog(@"added %@",addedFriend);
                    

                    
                } else {
                    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                    [tableView cellForRowAtIndexPath:indexPath].textLabel.text = [NSString stringWithFormat:@"Add \"%@\"",[filteredList objectAtIndex:indexPath.row]];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Adding friend failed"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }
        }];
  
    }
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView cellForRowAtIndexPath:indexPath].textLabel.text = [filteredList objectAtIndex:indexPath.row];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
