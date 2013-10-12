//
//  OtoroChooseVenueViewController.h
//  Otoro-client-2
//
//  Created by Jono on 9/7/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OVenue.h"

@class OtoroChooseVenueViewController;
@protocol OtoroChooseVenueViewControllerDelegate <NSObject>
- (void)otoroChooseVenueViewController:(OtoroChooseVenueViewController *)viewController didChooseVenue:(OVenue *)venue;
@end

@interface OtoroChooseVenueViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (nonatomic, strong) CLLocation *lastLoc;
@property (nonatomic, weak) id<OtoroChooseVenueViewControllerDelegate>delegate;
- (instancetype)initWithDelegate:(id<OtoroChooseVenueViewControllerDelegate>)delegate location:(CLLocation *)location;
@end
