//
//  FriendListViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "FriendListViewController.h"
#import "PufferConnection.h"
#import "AddFriendsViewController.h"
#import "OUser.h"

@interface FriendListViewController ()
@property (nonatomic, assign) BOOL userWantsSend;
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

-(id)initWithToro:(Puffer*)toro delegate:(id<FriendListViewControllerDelegate>)delegate
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

    _friends = [[PufferConnection sharedInstance] friends];
    [friendTableView reloadData];

    [self hideSpinner];
}

- (void)hideSpinner
{
    spinner.hidden = YES;
    spinnerLabel.hidden = YES;
    [spinner stopAnimating];
    [self toggleInstructionLabel];
}

- (void)showSpinner
{
    spinner.hidden = NO;
    [spinner startAnimating];
    spinnerLabel.hidden = NO;
    addFriendsLabel.hidden = YES;
    selectFriendsLabel.hidden = YES;
    addVenueOrMessageLabel.hidden = YES;
}

- (void)toggleInstructionLabel
{
    if ([[[PufferConnection sharedInstance] friends] count] == 0) {
        addFriendsLabel.hidden = NO;
        selectFriendsLabel.hidden = YES;
        addVenueOrMessageLabel.hidden = YES;
    } else if (!self.toroIsValid) {
        addFriendsLabel.hidden = YES;
        selectFriendsLabel.hidden = YES;
        addVenueOrMessageLabel.hidden = NO;
    } else {
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
    if (self.toroIsValid && [[[PufferConnection sharedInstance] selectedFriends] count] > 0) {
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
	
    [[PufferConnection sharedInstance] getAllFriendsWithCompletionBlock:^(NSError *error, NSDictionary *data){
        if (error) {
            
        } else {
            NSLog(@"loaded");
            _friends = [[PufferConnection sharedInstance] friends];
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

- (IBAction)send:(id) sender {
    NSLog(@"send tapped");
    [self showSpinner];
	self.userWantsSend = YES;
	[self checkToroSend];
}

- (void)imageDidFinishUpload:(UIImage *)image withKey:(NSString *)imageKey
{
	if (self.toro.image == image)
	{
		self.toro.imageKey = imageKey;
		[self checkToroSend];
	}
}

- (void)checkToroSend
{
	if (_toro.imageKey && self.userWantsSend)
	{
		NSLog(@"SENDING TORO");
		_toro.sender = [[PufferConnection sharedInstance] user].username;
		[[PufferConnection sharedInstance] createNewToro:_toro toReceivers:[[PufferConnection sharedInstance] selectedFriends] completionBlock:^(NSError *error, NSDictionary *returnData) {
            [self hideSpinner];
			if (error) {
				NSLog(@"send error");
                [self.delegate friendListViewController:self didSendToro:self.toro];
			} else {
                NSLog(@"send complete");
				[self.delegate friendListViewController:self didSendToro:self.toro];
			}
		}];
	}
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
		[[[PufferConnection sharedInstance] selectedFriends] addObject:f];
		[self checkSendButton];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    OUser *f = [[self friends] objectAtIndex:[indexPath row]];
    [[[PufferConnection sharedInstance] selectedFriends] removeObject:f];
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
