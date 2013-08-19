//
//  SendToroViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/11/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FriendListViewController.h"

@interface SendToroViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *backgroundView;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *sendToroButton;
    IBOutlet UIButton *friendsButton;
    IBOutlet UITextField *message;
}
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) CLLocation *lastLoc;
@property (nonatomic, strong) FriendListViewController *friendListViewController;

-(IBAction) backButton:(id) sender;
-(IBAction) sendToroButton:(id) sender;
-(IBAction) friendListButton: (id) sender;


@end
