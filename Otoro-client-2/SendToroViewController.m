//
//  SendToroViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/11/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SendToroViewController.h"
#import "OtoroConnection.h"

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

-(IBAction) backButton:(id) sender
{
    [self.view removeFromSuperview];
}

-(IBAction) sendToroButton:(id) sender
{
    [[OtoroConnection sharedInstance] createNewToroWithLocation:_lastLoc andReceiverUserID:@"geoffreywoo" completionBlock:^(NSError *error, NSDictionary *returnData) {
            if (error) {
        
            } else {
            
            }
        }];
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
