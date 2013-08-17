//
//  SendToroViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/11/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SendToroViewController.h"

@interface SendToroViewController ()

@end

@implementation SendToroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        [self initLocationManager];
        [self.view sendSubviewToBack:mapView];
    }
    return self;
}

- (void) initLocationManager
{
    [locationManager setDelegate:self];
    [locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"location manager did update locations");
    NSLog(@"%@",locations);
    
    CLLocation *lastLoc = [locations objectAtIndex:[locations count]-1];
    NSLog(@"lastLoc: %@", lastLoc);
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta=0.005;
    span.longitudeDelta=0.005;
    
    region.span=span;
    region.center=lastLoc.coordinate;
    
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
}

-(IBAction) backButton:(id) sender
{
    [self.view removeFromSuperview];
}

-(IBAction) sendToroButton:(id) sender
{
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://otoro.herokuapp.com/toro/newuser/contents?user=0"]];
    
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
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
