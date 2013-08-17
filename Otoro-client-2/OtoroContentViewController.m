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
#import "SendToroViewController.h"
#import "OtoroConnection.h"

@implementation OtoroContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self handleRefresh];
}

- (void) handleRefresh
{   
    [[OtoroConnection sharedInstance] getAllTorosReceivedWithCompletionBlock:^(NSError *error, NSDictionary *data)
    {
        if (error)
        {
            [self.refreshControl endRefreshing];
        }
        else
        {
            _torosReceived = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [data[@"toros"] count]; i++) {
                Toro *toro = [[Toro alloc] initWith:data[@"toros"][i]];
                NSLog(@"toro: %@",toro);
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
        NSLog(@"%d",[ [self torosReceived] count]);
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

- (void) tick:(NSTimer*)timer
{
    Toro *toro = [timer userInfo];
    if ([toro elapsedTime] < [toro maxTime]) {
        [toro setElapsedTime: [toro elapsedTime] + 1];
        
        int timeLeft = ([toro maxTime] - [toro elapsedTime]);
        [[toro timerLabel] setText:[NSString stringWithFormat:@"%d",timeLeft]];
        [[[toro toroViewController] countDown] setText:[NSString stringWithFormat:@"%d",timeLeft]];
        
    } else {
        [timer invalidate];
        [[toro toroViewController].view removeFromSuperview];
        [toro setElapsedTime:-1];
        
        [self toroDead:toro];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:5000/toros/set_read/%@", toro.toroId]]];
        
        [request setHTTPMethod:@"POST"];
        
        [[NSURLConnection alloc] initWithRequest:request delegate:nil];
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
        
        [self.view addSubview:[theToro toroViewController].view];
        
        [theToro setTimer: [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:theToro repeats:YES]];
        [[theToro timerLabel] setText:[NSString stringWithFormat:@"%d",[theToro maxTime]]];
        [theToro setRead: true];
    } else if ([theToro elapsedTime] != -1) {
        
        [self.view addSubview:[theToro toroViewController].view];
    }
    
}

- (void) hideToro:(UIButton*)sender
{
    Toro *theToro = [[self torosReceived] objectAtIndex:sender.tag];
    [[theToro toroViewController].view removeFromSuperview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellForRowAtIndexPath");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToroViewCell"];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ToroViewCell"];
    }
    
    Toro *o = [[self torosReceived] objectAtIndex:[indexPath row]];
    NSLog(@"%@",o);
    
    if (![o read]) {
        cell.textLabel.text = [NSString stringWithFormat:@"toro id: %@", [o toroId]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = indexPath.row;
        CGRect frame = cell.frame;
        [button setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [button addTarget:self action:@selector(popToro:) forControlEvents: UIControlEventTouchDown];
        
        [button addTarget:self action:@selector(hideToro:) forControlEvents: UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(hideToro:) forControlEvents: UIControlEventTouchUpOutside];
        
        [cell addSubview:button];
        
        UILabel *timerLabel = [[UILabel alloc] init];
        timerLabel.frame = CGRectMake(frame.size.width - 50,0,50,frame.size.height);
        [timerLabel setBackgroundColor: [UIColor redColor]];
        [timerLabel setText: @"View!"];
        [o setTimerLabel:timerLabel];
        
        [cell addSubview: timerLabel];
        
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"toro id: %@", [o toroId]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = [o toroId];
        CGRect frame = cell.frame;
        [button setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [cell addSubview:button];
        
        UILabel *timerLabel = [[UILabel alloc] init];
        timerLabel.frame = CGRectMake(frame.size.width - 50,0,50,frame.size.height);
        [timerLabel setBackgroundColor: [UIColor redColor]];
        [timerLabel setText: @"Dead!"];
        [o setTimerLabel:timerLabel];
        
        [cell addSubview: timerLabel];

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
    
    if (_sendToroViewController == nil) {
        _sendToroViewController = [[SendToroViewController alloc] init];
    }

    [self.view addSubview:_sendToroViewController.view];
}
-(IBAction) toSettingsView:(id) sender
{
    NSLog(@"to settings view");
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
