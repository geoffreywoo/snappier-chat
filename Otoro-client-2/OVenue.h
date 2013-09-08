//
//  OVenue.h
//  Otoro-client-2
//
//  Created by Jono on 9/7/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface OVenue : NSObject

@property (nonatomic, strong) NSString *venueID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSURL *thumbnailURL;

@end
