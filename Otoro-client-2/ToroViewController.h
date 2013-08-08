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

@interface ToroViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet MKMapView *mapView;
}

@property (nonatomic, strong) Toro *toro;


- (id)initWithToro:(Toro *)toro;

@end
