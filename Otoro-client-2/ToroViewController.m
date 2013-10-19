//
//  ToroViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/4/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "ToroViewController.h"
#import "Toro.h"
#import "SnapperMapAnnotation.h"
#import "SnapperMapAnnotationView.h"
#import "UIImageView+JMImageCache.h"

@implementation ToroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithToro:(Toro *)toro
{
    self = [super initWithNibName: @"ToroViewController" bundle: nil];
    if (self) {
        _toro = toro;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.imageView setImageWithURL:_toro.imageURL];
	
    [[self countDown] setText:[NSString stringWithFormat:@"%d",[[self toro] maxTime]]];
   
    if (![[_toro message] isEqualToString:@""])
        [_message setText:[NSString stringWithFormat:@"%@",[_toro message]]];
    else
        _message.hidden = YES;
    
    NSMutableString *headerStr = [NSMutableString stringWithString:[_toro created_string]];
    if ([_toro venue] && ([[_toro venue].name isKindOfClass:[NSString class]])) {
        if (![[_toro venue].name isEqualToString:@""]) {
            [headerStr appendString:[NSString stringWithFormat:@" at %@",[_toro venue].name]];
        }
    }
    [_venue setText:headerStr];
    
    //[label setText:[NSString stringWithFormat:@"sent from: %@, s/he is at lat/lng: (%f, %f)", [[self toro] sender],location.latitude,location.longitude]];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    if ([annotation isKindOfClass:[SnapperMapAnnotation class]]) {
        NSString *annotationIdentifier = @"SnapperMapAnnotationView";
		SnapperMapAnnotationView *annotationView = (SnapperMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
		if (annotationView == nil) {
		    annotationView = [[SnapperMapAnnotationView alloc] initWithAnnotation:annotation  reuseIdentifier:@"SnapperMapAnnotationView"];
		}
        annotationView.annotation = annotation;
        return annotationView;
	}
    return nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
