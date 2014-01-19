//
//  Toro.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/7/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "Puffer.h"
#import "PufferConnection.h"

@implementation Puffer

- (id)initWith:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _toroId = [dict objectForKey:@"_id"];
        _imageKey = [dict objectForKey:@"image"];
        
        //TODO: new image host
        _imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://images.pufferchat.com/img/%@",dict[@"image"]]];
        _puffedURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://images.pufferchat.com/puffed/%@",dict[@"image"]]];
        
        _read = [[dict objectForKey:@"read"] boolValue];
        _receiver = [dict objectForKey:@"receiver"];
        _sender = [dict objectForKey:@"sender"];
        _message = [dict objectForKey:@"message"];
		_expireTimeInterval = [dict[@"duration"] doubleValue];
		//NSLog(@"%f expire time ", _expireTimeInterval);
      
        _popped = false;
        _swapped = [[dict objectForKey:@"expired"] boolValue];
        
        _createdDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"created_at"] doubleValue]];
	
		OVenue *venue = [[OVenue alloc] init];
		venue.name = dict[@"venue"];
		venue.venueID = dict[@"venueID"];
		_venue = venue;
        
        _toroViewController = [[ToroViewController alloc] initWithToro:self];
        _timerLabel = [[UILabel alloc] init];
        [_timerLabel setText:[NSString stringWithFormat:@""]];
        [self makeTimerLabel];
    }
    return self;
}

- (id)initOwnToroWithImage:(UIImage *)image expireTimeSetting:(NSTimeInterval)expireTimeInterval message:(NSString *)message venue:(OVenue *)venue
{
    self = [super init];
    if (self) {
		_image = image;
        _message = message;
		_venue = venue;
		_expireTimeInterval = expireTimeInterval;
    }
    return self;
}

- (id) update:(Puffer*)toro {
    _read = [toro read];
    return self;
}

- (void)makeTimerLabel
{
    [_timerLabel setFont:[UIFont systemFontOfSize:10]];
    int secondsLeft = ceil([self.expireDate timeIntervalSinceNow]);
    NSInteger minutesLeft = ceil([self.expireDate timeIntervalSinceNow]/60);
    NSInteger hoursLeft = ceil([self.expireDate timeIntervalSinceNow]/3600);
    if (self.expired)
        [[_toroViewController countDown] setText:[NSString stringWithFormat:@"Expired"]];
    
    if (secondsLeft <= 0) {
        [_timerLabel setText:@""];
        //expire when swap goes through
    } else if (secondsLeft < 60 && secondsLeft > 0) {
        [_timerLabel setText:[NSString stringWithFormat:@"%d s",secondsLeft]];
        [[[self toroViewController] countDown] setText:[NSString stringWithFormat:@"%d s",secondsLeft]];
    } else if (secondsLeft < 3600){
        [_timerLabel setText:[NSString stringWithFormat:@"%d m",minutesLeft]];
        [[[self toroViewController] countDown] setText:[NSString stringWithFormat:@"%d m",minutesLeft]];
    } else {
        [_timerLabel setText:[NSString stringWithFormat:@"%d h",hoursLeft]];
        [[[self toroViewController] countDown] setText:[NSString stringWithFormat:@"%d h",hoursLeft]];
    }
}

- (NSDate *)expireDate
{
	return [_createdDate dateByAddingTimeInterval:_expireTimeInterval];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    Puffer* other = object;
    return [self.toroId isEqualToString:other.toroId];
}

- (BOOL)expired {
    NSComparisonResult result = [[NSDate date] compare:[self expireDate]];
    if (result == -1) return NO;
    return YES;
}

- (void)swap {
    NSLog(@"swap called");
  //  _imageData = nil;
    [[PufferConnection sharedInstance] downloadPhoto:self.imageURL completionBlock:^(NSError *error, NSData *returnData) {
        if (error) {
            
        } else {
            _imageData = returnData;
            [self setImageOnPufferViewController:returnData];
            _swapped = true;
            [[_toroViewController countDown] setText:[NSString stringWithFormat:@"Expired"]];
        }
    }];

}

- (NSComparisonResult)compare:(Puffer*)toro {
	return [self.createdDate compare:toro.createdDate];
}


- (void) print
{
//    NSLog(@"sender: %@, receiver: %@, message: %@, venue: %@, timestamp: %@", _sender, _receiver, _message, _venue.name, _createdDate);
}

- (NSString *)stringForCreationDate
{
	static NSDateFormatter *creationDateFormatter;
	
	if (!creationDateFormatter)
	{
		creationDateFormatter = [[NSDateFormatter alloc]init];
		[creationDateFormatter setLocale:[NSLocale currentLocale]];
		[creationDateFormatter setDateFormat:@"EEE, MMM dd h:mm a"];
	}
	
	return [creationDateFormatter stringFromDate:self.createdDate];
}

- (void) getImageData:(NSURL*)url
{
    //[_toroViewController.imageView setImage:[UIImage imageNamed:@"puffer_large_icon"]];
    [[PufferConnection sharedInstance] downloadPhoto:url completionBlock:^(NSError *error, NSData *returnData) {
        if (error) {
            
        } else {
            _imageData = returnData;
            [self setImageOnPufferViewController:returnData];
        }
    }];
}

- (void) setImageOnPufferViewController:(NSData *)data {
    
    UIImage *rawImage = [UIImage imageWithData:data];
    
    CGFloat scaledWidth = _toroViewController.view.frame.size.height /rawImage.size.height * rawImage.size.width;
    CGSize resizedSize = CGSizeMake(scaledWidth,_toroViewController.view.frame.size.height);
    UIImage *resizedImage = [ToroViewController imageWithImage:rawImage scaledToSize:resizedSize];
    
    [_toroViewController.imageView setImage:resizedImage];
    
    if (rawImage.size.width > rawImage.size.height) {
        [_toroViewController landscapeFlip];
    }
}

@end
