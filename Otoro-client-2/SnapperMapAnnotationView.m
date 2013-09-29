//
//  SnapperMapAnnotationView.m
//  SnapperMap
//
//  Created by Geoffrey Woo on 9/28/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SnapperMapAnnotationView.h"

@implementation SnapperMapAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    super.image = [UIImage imageNamed:@"snappermap_inapp_icon_small.png"];
   // [self addSubview:super.image];
	
	return self;
}

@end
