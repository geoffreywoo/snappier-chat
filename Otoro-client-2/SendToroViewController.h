//
//  SendToroViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/11/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SendToroViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    IBOutlet MKMapView *mapView;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *sendToroButton;
    IBOutlet UILabel *whereAreYou;
}
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) CLLocation *lastLoc;

-(IBAction) backButton:(id) sender;
-(IBAction) sendToroButton:(id) sender;
-(IBAction) friendListButton: (id) sender;

@end
