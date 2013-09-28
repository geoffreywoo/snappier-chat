//
//  SendToroViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/11/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "CreateToroViewController.h"
#import "OtoroConnection.h"
#import "OtoroChooseVenueViewController.h"

@interface CreateToroViewController ()<OtoroChooseVenueViewControllerDelegate, FriendListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *chooseVenueButton;
@property (nonatomic, strong) OVenue *venue;
@property (strong, nonatomic) OtoroChooseVenueViewController *chooseVenueViewController;

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
    
	self.chooseVenueButton.titleLabel.adjustsFontSizeToFitWidth = YES;
	
    UITapGestureRecognizer *bgTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(backgroundTap:)];
    [backgroundView addGestureRecognizer:bgTap];
    
    message.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
	[self checkSendToroButton];
    [self initLocationManager];
}

- (void)clearViewState
{
    message.hidden = YES;
    message.text = @"";
	self.venue = nil;
	[self.chooseVenueButton setTitle:@"Where are you?" forState:UIControlStateNormal];	
}

- (void)checkSendToroButton
{
	if (self.venue || message.text.length)
	{
		[sendToroButton setImage:[UIImage imageNamed:@"snappermap_inapp_icon_small"] forState:UIControlStateNormal];
	}
	else
	{
		[sendToroButton setImage:[UIImage imageNamed:@"friends_icon"] forState:UIControlStateNormal];
	}
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
	
	[self checkSendToroButton];
}

-(IBAction) backButton:(id) sender
{
	[self clearViewState];
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

- (IBAction)choosePlaceButtonPressed:(id)sender
{
	if (_lastLoc == nil) return;
    self.chooseVenueViewController = [[OtoroChooseVenueViewController alloc] initWithDelegate:self location:_lastLoc];
	[self.navigationController pushViewController:self.chooseVenueViewController animated:YES];
}

-(IBAction) sendToroButton:(id) sender
{
    Toro *toro = [[Toro alloc] initOwnToroWithLat:_lastLoc.coordinate.latitude lng:_lastLoc.coordinate.longitude message: message.text venue:self.venue];
    _friendListViewController = nil;
    _friendListViewController = [[FriendListViewController alloc] initWithToro:toro delegate:self];
    //[self.view addSubview:_friendListViewController.view];
    [[self navigationController] pushViewController:_friendListViewController animated:YES];
}

#pragma mark - FriendListViewController

- (void)friendListViewController:(FriendListViewController *)viewController didSendToro:(Toro *)toro
{
	[self clearViewState];
	[[self navigationController] popToRootViewControllerAnimated:YES];
}

#pragma mark - OtoroChooseVenueViewControllerDelegate

- (void)otoroChooseVenueViewController:(OtoroChooseVenueViewController *)viewController didChooseVenue:(OVenue *)venue
{
	self.venue = venue;
	[self.chooseVenueButton setTitle:venue.name forState:UIControlStateNormal];
	[self checkSendToroButton];
}
@end
