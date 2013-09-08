//
//  SendToroViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/11/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "CreateToroViewController.h"
#import "OtoroConnection.h"

@interface CreateToroViewController ()

@end

@implementation CreateToroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
       // [self.view sendSubviewToBack:mapView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *bgTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(backgroundTap:)];
    [backgroundView addGestureRecognizer:bgTap];
    
    message.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initLocationManager];
}

- (void)viewDidDisappear:(BOOL)animated
{
    message.hidden = YES;
    message.text = @"";
}

- (void) initLocationManager
{
    NSLog(@"loc manager init");
    [locationManager setDelegate:self];
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"location manager did update locations");
    NSLog(@"%@",locations);
    
    _lastLoc = [locations objectAtIndex:[locations count]-1];
    NSLog(@"lastLoc: %@", _lastLoc);

    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta=0.005;
    span.longitudeDelta=0.005;
    
    region.span=span;
    region.center=_lastLoc.coordinate;
    
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];

    if ([_lastLoc horizontalAccuracy] < 10) {
        [manager stopUpdatingLocation];
    }
    
}

-(void) backgroundTap:(id) sender
{
    NSLog(@"background tapped");
    if (message.hidden) {
        message.hidden = NO;
        [message becomeFirstResponder];
    } else {
        if (message.text.length > 0) {
            if (message.isFirstResponder)
                [message resignFirstResponder];
            else
                [message becomeFirstResponder];
        } else {
            message.hidden = YES;
            [message resignFirstResponder];
        }
    }
}

-(IBAction) backButton:(id) sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}
/*
-(IBAction) friendListButton:(id) sender
{
    NSLog(@"friends view");
    
    if (_friendListViewController == nil) {
        _friendListViewController = [[FriendListViewController alloc] init];
    }
    
    [self.view addSubview:_friendListViewController.view];
}
*/


-(IBAction) sendToroButton:(id) sender
{
    Toro *toro = [[Toro alloc] initOwnToroWithLat:_lastLoc.coordinate.latitude lng:_lastLoc.coordinate.longitude message: message.text];
    _friendListViewController = nil;
    _friendListViewController = [[FriendListViewController alloc] initWithToro:toro];
    //[self.view addSubview:_friendListViewController.view];
    [[self navigationController] pushViewController:_friendListViewController animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
