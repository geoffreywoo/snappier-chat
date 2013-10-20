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
        //sendButton.hidden = YES;
    }
    return self;
}

-(id)initWithToro:(Toro*)toro delegate:(id<FriendListViewControllerDelegate>)delegate
{
    self = [super initWithNibName:@"FriendListViewController" bundle:nil];
    if (self) {
		_delegate = delegate;
        _toro = toro;
        //sendButton.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    friendTableView.delegate = self;
    friendTableView.dataSource = self;
    sendButton.hidden = YES;
    addFriendsLabel.hidden = YES;
    selectFriendsLabel.hidden = YES;
    addVenueOrMessageLabel.hidden = YES;
    
    _friends = [[OtoroConnection sharedInstance] friends];
    [friendTableView reloadData];
}

- (void)toggleInstructionLabel
{
    if ([[[OtoroConnection sharedInstance] friends] count] == 0)
    {
        addFriendsLabel.hidden = NO;
        selectFriendsLabel.hidden = YES;
        addVenueOrMessageLabel.hidden = YES;
    } else if (!self.toroIsValid)
    {
        addFriendsLabel.hidden = YES;
        selectFriendsLabel.hidden = YES;
        addVenueOrMessageLabel.hidden = NO;
    } else
    {
        addFriendsLabel.hidden = YES;
        selectFriendsLabel.hidden = NO;
        addVenueOrMessageLabel.hidden = YES;
    }
}

- (void)checkSendButton {
    if ([self sendable]) {
        NSLog(@"sendable");
        sendButton.hidden = NO;
        addFriendsLabel.hidden = YES;
        addVenueOrMessageLabel.hidden = YES;
        selectFriendsLabel.hidden = YES;
    } else {
        NSLog(@"not sendable");
        sendButton.hidden = YES;
        [self toggleInstructionLabel];
    }
}

- (BOOL)sendable {
    if (self.toroIsValid && [[[OtoroConnection sharedInstance] selectedFriends] count] > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)toroIsValid
{
	return self.toro && self.toro.image;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
    [[OtoroConnection sharedInstance] getAllFriendsWithCompletionBlock:^(NSError *error, NSDictionary *data){
        if (error) {
            
        } else {
            NSLog(@"loaded");
            _friends = [[OtoroConnection sharedInstance] friends];
            [friendTableView reloadData];
			[self checkSendButton];
        }
    }];
    [self checkSendButton];
	
	if (self.toroIsValid)
	{
		[title setText:@"Send Snapper"];
	}
	else
	{
		[title setText:@"My Friends"];
	}
}

-(IBAction) back:(id) sender {
    //[self.view removeFromSuperview];
    [[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction) send:(id) sender {
    NSLog(@"SENDING TORO");

    _toro.sender = [[OtoroConnection sharedInstance] user].username;
	[[OtoroConnection sharedInstance] createNewToro:_toro toReceivers:[[OtoroConnection sharedInstance] selectedFriends] completionBlock:^(NSError *error, NSDictionary *returnData) {
		if (error) {
			
		} else {
			[self.delegate friendListViewController:self didSendToro:self.toro];
		}
	}];
}

-(IBAction) addFriends:(id) sender {
    //NSLog(@"add friends view");
    
    if (_addFriendsViewController == nil) {
        _addFriendsViewController = [[AddFriendsViewController alloc] init];
    }
    [[self navigationController] pushViewController:_addFriendsViewController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
    //    NSLog(@"%d",[ [self friends] count]);
        return [ [self friends] count];
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"header";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"cellForRowAtIndexPath");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendViewCell"];

    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendViewCell"];
    }
    
    OUser *f = [[self friends] objectAtIndex:[indexPath row]];
    //NSLog(@"%@",f);
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [f username]];
    if (self.toroIsValid && f.selected) {
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
    CG=Rect frame = cell.frame;
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
	if (self.toroIsValid)
	{
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		OUser *f = [[self friends] objectAtIndex:[indexPath row]];
		[[[OtoroConnection sharedInstance] selectedFriends] addObject:f];
		[self checkSendButton];
	}
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

- (void)viewDidUnload {
	[super viewDidUnload];
}
@end
