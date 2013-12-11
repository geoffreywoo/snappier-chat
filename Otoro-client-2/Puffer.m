//
//  Toro.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/7/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "Puffer.h"

@implementation Puffer

- (id)initWith:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _toroId = [dict objectForKey:@"_id"];
        _imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://images.pufferchat.com/img/%@",dict[@"image"]]];
     
        // need cache for this instead of poll every time
        // _imageData = [NSData dataWithContentsOfURL:_imageURL];
        
        _read = [[dict objectForKey:@"read"] boolValue];
        _receiver = [dict objectForKey:@"receiver"];
        _sender = [dict objectForKey:@"sender"];
        _message = [dict objectForKey:@"message"];
		_expireTimeInterval = [dict[@"duration"] doubleValue];
		//NSLog(@"%f expire time ", _expireTimeInterval);
      
        _popped = false;
        
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
#warning TODO
    [_timerLabel setFont:[UIFont systemFontOfSize:12]];
	NSInteger minutesLeft = ceil([self.expireDate timeIntervalSinceNow]/60);
	if (minutesLeft > 0)
	{
		[_timerLabel setText:[NSString stringWithFormat:@"%d min left",minutesLeft]];
        [[[self toroViewController] countDown] setText:[NSString stringWithFormat:@"%d min",minutesLeft]];
        
	}
	else
	{
		[_timerLabel setText:@""];
        [[[self toroViewController] countDown] setText:[NSString stringWithFormat:@"Expired"]];
	}
//    if (!_read)
//        [_timerLabel setText:[NSString stringWithFormat:@""]];
//    else if (_read && (_maxTime == _elapsedTime)) {
//        [_timerLabel setText:[NSString stringWithFormat:@""]];
//    } else {
//        int timeLeft = (_maxTime - _elapsedTime);
//        if (timeLeft < 0)
//            [_timerLabel setText:[NSString stringWithFormat:@""]];
//        else
//            [_timerLabel setText:[NSString stringWithFormat:@"%d",timeLeft]];
//    }

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

- (NSComparisonResult)compare:(Puffer*)toro {
	return [self.createdDate compare:toro.createdDate];
}


- (void) print
{
    NSLog(@"sender: %@, receiver: %@, message: %@, venue: %@, timestamp: %@", _sender, _receiver, _message, _venue.name, _createdDate);
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


@end
