//
//  FriendListViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "FriendListViewController.h"
#import "OtoroConnection.h"
#import "AddFriendsViewController.h"
#import "OUser.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    friendTableView.delegate = self;
    friendTableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[OtoroConnection sharedInstance] getAllFriendsWithCompletionBlock:^(NSError *error, NSDictionary *data){
        if (error) {
            
        } else {
            NSLog(@"loaded");
            _friends = [[NSMutableArray alloc] init];
            NSDictionary *elems = data[@"elements"][0];
            NSArray *friends = elems[@"friends"];
            for (int i = 0; i < [friends count]; i++) {
                OUser *f = [[OUser alloc] initWithUsername:friends[i]];
                NSLog(@"friend: %@",f);
                [f debugPrint];
                [_friends addObject:f];
            }
            
            [[OtoroConnection sharedInstance] setFriends:_friends];
            [friendTableView reloadData];
        }
    }];
}

-(IBAction) back:(id) sender {
    [self.view removeFromSuperview];
}

-(IBAction) addFriends:(id) sender {
    NSLog(@"add friends view");
    
    if (_addFriendsViewController == nil) {
        _addFriendsViewController = [[AddFriendsViewController alloc] init];
    }
    
    [self.view addSubview:_addFriendsViewController.view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSLog(@"%d",[ [self friends] count]);
        return [ [self friends] count];
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"header";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellForRowAtIndexPath");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendViewCell"];

    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendViewCell"];
    }
    
    OUser *f = [[self friends] objectAtIndex:[indexPath row]];
    NSLog(@"%@",f);
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [f username]];
    if (f.selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*
    UIButton *button = [[UIButton alloc] init];
    button.tag = indexPath.row;
    CGRect frame = cell.frame;
    [button setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
    [button addTarget:self action:@selector(toggleFriend:) forControlEvents: UIControlEventTouchDown];
    [cell addSubview:button];
     */
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)toggleFriend:(id)sender {
   // sender.tag
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    OUser *f = [[self friends] objectAtIndex:[indexPath row]];
    f.selected = YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    OUser *f = [[self friends] objectAtIndex:[indexPath row]];
    f.selected = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
