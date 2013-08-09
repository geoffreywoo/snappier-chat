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
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://otoro.herokuapp.com/user/contents?user=0"]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {       
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {   
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    
    [self.refreshControl endRefreshing];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    NSString *strData = [[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"strData: %@",strData);
    // convert to JSON
    NSError *myError = nil;
    
    NSArray *jsonToros = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"jsonToros: %@",jsonToros);
    
    _torosReceived = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [jsonToros count]; i++) {
        Toro *toro = [[Toro alloc] initWith:[jsonToros objectAtIndex: i]];
        NSLog(@"toro: %@",toro);
        [_torosReceived addObject: toro];
    }
    [toroTableView reloadData];
    [self.refreshControl endRefreshing];
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
        
    }
}

- (Toro *)getToro:(int) toroID
{
    Toro *theToro = nil;
    for (int i = 0; i < [_torosReceived count]; i++) {
        Toro *toro = [_torosReceived objectAtIndex:i];
        if ([toro toroId] == toroID) {
            theToro = toro;
            break;
        }
    }
    return theToro;
}

- (void) popToro:(UIButton*)sender
{
    //NSLog(@"pop toro!");
    Toro *theToro = [self getToro:sender.tag];
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
    Toro *theToro = [self getToro:sender.tag];
    [[theToro toroViewController].view removeFromSuperview];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellForRowAtIndexPath");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToroViewCell"];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ToroItemViewCell"];
    }
    
    Toro *o = [[self torosReceived] objectAtIndex:[indexPath row]];
    NSLog(@"%@",o);
    
    if (![o read]) {
        cell.textLabel.text = [NSString stringWithFormat:@"toro id: %d", [o toroId]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = [o toroId];
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
        cell.textLabel.text = [NSString stringWithFormat:@"toro id: %d", [o toroId]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = [o toroId];
        CGRect frame = cell.frame;
        [button setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        
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
/*    MenuSectionLink *sectionLink = _menu.menuSections[indexPath.section];
    Section *menuSection = sectionLink.section;
    
    if (indexPath.row < menuSection.sectionLinks.count) {
        SectionLink *link = menuSection.sectionLinks[indexPath.row];
        MenuSectionViewController *sectionController = [[MenuSectionViewController alloc] initWithSectionLink:link];
        [self.navigationController pushViewController:sectionController animated:YES];
    }
 */
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
