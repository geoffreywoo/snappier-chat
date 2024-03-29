//
//  ToroViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/4/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "ToroViewController.h"
#import "Puffer.h"
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

- (id)initWithToro:(Puffer *)toro
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
    NSLog(@"DISPLAYING:%@",_toro.imageURL);
    [super viewDidLoad];
    
    [self.toro makeTimerLabel];
    
    if (![[_toro message] isEqualToString:@""])
        [_message setText:[NSString stringWithFormat:@"%@",[_toro message]]];
    else
        _message.hidden = YES;
 /*
    NSMutableString *headerStr = [NSMutableString stringWithString:[_toro stringForCreationDate]];
    if ([_toro venue] && ([[_toro venue].name isKindOfClass:[NSString class]])) {
        if (![[_toro venue].name isEqualToString:@""]) {
            [headerStr appendString:[NSString stringWithFormat:@" at %@",[_toro venue].name]];
        }
    }
    [_venue setText:headerStr];
  */
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"view did appear");
}

- (void)landscapeFlip
{
    self.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
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
