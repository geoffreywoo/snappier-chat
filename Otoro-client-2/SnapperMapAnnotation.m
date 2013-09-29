//
//  SnapperMapAnnotation.m
//  SnapperMap
//
//  Created by Geoffrey Woo on 9/28/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SnapperMapAnnotation.h"

@implementation SnapperMapAnnotation

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	self = [super init];
    if (self) {
        _title = ttl;
        _coordinate = c2d;
	}
    return self;
}

@end
