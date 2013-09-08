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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    
    [toroTableView addSubview: self.refreshControl];
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
            for (int i = 0; i < [data[@"elements"] count]; i++) {
                Toro *toro = [[Toro alloc] initWith:data[@"elements"][i]];
               // NSLog(@"toro: %@",toro);
                if (![_torosReceived containsObject:toro])
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
    [[toro timerLabel] setText:[NSString stringWithFormat:@"Dead!"]];
}

- (void) makeTimerLabel:(Toro*)toro
{
    if (![toro read])
        [[toro timerLabel] setText:[NSString stringWithFormat:@"View!"]];
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
    [[theToro toroViewController].view removeFromSuperview];
}

- (void) createReceivedCell:(UITableViewCell*) cell withToro:(Toro*)toro withIndex:(NSUInteger) index
{
    cell.textLabel.text = [NSString stringWithFormat:@"%@ at %@", [toro sender], [toro created]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIButton *button = [[UIButton alloc] init];
    button.tag = index;
    CGRect frame = cell.frame;
    [button setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
    [button addTarget:self action:@selector(popToro:) forControlEvents: UIControlEventTouchDown];
    
    [button addTarget:self action:@selector(hideToro:) forControlEvents: UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(hideToro:) forControlEvents: UIControlEventTouchUpOutside];
    
    [cell addSubview:button];
    
    UILabel *timerLabel = [[UILabel alloc] init];
    timerLabel.frame = CGRectMake(frame.size.width - 50,0,50,frame.size.height);
    [timerLabel setBackgroundColor: [UIColor redColor]];
    [toro setTimerLabel:timerLabel];
    [self makeTimerLabel:toro];
    [cell addSubview: [toro timerLabel]];
}

- (void) createSentCell:(UITableViewCell*) cell withToro:(Toro*)toro withIndex:(NSUInteger) index
{
    cell.textLabel.text = [NSString stringWithFormat:@"%@ at %@", [toro receiver], [toro created]];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = self.torosReceived.count - 1 - indexPath.row;
    
   // NSLog(@"cellForRowAtIndexPath");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToroViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ToroViewCell"];
    }
    
    Toro *o = [[self torosReceived] objectAtIndex:index];
    NSString *myName = [[OtoroConnection sharedInstance] user].username;
    if ([o.sender isEqualToString:myName]) {
        [self createSentCell:cell withToro:o withIndex:index];
    } else {
        [self createReceivedCell:cell withToro:o withIndex:index];
    }
    
    return cell;
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
