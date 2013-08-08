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

@synthesize responseData = _responseData;
@synthesize torosReceived = _torosReceived;
@synthesize toroViewController = _toroViewController;
@synthesize timer = _timer;

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
    NSLog(@"torosReceived: %@", _torosReceived);
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

const int MAX_TIME = 15;

- (void) tick:(NSTimer*)timer
{
    Toro *toro = [timer userInfo];
    if ([toro elapsedTime] < MAX_TIME) {
        [toro setElapsedTime: [toro elapsedTime] + 1];
    } else {
        [timer invalidate];
        [_toroViewController.view removeFromSuperview];
        [toro setElapsedTime:-1];
    }
}

- (void) popToro:(UIButton*)sender
{
    NSLog(@"pop toro!");
    int toroId = sender.tag;
    Toro *theToro;
    for (int i = 0; i < [_torosReceived count]; i++) {
        Toro *toro = [_torosReceived objectAtIndex:i];
        if ([toro toroId] == toroId) {
            theToro = toro;
            break;
        }
    }
    
    if (!theToro) return;
    
    if (![theToro read]) {
        
        _toroViewController = [[ToroViewController alloc] initWithToro:theToro];
        [self.view addSubview:_toroViewController.view];
        
        [theToro setTimer: [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:theToro repeats:YES]];
        [theToro setRead: true];
    } else if ([theToro elapsedTime] != -1) {
        
        [self.view addSubview:_toroViewController.view];
    }
    
}

- (void) hideToro
{
    NSLog(@"hide toro!");
    [_toroViewController.view removeFromSuperview];
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
        cell.textLabel.text = [NSString stringWithFormat:@"%d, %f, %f, %d, %d", [o toroId], [o lat], [o lng], [o senderId], [o read]];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = [o toroId];
        CGRect frame = cell.frame;
        [button setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [button addTarget:self action:@selector(popToro:) forControlEvents: UIControlEventTouchDown];
        
        [button addTarget:self action:@selector(hideToro) forControlEvents: UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(hideToro) forControlEvents: UIControlEventTouchUpOutside];
        
        [cell addSubview:button];
        
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%d, %d", [o toroId], [o read]];
        cell.accessoryType = UITableViewCellAccessoryNone;

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
