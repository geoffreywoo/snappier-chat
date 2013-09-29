//
//  SnapperMapAnnotationView.h
//  SnapperMap
//
//  Created by Geoffrey Woo on 9/28/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SnapperMapAnnotationView : MKAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
