//
//  ToroViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/4/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Toro.h"

@class Toro;

@interface ToroViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet MKMapView *mapView;
    IBOutlet UILabel *label;

}

@property (nonatomic, strong) Toro *toro;
@property (nonatomic,strong) IBOutlet UILabel *countDown;

- (id)initWithToro:(Toro *)toro;

@end
