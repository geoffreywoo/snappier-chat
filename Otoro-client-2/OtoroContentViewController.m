//
//  OtoroContentViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/4/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "OtoroContentViewController.h"
#import "ToroViewController.h"
#import "Toro.h"
#import "CreateToroViewController.h"
#import "OtoroConnection.h"
#import "OtoroSentTableViewCell.h"
#import "OtoroReceivedTableViewCell.h"

@implementation OtoroContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _torosReceived = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    
    [toroTableView addSubview: self.refreshControl];
    [toroTableView registerNib:[UINib nibWithNibName:@"OtoroSentTableViewCell" bundle:nil] forCellReuseIdentifier: kOtoroSentTableViewCellIdentifier];
    [toroTableView registerNib:[UINib nibWithNibName:@"OtoroReceivedTableViewCell" bundle:nil] forCellReuseIdentifier: kOtoroReceivedTableViewCellIdentifier];
    
    [[OtoroConnection sharedInstance] getAllFriendsWithCompletionBlock:^(NSError *error, NSDictionary *data){
        if (error) {
            
        } else {
            NSLog(@"loaded friends");
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self handleRefresh];
}

- (void) handleRefresh
{   
    [[OtoroConnection sharedInstance] getAllTorosWithCompletionBlock:^(NSError *error, NSDictionary *data)
    {
        if (error)
        {
            [self.refreshControl endRefreshing];
        }
        else
        {
            _torosReceived = [[NSMutableArray alloc] init];
            for (int i = 0; i < [data[@"elements"] count]; i++) {
                Toro *toro = [[Toro alloc] initWith:data[@"elements"][i]];
               // NSLog(@"toro: %@",toro);
                //if (![_torosReceived containsObject:toro])
                    [_torosReceived addObject: toro];
            }
            [toroTableView reloadData];
            [self.refreshControl endRefreshing];

        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSLog(@"number toros recieved: %d",[ [self torosReceived] count]);
        return [ [self torosReceived] count]; 
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"header";
}

- (void) toroDead:(Toro*)toro
{
    [[toro timerLabel] setText:[NSString stringWithFormat:@""]];
}

- (void) makeTimerLabel:(Toro*)toro
{
    [[toro timerLabel] setFont:[UIFont systemFontOfSize:12]];
    if (![toro read])
        [[toro timerLabel] setText:[NSString stringWithFormat:@""]];
    else if ([toro read] && ([toro maxTime] == [toro elapsedTime]) ) {
        [self toroDead:toro];
    } else {
        int timeLeft = ([toro maxTime] - [toro elapsedTime]);
        [[toro timerLabel] setText:[NSString stringWithFormat:@"%d",timeLeft]];
    }
}

- (void) tick:(NSTimer*)timer
{
    Toro *toro = [timer userInfo];
    [toro setElapsedTime: [toro elapsedTime] + 1];
    if ([toro elapsedTime] < [toro maxTime]) {
        [self makeTimerLabel:toro];
        int timeLeft = ([toro maxTime] - [toro elapsedTime]);
        [[[toro toroViewController] countDown] setText:[NSString stringWithFormat:@"%d",timeLeft]];
    } else {
        [timer invalidate];
        [[toro toroViewController].view removeFromSuperview];
        
        [self toroDead:toro];
    }
}

- (Toro *)getToro:(NSString *) toroID
{
    Toro *theToro = nil;
    for (int i = 0; i < [_torosReceived count]; i++) {
        Toro *toro = [_torosReceived objectAtIndex:i];
        if ([[toro toroId] isEqualToString:toroID]) {
            theToro = toro;
            break;
        }
    }
    return theToro;
}

- (void) popToro:(UIButton*)sender
{
    //NSLog(@"pop toro!");
    Toro *theToro = [[self torosReceived] objectAtIndex:sender.tag];
    if (!theToro) return;
    
    [theToro.statusView setImage:[UIImage imageNamed: @"sushi_pin.png"]];
    
    if (![theToro read]) {
        [[OtoroConnection sharedInstance] setReadFlagForToroID:theToro.toroId completionBlock:^(NSError *error, NSDictionary *returnData) {
            if (error) {
            } else {
                NSLog(@"set read flag on %@", theToro.toroId);
            }
        }];
        
        [self.view addSubview:[theToro toroViewController].view];
        
        [theToro setTimer: [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:theToro repeats:YES]];
        [[theToro timerLabel] setText:[NSString stringWithFormat:@"%d",[theToro maxTime]]];
        [theToro setRead: true];
    } else if ([theToro elapsedTime] < [theToro maxTime]) {
        NSLog(@"pop toro, elapsed: %i, max: %i", [theToro elapsedTime], [theToro maxTime]);
        [self.view addSubview:[theToro toroViewController].view];
    }
}

- (void) hideToro:(UIButton*)sender 
{
    NSLog(@"hide Toro");
    Toro *theToro = [[self torosReceived] objectAtIndex:sender.tag];
    if (!theToro) return;
    if (![theToro toroViewController]) return;
    if (!([theToro toroViewController].view)) return;
    [[theToro toroViewController].view removeFromSuperview];
}

- (UITableViewCell *) createReceivedCellWithTableView:(UITableView*)tableView withToro:(Toro*)toro withIndex:(NSUInteger) index
{
    OtoroReceivedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOtoroReceivedTableViewCellIdentifier];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", [toro sender]];
    NSMutableString *timeLabelText = [NSMutableString stringWithString:[toro created_string]];
    cell.timeLabel.text = timeLabelText;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [toro setTimerLabel:cell.timerLabel];
    [self makeTimerLabel:toro];
    [cell addSubview: [toro timerLabel]];

    if ([toro read]) {
        [cell.statusView setImage:[UIImage imageNamed: @"sushi_pin.png"]];
    } else {
        [cell.statusView setImage:[UIImage imageNamed: @"snappermap_inapp_icon_small.png"]];
    }
    toro.statusView = cell.statusView;
    
    UIButton *button = [[UIButton alloc] init];
    button.tag = index;
    CGRect frame = cell.frame;

    [button setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
    [button addTarget:self action:@selector(popToro:) forControlEvents: UIControlEventTouchDown];
    
    [button addTarget:self action:@selector(hideToro:) forControlEvents: UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(hideToro:) forControlEvents: UIControlEventTouchUpOutside];
    
    [cell addSubview:button];
    return cell;
}

- (UITableViewCell *) createSentCellWithTableView:(UITableView*)tableView withToro:(Toro*)toro withIndex:(NSUInteger) index
{
    OtoroSentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOtoroSentTableViewCellIdentifier];
    cell.nameLabel.text = [toro receiver];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    cell.accessoryType = UITableViewCellAccessoryNone;

    if ( [toro read] ) {
        NSMutableString *timeLabelText = [NSMutableString stringWithString:[toro created_string]];
        [timeLabelText appendString:@" - Opened"];
        cell.timeLabel.text = timeLabelText;
    } else {
        NSMutableString *timeLabelText = [NSMutableString stringWithString:[toro created_string]];
        [timeLabelText appendString:@" - Delivered"];
        cell.timeLabel.text = timeLabelText;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Toro *o = [[self torosReceived] objectAtIndex:indexPath.row];
    NSString *myName = [[OtoroConnection sharedInstance] user].username;
    if ([o.sender isEqualToString:myName]) {
        return [self createSentCellWithTableView:tableView withToro:o withIndex:indexPath.row];
    } else {
        return [self createReceivedCellWithTableView:tableView withToro:o withIndex:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(IBAction) toTakeToroView:(id) sender
{
    NSLog(@"take toro view");
    
    if (_createToroViewController == nil) {
        _createToroViewController = [[CreateToroViewController alloc] init];
    }

    [[self navigationController] pushViewController:_createToroViewController animated:YES];
}

-(IBAction) toSettingsView:(id) sender
{
    NSLog(@"to settings view");
    
    NSLog(@"take toro view");
    
    if (_settingsViewController == nil) {
        _settingsViewController = [[SettingsViewController alloc] init];
    }
    
    [[self navigationController] pushViewController:_settingsViewController animated:YES];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
