//
//  SnapperMapAnnotation.h
//  SnapperMap
//
//  Created by Geoffrey Woo on 9/28/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SnapperMapAnnotation : NSObject <MKAnnotation> {
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;
@end
