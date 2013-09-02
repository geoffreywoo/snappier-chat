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
        sendButton.hidden = YES;
    }
    return self;
}

-(id)initWithToro:(Toro*)toro {
    self = [super initWithNibName:@"FriendListViewController" bundle:nil];
    if (self) {
        _toro = toro;
        sendButton.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    friendTableView.delegate = self;
    friendTableView.dataSource = self;
}

- (void)checkSendButton {
    if ([self sendable]) {
        NSLog(@"sendable");
        sendButton.hidden = NO;
//        [self.view bringSubviewToFront:sendButton];
    } else {
        NSLog(@"not sendable");
        sendButton.hidden = YES;
    }
}

- (BOOL)sendable {
    if ( (_toro != nil) && ([[[OtoroConnection sharedInstance] selectedFriends] count] > 0) ) {
        return YES;
    }
    return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[OtoroConnection sharedInstance] getAllFriendsWithCompletionBlock:^(NSError *error, NSDictionary *data){
        if (error) {
            
        } else {
            NSLog(@"loaded");
            _friends = [[OtoroConnection sharedInstance] friends];
            [friendTableView reloadData];
        }
    }];
    [self checkSendButton];
}

-(IBAction) back:(id) sender {
    //[self.view removeFromSuperview];
    [[self navigationController] popViewControllerAnimated:YES];
}

static int NUM_SENT;

- (void) checkIfAllSent {
    if (NUM_SENT < [[[OtoroConnection sharedInstance] selectedFriends] count]) {
        NSLog(@"waiting for other calls");
    } else {
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }
}

-(IBAction) send:(id) sender {
    NUM_SENT = 0;
    [_toro print];
    _toro.sender = [[OtoroConnection sharedInstance] user].username;
    for (OUser *selectedFriend in [[OtoroConnection sharedInstance] selectedFriends]) {
        _toro.receiver = selectedFriend.username;
        [[OtoroConnection sharedInstance] createNewToro:_toro completionBlock:^(NSError *error, NSDictionary *returnData) {
            if (error) {
                
            } else {
                NUM_SENT++;
                [self checkIfAllSent];
            }
        }];
    }
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
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    [[[OtoroConnection sharedInstance] selectedFriends] addObject:f];
    [self checkSendButton];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    OUser *f = [[self friends] objectAtIndex:[indexPath row]];
    [[[OtoroConnection sharedInstance] selectedFriends] removeObject:f];
    [self checkSendButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
