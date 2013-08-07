//
//  OtoroContentViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/4/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "OtoroContentViewController.h"
#import "ToroViewController.h"

@implementation OtoroContentViewController

@synthesize responseData = _responseData;
@synthesize torosReceived = _torosReceived;
@synthesize toroMetadata = _toroMetadata;
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
    NSLog(@"%@",strData);
    // convert to JSON
    NSError *myError = nil;
    [self setTorosReceived: [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError]];
    NSLog(@"%@",[self torosReceived]);
    
    _toroMetadata = nil;
    _toroMetadata = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_torosReceived count]; i++) {
        if ([ [[_torosReceived objectAtIndex:i] objectForKey:@"read"] integerValue] == 0) {
            [_toroMetadata addObject:@"unread"];
        } else {
            [_toroMetadata addObject:@"read"];
        }
    }

    [toroTableView reloadData];
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

const int TIMER = 15;
int localCount = 0;

- (void) tick:(NSTimer*)timer
{
    if (localCount < TIMER) {
        localCount++;
    } else {
        localCount = 0;
        [_timer invalidate];
        [_toroViewController.view removeFromSuperview];
        // make the toro "read"
        [_toroMetadata replaceObjectAtIndex:[timer.userInfo integerValue] withObject:@"read"];
    }
}

- (void) popToro:(UIButton*)sender
{
    NSString *toroState = [_toroMetadata objectAtIndex:sender.tag];
    
    if (![toroState isEqualToString:@"read"]) {
        NSLog(@"pop toro!");
        _toroViewController = [[ToroViewController alloc] init];
        [self.view addSubview:_toroViewController.view];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:[NSNumber numberWithInt: sender.tag] repeats:YES];
        [_toroMetadata replaceObjectAtIndex:sender.tag withObject:@"counting"];
    } else {
        
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
    
    NSDictionary *o = [[self torosReceived] objectAtIndex:[indexPath row]];
    NSLog(@"%@",o);
    
    if ([[o objectForKey:@"read"] integerValue] == 0 ) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@, %@, %@, %@", [o objectForKey:@"id"], [o objectForKey:@"lat"], [o objectForKey:@"long"], [o objectForKey:@"sender"], [o objectForKey:@"read"]];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = [indexPath row];
        CGRect frame = cell.frame;
        [button setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [button addTarget:self action:@selector(popToro:) forControlEvents: UIControlEventTouchDown];
        
        [button addTarget:self action:@selector(hideToro) forControlEvents: UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(hideToro) forControlEvents: UIControlEventTouchUpOutside];
        
        [cell addSubview:button];
        
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", [o objectForKey:@"id"], [o objectForKey:@"read"]];
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
